#!/usr/bin/env bash
# Descarga el modelo de voz Piper TTS - Espanol Mexicano (voz: claude, calidad: low)
set -euo pipefail

MODEL_DIR="$HOME/.local/share/piper-tts"
BASE_URL="https://huggingface.co/rhasspy/piper-voices/resolve/main/es/es_MX/claude/low"
MODEL_FILE="es_MX-claude-x_low.onnx"
CONFIG_FILE="es_MX-claude-x_low.onnx.json"

mkdir -p "$MODEL_DIR"

echo "Descargando modelo Piper TTS (es_MX - claude)..."
curl -fL --progress-bar -o "$MODEL_DIR/$MODEL_FILE" "$BASE_URL/$MODEL_FILE"
curl -fL --progress-bar -o "$MODEL_DIR/$CONFIG_FILE" "$BASE_URL/$CONFIG_FILE"

echo ""
echo "Modelo instalado en $MODEL_DIR"
echo "Prueba: echo 'Hola, como estas?' | piper --model $MODEL_DIR/$MODEL_FILE --output-raw | pw-play -"
