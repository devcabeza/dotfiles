#!/usr/bin/env bash

# handy_voice_setup.sh
# Sets up Bluetooth card, forces rate, routes mode, and toggles Handy transcription.
# Author: Antigravity

LOG_FILE="/tmp/handy_voice_setup.log"
MAC="B0:38:E2:9E:FF:7A"

echo "=== $(date) ===" >> "$LOG_FILE"

# 1. Force PipeWire rate to 44100 Hz (critical to match Handy's Whisper rate and avoid frame drops)
echo "Forcing clock rate to 44100 Hz..." >> "$LOG_FILE"
pw-metadata -n settings 0 clock.force-rate 44100 >> "$LOG_FILE" 2>&1

# 2. Check if realme Buds Air7 is connected. If not, try to connect it.
IS_CONNECTED=$(bluetoothctl info "$MAC" | grep "Connected: yes")

if [ -z "$IS_CONNECTED" ]; then
    echo "Bluetooth headset not connected. Attempting connection..." >> "$LOG_FILE"
    # Send notification so user knows we are trying to connect
    notify-send -h string:x-canonical-private-synchronous:hypr-voice-ai "Voice AI" "Conectando realme Buds Air7..."
    bluetoothctl connect "$MAC" >> "$LOG_FILE" 2>&1
    sleep 2.0 # Wait a bit for connection and node initialization
fi

# Double check connection
IS_CONNECTED=$(bluetoothctl info "$MAC" | grep "Connected: yes")
if [ -n "$IS_CONNECTED" ]; then
    echo "Bluetooth headset is connected. Setting profile to headset-head-unit-cvsd..." >> "$LOG_FILE"
    
    # 3. Ensure card profile is set to headset-head-unit-cvsd (bidirectional with working microphone)
    pactl set-card-profile bluez_card.B0_38_E2_9E_FF_7A headset-head-unit-cvsd >> "$LOG_FILE" 2>&1
    
    # Let wireplumber settle the nodes
    sleep 0.2
    
    # 4. Set default source to the bluetooth microphone node
    BT_SOURCE=$(wpctl status | grep -E "bluez_input|realme Buds Air7.*Source" | head -n 1 | awk -F'.' '{print $1}' | tr -cd '0-9')
    if [ -z "$BT_SOURCE" ]; then
        BT_SOURCE="bluez_input.B0:38:E2:9E:FF:7A"
    fi
    echo "Setting default source to Bluetooth node: $BT_SOURCE" >> "$LOG_FILE"
    wpctl set-default "$BT_SOURCE" >> "$LOG_FILE" 2>&1
    
    # Ensure source volume is set high (150%) for clear voice dictation
    wpctl set-volume "$BT_SOURCE" 1.5 >> "$LOG_FILE" 2>&1
else
    echo "Warning: Bluetooth headset could not be connected. Using default system input." >> "$LOG_FILE"
    notify-send "Voice AI" "Advertencia: realme Buds Air7 no conectados. Usando micrófono por defecto."
fi

# 5. Route to handy mode and toggle transcription
MODE="$1" # 'normal' or 'ai'
if [ -z "$MODE" ]; then
    MODE="normal"
fi
echo "$MODE" > /tmp/handy_mode
echo "Routing mode to: $MODE" >> "$LOG_FILE"

# Run handy toggle
env PATH=/home/alejandrocabeza/.nix-profile/bin:$PATH handy --toggle-transcription >> "$LOG_FILE" 2>&1
