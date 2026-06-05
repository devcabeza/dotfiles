#!/usr/bin/env bash
# Voice command assistant for Linux/Hyprland using whisper.cpp and Ollama.
# Usage: voice_control.sh {start|stop}

# Ensure Nix and local bin directories are in the PATH
export PATH="/home/alejandrocabeza/.nix-profile/bin:/home/alejandrocabeza/.local/bin:$PATH"

WHISPER_BIN="/usr/bin/whisper-cli"
MODEL="/home/alejandrocabeza/.local/share/whisper-models/ggml-large-v3-turbo.bin"
INPUT_FILE="/tmp/voice_cmd.wav"
OUTPUT_FILE="/tmp/voice_cmd.txt"
PID_FILE="/tmp/voice_cmd.pid"
GPU_DEVICE="1" # NVIDIA GPU

OLLAMA_URL="http://localhost:11434"
OLLAMA_MODEL="qwen2.5:3b"

# Sounds
START_SOUND="/usr/share/sounds/freedesktop/stereo/bell.oga"
STOP_SOUND="/usr/share/sounds/freedesktop/stereo/complete.oga"
ERROR_SOUND="/usr/share/sounds/freedesktop/stereo/dialog-warning.oga"

ACTION="${1:-start}"

play_sound() {
  local sound="$1"
  if [ -f "$sound" ]; then
    if command -v pw-play &>/dev/null; then
      pw-play "$sound" &
    fi
  fi
}

send_notification() {
  local title="$1"
  local msg="$2"
  local urgency="${3:-normal}"
  if command -v notify-send &>/dev/null; then
    notify-send "$title" "$msg" -u "$urgency" -t 3000
  fi
}

start_recording() {
  # Clean up old files
  rm -f "$INPUT_FILE"
  rm -f "$PID_FILE"
  
  play_sound "$START_SOUND"
  send_notification "Asistente de Voz" "Escuchando... Habla ahora."
  
  # Start recording in the background (pw-record)
  if command -v pw-record &>/dev/null; then
    pw-record --rate 16000 --channels 1 --format s16 "$INPUT_FILE" < /dev/null >/dev/null 2>&1 &
    echo "$!" > "$PID_FILE"
  fi
}

stop_recording() {
  if [ -f "$PID_FILE" ]; then
    RECORD_PID=$(cat "$PID_FILE")
    rm -f "$PID_FILE"
    
    kill "$RECORD_PID" 2>/dev/null || true
    wait "$RECORD_PID" 2>/dev/null || true
    
    # Fix the WAV header
    FIXED_INPUT_FILE="/tmp/voice_cmd_fixed.wav"
    rm -f "$FIXED_INPUT_FILE"
    if command -v ffmpeg &>/dev/null; then
      ffmpeg -y -i "$INPUT_FILE" -ar 16000 -ac 1 -c:a pcm_s16le "$FIXED_INPUT_FILE" >/dev/null 2>&1
    else
      cp "$INPUT_FILE" "$FIXED_INPUT_FILE"
    fi
    
    # Run whisper-cli
    rm -f "$OUTPUT_FILE"
    $WHISPER_BIN -dev "$GPU_DEVICE" -m "$MODEL" -l "es" -f "$FIXED_INPUT_FILE" -otxt -of "${OUTPUT_FILE%.txt}" >/dev/null 2>&1
    
    if [ -f "$OUTPUT_FILE" ]; then
      TRANSCRIPTION=$(cat "$OUTPUT_FILE" | xargs)
      
      # Clean transcription
      if [ -n "$TRANSCRIPTION" ] && \
         [ "$TRANSCRIPTION" != "[BLANK_AUDIO]" ] && \
         [ "$TRANSCRIPTION" != "*Mario*" ] && \
         [ "$TRANSCRIPTION" != "Hvað er það?" ] && \
         [ "$TRANSCRIPTION" != "Það er bara það." ]; then
        
        send_notification "Asistente de Voz" "Procesando comando: \"$TRANSCRIPTION\"..."
        
        # Translate to bash command via Ollama
        SYSTEM_PROMPT="Eres un asistente de control por voz para Linux (Hyprland). Tu trabajo es traducir una transcripción de voz del usuario a un único comando de terminal Bash válido.
Ejemplos:
- 'abre firefox' o 'navegar' -> firefox
- 'abre la terminal' o 'consola' -> alacritty
- 'abre nautilus', 'archivos' o 'explorador' -> nautilus
- 'cierra ventana' o 'cerrar esto' -> hyprctl dispatch killactive
- 'apaga la computadora' o 'apagar sistema' -> poweroff
- 'reinicia' -> reboot
- 'busca en google inteligencia artificial' -> xdg-open 'https://www.google.com/search?q=inteligencia+artificial'
- 'abre youtube' -> xdg-open 'https://youtube.com'
- 'musica' o 'reproducir musica' -> xdg-open 'https://music.youtube.com'

Devuelve ÚNICAMENTE el comando bash ejecutable como texto plano. Si el comando no se puede traducir a una acción del sistema válida, responde con la palabra 'ERROR'. No des explicaciones, no uses formato Markdown, ni introducciones."

        OLLAMA_RESPONSE=$(curl -s -X POST "$OLLAMA_URL/api/generate" \
          -H "Content-Type: application/json" \
          -d "$(jq -n --arg model "$OLLAMA_MODEL" --arg prompt "$TRANSCRIPTION" --arg system "$SYSTEM_PROMPT" '{model: $model, prompt: $prompt, system: $system, stream: false}')" \
          2>/dev/null | jq -r '.response' 2>/dev/null | xargs)
        
        if [ -n "$OLLAMA_RESPONSE" ] && [ "$OLLAMA_RESPONSE" != "ERROR" ] && [ "$OLLAMA_RESPONSE" != "null" ]; then
          # Execute the command in the background
          eval "$OLLAMA_RESPONSE" &
          disown
          
          play_sound "$STOP_SOUND"
          send_notification "Comando Ejecutado" "$OLLAMA_RESPONSE" "low"
        else
          play_sound "$ERROR_SOUND"
          send_notification "Asistente de Voz" "Comando no reconocido: \"$TRANSCRIPTION\"" "critical"
        fi
      else
        send_notification "Asistente de Voz" "No se detectó voz o comando vacío." "low"
      fi
    else
      play_sound "$ERROR_SOUND"
      send_notification "Asistente de Voz Error" "Fallo al transcribir el comando." "critical"
    fi
  else
    echo "No active recording to stop."
  fi
}

case "$ACTION" in
  start)
    start_recording
    ;;
  stop)
    stop_recording
    ;;
  *)
    echo "Usage: $0 {start|stop}" >&2
    exit 1
    ;;
esac
