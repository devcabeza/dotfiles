#!/usr/bin/env bash
set -euo pipefail

# Package Manager estilo Omarchy — busca en pacman, AUR y Flatpak
# Usa fzf con preview para seleccionar e instalar paquetes

# Ensure we're running inside a terminal
if [ ! -t 0 ]; then
    exec alacritty --class "org.omarchy.package-manager" -e "$0" "$@"
fi

# Ensure Nix profile is in PATH (needed when launched from Hyprland)
export PATH="$HOME/.nix-profile/bin:$PATH"

fzf_args=(
  --multi
  --preview-window 'down:65%:wrap'
  --preview-label='alt-p: toggle preview, alt-j/k: scroll, tab: multi-select'
  --preview-label-pos='bottom'
  --bind 'alt-p:toggle-preview'
  --bind 'alt-d:preview-half-page-down,alt-u:preview-half-page-up'
  --bind 'alt-k:preview-up,alt-j:preview-down'
  --color 'pointer:green,marker:green'
  --header='[Tab] seleccionar  [Enter] instalar  [alt-p] toggle preview'
  --prompt='Buscar paquete... '
)

# Recopilar paquetes de todas las fuentes con tags
load_packages() {
  # Pacman (repos oficiales)
  pacman -Slq 2>/dev/null | while read -r pkg; do
    echo "[pacman] $pkg"
  done &

  # AUR (vía paru)
  paru -Slqa 2>/dev/null | while read -r pkg; do
    echo "[aur] $pkg"
  done &

  # Flatpak
  flatpak remote-ls --app 2>/dev/null | while read -r _name app_id _version _arch; do
    echo "[flatpak] $app_id"
  done &

  wait
}

# Preview según la fuente
get_preview() {
  local line="$1"
  local tag pkg

  tag=$(echo "$line" | sed 's/^\[\([^]]*\)\].*/\1/')
  pkg=$(echo "$line" | sed 's/^\[[^]]*\] //')

  case "$tag" in
    pacman)
      pacman -Sii "$pkg" 2>/dev/null || echo "No se encontró información del paquete"
      ;;
    aur)
      paru -Si "$pkg" 2>/dev/null || echo "No se encontró información del paquete"
      ;;
    flatpak)
      flatpak info "$pkg" 2>/dev/null || flatpak remote-info flathub "$pkg" 2>/dev/null || echo "No se encontró información del paquete"
      ;;
    *)
      echo "Fuente desconocida"
      ;;
  esac
}

export -f get_preview

# Cargar paquetes en fzf con preview dinámico
selected=$(load_packages | sort -u | fzf "${fzf_args[@]}" \
  --preview 'bash -c "get_preview {}"')

if [[ -z "$selected" ]]; then
  exit 0
fi

# Procesar selecciones por fuente
pacman_pkgs=()
aur_pkgs=()
flatpak_pkgs=()

while IFS= read -r line; do
  tag=$(echo "$line" | sed 's/^\[\([^]]*\)\].*/\1/')
  pkg=$(echo "$line" | sed 's/^\[[^]]*\] //')

  case "$tag" in
    pacman) pacman_pkgs+=("$pkg") ;;
    aur)    aur_pkgs+=("$pkg") ;;
    flatpak) flatpak_pkgs+=("$pkg") ;;
  esac
done <<< "$selected"

# Instalar pacman
if (( ${#pacman_pkgs[@]} > 0 )); then
  echo ""
  echo "═══ Instalando paquetes de pacman ═══"
  sudo pacman -S --noconfirm --needed "${pacman_pkgs[@]}"
fi

# Instalar AUR
if (( ${#aur_pkgs[@]} > 0 )); then
  echo ""
  echo "═══ Instalando paquetes de AUR ═══"
  paru -S --noconfirm --needed "${aur_pkgs[@]}"
fi

# Instalar flatpak
if (( ${#flatpak_pkgs[@]} > 0 )); then
  echo ""
  echo "═══ Instalando paquetes de Flatpak ═══"
  flatpak install -y --noninteractive flathub "${flatpak_pkgs[@]}"
fi

echo ""
echo "═══ Instalación completada ═══"
notify-send "Paquetes instalados" "${#pacman_pkgs[@]} pacman, ${#aur_pkgs[@]} AUR, ${#flatpak_pkgs[@]} flatpak" -u normal