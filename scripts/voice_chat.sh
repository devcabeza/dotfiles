#!/usr/bin/env bash
# ============================================================================
# Antigravity Voice Chat — Asistente de voz conversacional push-to-talk
# ============================================================================
# ALT+I press → graba audio, ALT+I release → transcribe, consulta Ollama, TTS
# Stack: whisper-cli (STT) + Ollama qwen2.5:3b (LLM) + Piper TTS (voz)
# Mantiene historial multi-turno en /tmp/voice_chat_history.json
# ============================================================================

export PATH="/home/alejandrocabeza/.nix-profile/bin:/home/alejandrocabeza/.local/bin:$PATH"

# ── Configuración ──────────────────────────────────────────────────────────
WHISPER_BIN="/usr/bin/whisper-cli"
WHISPER_MODEL="$HOME/.local/share/whisper-models/ggml-large-v3-turbo.bin"
PIPER_MODEL="$HOME/.local/share/piper-tts/es_MX-claude-x_low.onnx"
OLLAMA_URL="http://localhost:11434"
OLLAMA_MODEL="qwen2.5:3b"
HISTORY_FILE="/tmp/voice_chat_history.json"
AUDIO_FILE="/tmp/voice_chat.wav"
PID_FILE="/tmp/voice_chat.pid"
LOG_FILE="/tmp/voice_chat.log"
BT_MAC="B0:38:E2:9E:FF:7A"
GPU_DEVICE="1"
MAX_HISTORY=20

START_SOUND="/usr/share/sounds/freedesktop/stereo/bell.oga"
STOP_SOUND="/usr/share/sounds/freedesktop/stereo/complete.oga"
ERROR_SOUND="/usr/share/sounds/freedesktop/stereo/dialog-warning.oga"

SYSTEM_PROMPT="Eres Antigravity, un asistente de voz para Linux que corre en Hyprland. Responde en español mexicano con tono cálido, amigable y profesional. Sé breve: una a tres oraciones máximo. Si el usuario pide realizar una acción del sistema como abrir apps, ajustar volumen o buscar en internet, indícale amablemente que use SUPER+C para comandos por voz. Puedes mantener conversación casual, dar consejos técnicos, explicar conceptos y ayudar con programación. No uses markdown ni formatos especiales."

# ── Helpers ─────────────────────────────────────────────────────────────────
play_sound() { [ -f "$1" ] && pw-play "$1" 2>/dev/null & }
log() { echo "[$(date '+%H:%M:%S')] $1" >> "$LOG_FILE"; }

notify() {
    local title="$1" msg="$2" urgency="${3:-normal}" timeout="${4:-5000}"
    notify-send -h "string:x-canonical-private-synchronous:hypr-voice-chat" \
        "$title" "$msg" -u "$urgency" -t "$timeout" 2>/dev/null
}

# ── Audio setup / teardown ──────────────────────────────────────────────────
setup_audio() {
    log "Configurando audio (44100 Hz)..."
    pw-metadata -n settings 0 clock.force-rate 44100 2>/dev/null

    if bluetoothctl info "$BT_MAC" 2>/dev/null | grep -q "Connected: yes"; then
        log "BT detectado -> perfil HFP"
        pactl set-card-profile "bluez_card.${BT_MAC//:/_}" headset-head-unit-cvsd 2>/dev/null
        sleep 0.3
        local src
        src=$(wpctl status 2>/dev/null | grep -E "bluez_input.*${BT_MAC//:/_}" | head -1 | awk -F'.' '{print $1}' | tr -cd '0-9')
        [ -n "$src" ] && { wpctl set-default "$src" 2>/dev/null; wpctl set-volume "$src" 1.5 2>/dev/null; }
        echo "bluetooth" > /tmp/handy_source_type
    else
        echo "wired" > /tmp/handy_source_type
    fi
}

restore_audio() {
    log "Restaurando audio..."
    if [ -f /tmp/handy_source_type ] && [ "$(cat /tmp/handy_source_type)" = "bluetooth" ]; then
        pactl set-card-profile "bluez_card.${BT_MAC//:/_}" a2dp-sink 2>/dev/null
    fi
    pw-metadata -n settings 0 clock.force-rate 0 2>/dev/null
}

# ── Historial de conversación ───────────────────────────────────────────────
load_history() { [ -f "$HISTORY_FILE" ] && cat "$HISTORY_FILE" || echo "[]"; }
save_history() { echo "$1" > "$HISTORY_FILE"; }
clear_history() { echo "[]" > "$HISTORY_FILE"; log "Historial reiniciado."; }

add_to_history() {
    local role="$1" content="$2" history
    history=$(load_history)
    history=$(echo "$history" | jq -c --arg role "$role" --arg content "$content" \
        '. + [{role: $role, content: $content}]')
    history=$(echo "$history" | jq -c ".[-$MAX_HISTORY:]")
    save_history "$history"
    echo "$history"
}

# ── START: presionar ALT+I ──────────────────────────────────────────────────
start_recording() {
    log "======================== START ========================"
    rm -f "$AUDIO_FILE" "$PID_FILE"
    setup_audio
    play_sound "$START_SOUND"
    notify "🎤 Antigravity" "Escuchando... habla ahora." "normal" "2000"

    pw-record --rate 16000 --channels 1 --format s16 "$AUDIO_FILE" \
        < /dev/null >/dev/null 2>&1 &
    echo "$!" > "$PID_FILE"
    log "Grabacion iniciada PID=$(cat "$PID_FILE")"
}

# ── STOP: soltar ALT+I ─────────────────────────────────────────────────────
stop_recording() {
    log "======================== STOP ========================"

    # Matar grabacion
    if [ -f "$PID_FILE" ]; then
        kill "$(cat "$PID_FILE")" 2>/dev/null || true
        wait "$(cat "$PID_FILE")" 2>/dev/null || true
        rm -f "$PID_FILE"
    fi
    restore_audio

    # Hay audio?
    if [ ! -f "$AUDIO_FILE" ] || [ ! -s "$AUDIO_FILE" ]; then
        notify "⚠️ Antigravity" "No se detecto audio." "low" "3000"
        return
    fi

    # Corregir WAV y transcribir
    local fixed="/tmp/voice_chat_fixed.wav" transcription
    ffmpeg -y -i "$AUDIO_FILE" -ar 16000 -ac 1 -c:a pcm_s16le "$fixed" 2>/dev/null
    transcription=$("$WHISPER_BIN" -dev "$GPU_DEVICE" -m "$WHISPER_MODEL" \
        -l "es" -f "$fixed" -otxt -of "/tmp/voice_chat_trans" 2>/dev/null && \
        cat /tmp/voice_chat_trans.txt 2>/dev/null | xargs)

    # Validar transcripcion
    if [ -z "$transcription" ] || [ "$transcription" = "[BLANK_AUDIO]" ] || \
       [ "$transcription" = "*Mario*" ]; then
        notify "🔇 Antigravity" "No se detecto voz clara. Intenta de nuevo." "low" "3000"
        return
    fi

    log "Usuario: $transcription"
    notify "📝 Tu" "$transcription" "low" "3000"

    # Comando de salida?
    local lower
    lower=$(echo "$transcription" | tr '[:upper:]' '[:lower:]')
    if echo "$lower" | grep -qEx 'salir|terminar|adios|adios|hasta luego|nos vemos|bye|chao'; then
        clear_history
        notify "👋 Antigravity" "¡Hasta luego! Conversacion finalizada." "normal" "4000"
        play_sound "$STOP_SOUND"
        return
    fi

    # ── Llamada a Ollama (chat mode con historial) ─────────────────────────
    local history messages payload response
    history=$(add_to_history "user" "$transcription")
    messages=$(echo "$history" | jq -c '.')

    payload=$(jq -n \
        --arg model "$OLLAMA_MODEL" \
        --arg system "$SYSTEM_PROMPT" \
        --argjson messages "$messages" \
        '{
            model: $model,
            messages: ([{role: "system", content: $system}] + $messages),
            stream: false,
            options: {temperature: 0.7, num_predict: 256}
        }')

    log "-> Ollama /api/chat"
    response=$(curl -s -X POST "$OLLAMA_URL/api/chat" \
        -H "Content-Type: application/json" \
        -d "$payload" 2>/dev/null | jq -r '.message.content // empty' 2>/dev/null)

    if [ -z "$response" ] || [ "$response" = "null" ]; then
        notify "❌ Antigravity" "Ollama no respondio. Esta corriendo?" "critical" "4000"
        play_sound "$ERROR_SOUND"
        log "ERROR: Ollama sin respuesta"
        return
    fi

    log "Antigravity: $response"
    add_to_history "assistant" "$response"

    # ── Notificar + TTS ────────────────────────────────────────────────────
    notify "🤖 Antigravity" "$response" "normal" "8000"
    play_sound "$STOP_SOUND"

    if [ -f "$PIPER_MODEL" ]; then
        log "Reproduciendo TTS..."
        echo "$response" | piper --model "$PIPER_MODEL" --output-raw 2>>"$LOG_FILE" | pw-play - 2>/dev/null &
    else
        log "AVISO: Modelo Piper no encontrado en $PIPER_MODEL"
        notify "🔇 Sin TTS" "Ejecuta setup_piper_model.sh para instalar la voz." "low" "5000"
    fi
}

# ── Reset manual del historial ──────────────────────────────────────────────
reset_history() {
    clear_history
    notify "🔄 Antigravity" "Historial de conversacion reiniciado." "low" "3000"
}

# ── Entry point ─────────────────────────────────────────────────────────────
case "${1:-start}" in
    start) start_recording ;;
    stop)  stop_recording  ;;
    reset) reset_history   ;;
    *)     echo "Uso: $0 {start|stop|reset}" >&2; exit 1 ;;
esac
