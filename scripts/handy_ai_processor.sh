#!/usr/bin/env bash

# Handy AI Processor
# Integrates with Handy's "External Script" Paste Method.
# Checks `/tmp/handy_mode` to distinguish between:
# - 'ai': Always executes the transcript as a command via local Ollama.
# - 'normal': Always passes the raw transcript to be pasted.

# Path variables
export PATH="/home/alejandrocabeza/.nix-profile/bin:/home/alejandrocabeza/.local/bin:$PATH"
LOG_FILE="/tmp/handy_ai.log"
MODE_FILE="/tmp/handy_mode"
OLLAMA_URL="http://localhost:11434"
OLLAMA_MODEL="qwen2.5:3b"
SYNC_HINT="-h string:x-canonical-private-synchronous:hypr-voice-ai"

# Log execution
echo "=== $(date) ===" >> "$LOG_FILE"

# Determine mode (defaults to normal)
MODE="normal"
if [ -f "$MODE_FILE" ]; then
    MODE=$(cat "$MODE_FILE")
    rm -f "$MODE_FILE" # Reset for next invocation
fi
echo "Current Mode: $MODE" >> "$LOG_FILE"

# Read transcript from argument or stdin
TRANSCRIPT=""
if [ -n "$1" ]; then
    TRANSCRIPT="$1"
    echo "Source: Argument" >> "$LOG_FILE"
else
    INPUT_DATA=$(cat)
    echo "Raw Input (stdin): $INPUT_DATA" >> "$LOG_FILE"
    if echo "$INPUT_DATA" | jq -e '.transcript' >/dev/null 2>&1; then
        TRANSCRIPT=$(echo "$INPUT_DATA" | jq -r '.transcript')
        echo "Source: Stdin JSON" >> "$LOG_FILE"
    else
        TRANSCRIPT="$INPUT_DATA"
        echo "Source: Stdin Plain" >> "$LOG_FILE"
    fi
fi

echo "Parsed Transcript: $TRANSCRIPT" >> "$LOG_FILE"

# === RESTORE BLUETOOTH QUALITY & PIPEWIRE CLOCK ===
# Now that recording is complete, restore bluetooth headset to high quality A2DP
# and clear forced rate settings so normal audio works perfectly.
echo "Restoring A2DP high-quality profile and resetting clock rate..." >> "$LOG_FILE"
pactl set-card-profile bluez_card.B0_38_E2_9E_FF_7A a2dp-sink >> "$LOG_FILE" 2>&1
pw-metadata -n settings 0 clock.force-rate 0 >> "$LOG_FILE" 2>&1

# Exit early if transcript is empty or null
if [ -z "$TRANSCRIPT" ] || [ "$TRANSCRIPT" = "null" ]; then
    echo "Transcript is empty or null, exiting." >> "$LOG_FILE"
    exit 0
fi

if [ "$MODE" = "ai" ]; then
    echo "Processing command via python: $TRANSCRIPT" >> "$LOG_FILE"
    # Call the python processor to handle selection via hyprlauncher and run under Hyprland
    python3 -u /home/alejandrocabeza/.dotfiles/scripts/handy_ai_processor.py "$TRANSCRIPT" >> "$LOG_FILE" 2>&1
    # Return empty string so Handy doesn't paste anything
    echo -n ""
else
    echo "Normal mode. Typing transcript via wtype." >> "$LOG_FILE"
    # Type the text directly using wtype (Wayland compatible)
    sleep 0.1
    echo -n "$TRANSCRIPT" | wtype -
    # Return empty string to Handy so it finishes its cycle instantly
    echo -n ""
fi
