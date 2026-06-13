# 🧰 Scripts de Automatización — dotfiles

Este directorio contiene **todos los scripts de automatización** del sistema, incluyendo los 8 scripts con namespace **Omarchy** que se lanzan como ventanas flotantes en Hyprland.

---

## 📦 El patrón Omarchy

Cada script Omarchy usa el namespace `org.omarchy.<nombre>` como clase de ventana (`--class`) de Alacritty. Esto permite que Hyprland — a través de `windowrules.lua` — los detecte automáticamente y los ponga en **modo flotante**, centrados y con el tamaño adecuado.

### Mecanismo

1. El script lanza Alacritty con `--class "org.omarchy.<nombre>"`
2. Hyprland captura la clase mediante `hl.window_rule()` en `windowrules.lua`
3. La ventana se muestra flotante, centrada y con dimensiones predefinidas

### Tamaños flotantes

| Script | Clase | Tamaño |
|---|---|---|
| wifi_menu.sh | `org.omarchy.wifi` | 700×450 |
| bluetooth_menu.sh | `org.omarchy.bluetui` | 700×450 |
| package_manager.sh | `org.omarchy.package-manager` | 900×600 |
| keybinds_menu.sh | `org.omarchy.keybinds-menu` | 700×500 |
| screenshot.sh | `org.omarchy.screenshot` | 700×450 |
| wallpaper_picker.sh | `org.omarchy.wallpaper-picker` | 800×600 |
| btop_menu.sh | `org.omarchy.btop` | 900×600 |
| sysmenu.sh | `org.omarchy.sysmenu` | 350×220 |
| text_extraction.sh | `org.omarchy.text-extraction` | 700×450 |
| audio_output_switch.sh | `org.omarchy.audio-output` | 500×300 |
| screenrecord.sh | `org.omarchy.screenrecord` | 700×450 |
| gaps_toggle.sh | `org.omarchy.gaps-toggle` | 400×200 |
| close_all_windows.sh | `org.omarchy.close-all` | 400×200 |
| mic_toggle.sh | `org.omarchy.mic-toggle` | 400×200 |

### Cómo crear un nuevo script Omarchy

1. **Crear el script** con el siguiente esquema básico:
   ```bash
   #!/usr/bin/env bash
   APP_ID="org.omarchy.mi-script"

   if [ -z "$ALACRITTY_WINDOW_ID" ]; then
       exec alacritty --class "$APP_ID" -e "$0" "$@"
   fi

   # ... lógica del script ...
   ```

2. **Añadir la window rule** en `hypr/lua/windowrules.lua`:
   ```lua
   hl.window_rule({
       match = { class = "^org\\.omarchy\\.mi-script$" },
       float = true,
       size = { 800, 600 },
       center = true,
   })
   ```

3. **Registrar el keybind** en `hypr/lua/binds.lua`:
   ```lua
   hl.bind(m.mainMod .. " + X", hl.dsp.exec_cmd("~/.dotfiles/scripts/mi_script.sh"))
   ```

4. **Ejecutar `uhm`** solo si el script necesita un paquete nuevo en `home.nix`

---

## 📋 Tabla completa de scripts

| Clase / Script | Función | Atajo | Dependencias |
|---|---|---|---|
| `org.omarchy.wifi` — `wifi_menu.sh` | Gestión WiFi (nmtui) | `SUPER + N` | nmtui |
| `org.omarchy.bluetui` — `bluetooth_menu.sh` | Gestión Bluetooth (bluetui) | `SUPER + B` | bluetui |
| `org.omarchy.package-manager` — `package_manager.sh` | Buscar e instalar paquetes Nix (fzf) | `SUPER + SHIFT + P` | nix, fzf |
| `org.omarchy.keybinds-menu` — `keybinds_menu.sh` | Mostrar atajos de teclado | `SUPER + /` | — |
| `org.omarchy.screenshot` — `screenshot.sh` | Captura de pantalla smart (grim + slurp + swappy) | `SUPER + SHIFT + S` | grim, slurp, swappy, wl-clipboard, hyprpicker |
| `org.omarchy.wallpaper-picker` — `wallpaper_picker.sh` | Selector de wallpapers (fzf + swaybg) | `SUPER + P` | fzf, swaybg, killall |
| `org.omarchy.btop` — `btop_menu.sh` | Monitor de recursos (btop) | — | btop |
| `org.omarchy.sysmenu` — `sysmenu.sh` | Menú de sistema (lock, suspend, reboot, poweroff) | `SUPER + Escape` | hyprlock, systemd |
| `org.omarchy.text-extraction` — `text_extraction.sh` | OCR de pantalla (tesseract + grim + slurp) | `SUPER + SHIFT + T` | grim, slurp, tesseract, wl-clipboard |
| `org.omarchy.screenrecord` — `screenrecord.sh` | Grabación de pantalla (wf-recorder) | `SUPER + SHIFT + R` | wf-recorder, slurp, hyprpicker |
| `org.omarchy.audio-output` — `audio_output_switch.sh` | Cambiar entre salidas de audio | `SUPER + SHIFT + A` | pactl, wpctl, jq |
| `org.omarchy.gaps-toggle` — `gaps_toggle.sh` | Quitar/restaurar gaps entre ventanas | `SUPER + ALT + G` | hyprctl |
| `org.omarchy.close-all` — `close_all_windows.sh` | Cerrar todas las ventanas del workspace | `SUPER + ALT + W` | hyprctl, jq |
| `org.omarchy.mic-toggle` — `mic_toggle.sh` | Silenciar/activar micrófono con notificación | `SUPER + SHIFT + M` | wpctl, dunst |
| — `battery_present.sh` | Detectar si hay batería presente (exit 0/1) | — | /sys/class/power_supply |
| — `battery_capacity.sh` | Capacidad total de batería en Wh | — | upower |
| — `battery_remaining.sh` | Porcentaje restante de batería | — | upower |
| — `battery_remaining_time.sh` | Tiempo restante formateado | — | upower |
| — `battery_status.sh` | Estado completo de batería (%, tiempo, W, Wh) | — | upower |
| — `monitor_scale.sh` | Obtener escala del monitor activo | — | hyprctl, jq |
| — `monitor_watch.sh` | Detectar conexión/desconexión de monitores | *(autostart opcional)* | socat, hyprctl |
| — `hw_intel.sh` | Detectar CPU Intel (exit 0/1) | — | /proc/cpuinfo |
| — `hw_match.sh` | Detectar modelo de hardware por DMI | — | /sys/class/dmi/id |
| — `hw_external_monitors.sh` | Detectar monitores externos conectados | — | /sys/class/drm |
| — `hw_touchpad.sh` | Obtener nombre del touchpad | — | hyprctl, jq |
| — `terminal_cwd.sh` | Obtener directorio actual del terminal activo | — | hyprctl, procps |
| — `wallpaper_carousel.sh` | Carrusel automático de wallpapers (~30 min) | *(autostart)* | swaybg, coreutils |
| — `voice_control.sh` | Iniciar/detener Handy (control por voz) | `SUPER + C` (start/release stop) | handy |
| — `voice_control_handy.sh` | Proxy de voz para Handy | — | handy |
| — `handy_voice_setup.sh` | Configuración Handy (normal/AI) | `ALT + I` / `ALT + SHIFT + I` | handy |
| — `handy_ai_processor.py` | Procesador AI en Python para Handy | — | python3, openai |
| — `handy_ai_processor.sh` | Shell wrapper del procesador AI | — | — |
| — `whisper-dictation.sh` | Dictado por voz con Whisper STT | — | whisper.cpp, jq |
| — `ranger_scope.sh` | Previsualizaciones para Ranger | *(integrado en rc.conf)* | Ranger, ffmpegthumbnailer, pandoc |

> **Nota**: `SUPER` es la tecla Windows/Command. `ALT` es la tecla Alt.

---

## 🔧 Dependencias principales

| Paquete | Uso |
|---|---|
| `nmtui` | Interfaz TUI para NetworkManager (WiFi) |
| `bluetui` | Interfaz TUI para Bluetooth |
| `fzf` | Navegación difusa en menús (paquetes, wallpapers) |
| `grim` / `slurp` | Captura de pantalla en Wayland |
| `swappy` | Anotación de capturas |
| `swaybg` | Gestión de fondos de pantalla |
| `btop` | Monitor de recursos |
| `hyprlock` | Bloqueo de pantalla |
| `wl-clipboard` | Portapapeles en Wayland (wl-copy) |
| `handy` | Asistente de voz |
| `whisper.cpp` | Speech-to-text local |
| `ffmpegthumbnailer` | Miniaturas de vídeo (Ranger) |
| `tesseract` | OCR para extracción de texto de pantalla |
| `wf-recorder` | Grabación de pantalla en Wayland |
| `ffmpeg` | Procesamiento de vídeo (screen recording) |
| `pandoc` | Previsualización de documentos (Ranger) |
| `socat` | Escucha de sockets (monitor_watch, opcional) |
| `upower` | Información de batería |

---

## 🚀 Despliegue

Los scripts **no necesitan `uhm` para existir** — están en el repositorio y se referencian con rutas absolutas (`/home/alejandrocabeza/.dotfiles/scripts/`) desde `binds.lua` y `autostart.lua`.

Sin embargo, si un script introduce **nuevas dependencias** (ej. `btop`, `bluetui`, `handy`), hay que:

1. Añadir el paquete a `home-manager/home.nix` bajo `home.packages`
2. Ejecutar `uhm` para que Home Manager lo instale

Resumen:
- **Script nuevo sin dependencias** → crear el archivo + window rule + keybind → no hace falta `uhm`
- **Script nuevo con paquetes nuevos** → crear archivo + window rule + keybind + editar `home.nix` + `uhm`

> ⚠️ `ranger_scope.sh` es independiente: Ranger lo invoca por configuración interna (`rc.conf`), no necesita clase Omarchy ni window rule.
