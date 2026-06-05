#!/usr/bin/env bash
# Wrapper to invoke Whisper for hold-to-talk real-time dictation
# Requires whisper-stream, wtype, wl-copy/xclip, and pw-play/aplay.

# Ensure Nix and local bin directories are in the PATH
export PATH="/home/alejandrocabeza/.nix-profile/bin:/home/alejandrocabeza/.local/bin:$PATH"

WHISPER_STREAM_BIN="/usr/bin/whisper-stream"
MODEL="/home/alejandrocabeza/.local/share/whisper-models/ggml-large-v3-turbo.bin"
PID_FILE="/tmp/whisper_dictation.pid"
LANGUAGE="es" # 'auto' for auto-detection, or 'es' (Spanish), 'en' (English), etc.

# Sounds
START_SOUND="/usr/share/sounds/freedesktop/stereo/bell.oga"
STOP_SOUND="/usr/share/sounds/freedesktop/stereo/complete.oga"
ERROR_SOUND="/usr/share/sounds/freedesktop/stereo/dialog-warning.oga"

ACTION="${1:-toggle}"

play_sound() {
  local sound="$1"
  if [ -f "$sound" ]; then
    if command -v pw-play &>/dev/null; then
      pw-play "$sound" &
    elif command -v aplay &>/dev/null; then
      aplay -q "$sound" &
    fi
  fi
}

send_notification() {
  local title="$1"
  local msg="$2"
  if command -v notify-send &>/dev/null; then
    notify-send "$title" "$msg" -t 1500
  fi
}

# Verify that the binary exists
if [ ! -x "$WHISPER_STREAM_BIN" ]; then
  send_notification "Whisper Error" "whisper-stream binary not found at $WHISPER_STREAM_BIN"
  echo "Error: whisper-stream binary not found at $WHISPER_STREAM_BIN" >&2
  exit 1
fi

# Verify that the model file exists
if [ ! -f "$MODEL" ]; then
  send_notification "Whisper Error" "Model file not found at $MODEL"
  echo "Error: Model file not found at $MODEL" >&2
  exit 1
fi

stop_recording() {
  if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    rm -f "$PID_FILE"
    
    # Kill the background typing loop
    kill "$PID" 2>/dev/null || true
    
    # Kill the whisper-stream process safely using model path match
    pkill -f "whisper-stream.*$MODEL" 2>/dev/null || true
    
    play_sound "$STOP_SOUND"
    send_notification "Dictado" "Micrófono desactivado"
    echo "Dictation stopped."
  else
    echo "No active dictation to stop."
  fi
}

start_recording() {
  # Clean up any existing instances first
  if [ -f "$PID_FILE" ]; then
    stop_recording
    sleep 0.1
  fi

  play_sound "$START_SOUND"
  send_notification "Dictado" "Micrófono activo... Habla ahora."

  # Launch whisper-stream and read output in real-time
  # We use GGML_VK_VISIBLE_DEVICES=1 to force the NVIDIA GPU (Vulkan1)
  export GGML_VK_VISIBLE_DEVICES=1
  
  # Run the streaming and typing loop in the background
  (
    "$WHISPER_STREAM_BIN" \
      -m "$MODEL" \
      -t 8 --step 0 --length 5000 \
      -l "$LANGUAGE" \
      --flash-attn 2>/dev/null | while read -r line; do
        [[ -z "$line" ]] && continue
        [[ "$line" == *"### Transcription"* ]] && continue
        [[ "$line" == *"| t0 ="* ]] && continue
        [[ "$line" == *"[Start speaking]"* ]] && continue

        # Extract text after timestamp bracket if present
        if [[ "$line" =~ \[.*--\>.*\](.*) ]]; then
            line="${BASH_REMATCH[1]}"
        fi

        CLEAN_LINE=$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

        # Skip common silent hallucinations
        if [[ -n "$CLEAN_LINE" ]] && \
           [[ "$CLEAN_LINE" != "[BLANK_AUDIO]" ]] && \
           [[ "$CLEAN_LINE" != "*Mario*" ]] && \
           [[ "$CLEAN_LINE" != "Hvað er það?" ]] && \
           [[ "$CLEAN_LINE" != "Það er bara það." ]]; then
            
            # Send to clipboard
            if command -v wl-copy &>/dev/null; then
              echo -n "$CLEAN_LINE " | wl-copy
            fi
            
            # Simulate typing
            if command -v wtype &>/dev/null; then
              wtype "$CLEAN_LINE "
            fi
        fi
      done
  ) &
  
  RECORD_PID=$!
  echo "$RECORD_PID" > "$PID_FILE"
  echo "Dictation started with PID $RECORD_PID"
}

case "$ACTION" in
  start)
    start_recording
    ;;
  stop)
    stop_recording
    ;;
  toggle)
    if [ -f "$PID_FILE" ]; then
      stop_recording
    else
      start_recording
    fi
    ;;
  *)
    echo "Usage: $0 {start|stop|toggle}" >&2
    exit 1
    ;;
esac
