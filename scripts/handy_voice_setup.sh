#!/usr/bin/env bash

# handy_voice_setup.sh
# Sets up audio source (Bluetooth or system default), forces rate, routes mode, and toggles Handy transcription.
# Author: Antigravity

LOG_FILE="/tmp/handy_voice_setup.log"
BT_MAC="B0:38:E2:9E:FF:7A"
SOURCE_TYPE_FILE="/tmp/handy_source_type"

echo "=== $(date) ===" >> "$LOG_FILE"

# 1. Force PipeWire rate to 44100 Hz (critical to match Handy's Whisper rate and avoid frame drops)
echo "Forcing clock rate to 44100 Hz..." >> "$LOG_FILE"
pw-metadata -n settings 0 clock.force-rate 44100 >> "$LOG_FILE" 2>&1

# 2. Check if Bluetooth headset is ALREADY connected (DO NOT attempt to connect)
IS_CONNECTED=$(bluetoothctl info "$BT_MAC" 2>/dev/null | grep "Connected: yes")

if [ -n "$IS_CONNECTED" ]; then
    # ===== MODO BLUETOOTH =====
    echo "Bluetooth headset is connected. Setting profile to headset-head-unit-cvsd..." >> "$LOG_FILE"
    notify-send -h string:x-canonical-private-synchronous:hypr-voice-ai "Voice AI" "Usando realme Buds Air7 (Bluetooth)"
    
    # Set card profile to headset-head-unit-cvsd (bidirectional with working microphone)
    pactl set-card-profile "bluez_card.${BT_MAC//:/_}" headset-head-unit-cvsd >> "$LOG_FILE" 2>&1
    
    # Let wireplumber settle the nodes
    sleep 0.3
    
    # Find the bluetooth source node
    BT_SOURCE=$(wpctl status | grep -E "bluez_input.*${BT_MAC//:/_}|realme Buds Air7.*Source" | head -n 1 | awk -F'.' '{print $1}' | tr -cd '0-9')
    if [ -z "$BT_SOURCE" ]; then
        BT_SOURCE=$(wpctl status | grep -iE "bluez_input" | head -n 1 | awk -F'.' '{print $1}' | tr -cd '0-9')
    fi
    
    if [ -n "$BT_SOURCE" ]; then
        echo "Setting default source to Bluetooth node: $BT_SOURCE" >> "$LOG_FILE"
        wpctl set-default "$BT_SOURCE" >> "$LOG_FILE" 2>&1
        wpctl set-volume "$BT_SOURCE" 1.5 >> "$LOG_FILE" 2>&1
    fi
    
    # Save source type for post-processing
    echo "bluetooth" > "$SOURCE_TYPE_FILE"
else
    # ===== MODO SISTEMA (cable, USB-C, HDMI, etc.) =====
    echo "No Bluetooth headset connected. Using system default audio source." >> "$LOG_FILE"
    notify-send -h string:x-canonical-private-synchronous:hypr-voice-ai "Voice AI" "Usando micrófono del sistema"
    
    # Don't change the default source — use whatever the user/system has configured
    echo "wired" > "$SOURCE_TYPE_FILE"
fi

# 3. Route to handy mode and toggle transcription
MODE="$1"
if [ -z "$MODE" ]; then
    MODE="normal"
fi
echo "$MODE" > /tmp/handy_mode
echo "Routing mode to: $MODE" >> "$LOG_FILE"

# Run handy toggle
env PATH=/home/alejandrocabeza/.nix-profile/bin:$PATH handy --toggle-transcription >> "$LOG_FILE" 2>&1
