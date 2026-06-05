#!/usr/bin/env bash

# Voice command assistant using Handy and local Ollama
# Usage: voice_control_handy.sh

# Ensure paths
export PATH="/home/alejandrocabeza/.nix-profile/bin:/home/alejandrocabeza/.local/bin:$PATH"

OLLAMA_URL="http://localhost:11434"
OLLAMA_MODEL="qwen2.5:3b"

# Visual settings
SYNC_HINT="-h string:x-canonical-private-synchronous:hypr-voice-ai"

# Prompt template explaining the instructions for mapping Spanish input to Linux commands
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
- 'sube el volumen' -> wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
- 'baja el volumen' -> wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
- 'silencio' -> wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

Devuelve ÚNICAMENTE el comando bash ejecutable como texto plano. Si el comando no se puede traducir a una acción del sistema válida, responde con la palabra 'ERROR'. No des explicaciones, no uses formato Markdown, ni introducciones."

# Open wofi to get the text input
# The user can focus this, press Alt+I, speak, Handy types it, and user presses Enter.
INPUT_TEXT=$(wofi --dmenu --prompt "Dicta un comando con Handy (Alt+I)..." --width 500 --height 100)

# Exit if cancelled
if [ -z "$INPUT_TEXT" ]; then
    exit 0
fi

# Visual feedback
notify-send $SYNC_HINT "Asistente AI" "Procesando comando: \"$INPUT_TEXT\"..." -t 2000

# Call Ollama local API
OLLAMA_RESPONSE=$(curl -s -X POST "$OLLAMA_URL/api/generate" \
  -H "Content-Type: application/json" \
  -d "$(jq -n --arg model "$OLLAMA_MODEL" --arg prompt "$INPUT_TEXT" --arg system "$SYSTEM_PROMPT" '{model: $model, prompt: $prompt, system: $system, stream: false}')" \
  2>/dev/null | jq -r '.response' 2>/dev/null | xargs)

if [ -n "$OLLAMA_RESPONSE" ] && [ "$OLLAMA_RESPONSE" != "ERROR" ] && [ "$OLLAMA_RESPONSE" != "null" ]; then
  # Execute the command
  eval "$OLLAMA_RESPONSE" &
  disown
  
  notify-send $SYNC_HINT "Comando Ejecutado" "$OLLAMA_RESPONSE" -u low -t 3000
else
  notify-send $SYNC_HINT "Asistente AI" "No se reconoció la acción para: \"$INPUT_TEXT\"" -u critical -t 3000
fi
