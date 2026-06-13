# Mejoras Omarchy en Hyprland — Especificación Técnica

## 1. Descripción General

**Por qué**: La configuración actual de Hyprland tiene vacíos respecto a la distribución Omarchy v3.8 (basecamp/omarchy). Omarchy incluye refinamientos de usabilidad y robustez que faltan.

**Qué**: Implementar 16 mejoras agrupadas en 7 archivos de configuración Lua bajo `hypr/lua/`.

**Scope (IN)**:
- Añadir/configurar groupbar (tabs visuales)
- Añadir repeat_rate, repeat_delay, numlock_by_default
- Añadir touchpad clickfinger_behavior + scroll_factor
- Añadir cursor.hide_on_key_press
- Añadir resize_on_border, dwindle.force_split
- Añadir disable_scale_notification, anr_missed_pings
- Cambiar focus_on_activate de false a true
- Cambiar on_focus_under_fullscreen de 2 a 1
- Añadir hide_special_on_workspace_change
- Añadir window rules: suppress_event maximize, XWayland fix
- Añadir systemd env imports en autostart

**Scope (OUT)**:
- NO cambiar a layout scrolling (se mantiene dwindle)
- NO añadir gradiente en bordes (se mantiene color sólido Gruvbox #7daea3)
- NO añadir sistema de opacidad por tags (se mantiene inactive_opacity)
- NO añadir hypridle (requiere configuración adicional de hyprlock)
- NO añadir fcitx5 (no necesario para teclado US-intl)
- NO cambiar el orquestrador (se mantiene pcall/require actual)

## 2. User Stories

- Como usuario de teclado, quiero repetición de teclas más rápida (repeat_rate=40) para navegar eficientemente.
- Como usuario con numpad, quiero numlock activado por defecto al iniciar sesión.
- Como usuario de touchpad, quiero click derecho con dos dedos y scroll más lento.
- Como usuario que escribe, quiero que el cursor desaparezca al teclear (hide_on_key_press).
- Como usuario de grupos (tabs), quiero ver la barra de grupos con las ventanas agrupadas.
- Como usuario de escritorio, quiero consistencia en el split de ventanas (force_split=2).
- Como usuario de scratchpad, quiero que desaparezca al cambiar de workspace (hide_special).
- Como usuario del sistema, quiero detección de apps colgadas (anr_missed_pings).

## 3. Requisitos Funcionales

- [ ] RF1: Groupbar visual con height=20, font_size=10, gradients=true
- [ ] RF2: repeat_rate=40, repeat_delay=250 en input
- [ ] RF3: numlock_by_default=true en input
- [ ] RF4: touchpad.clickfinger_behavior=true, touchpad.scroll_factor=0.4
- [ ] RF5: cursor.hide_on_key_press=true
- [ ] RF6: general.resize_on_border=false
- [ ] RF7: dwindle.force_split=2 (junto a preserve_split existente)
- [ ] RF8: misc.disable_scale_notification=true
- [ ] RF9: misc.anr_missed_pings=3
- [ ] RF10: misc.focus_on_activate=true (era false)
- [ ] RF11: misc.on_focus_under_fullscreen=1 (era 2)
- [ ] RF12: binds.hide_special_on_workspace_change=true
- [ ] RF13: window rule suppress_event="maximize" para todas las ventanas
- [ ] RF14: XWayland window rule para no_focus en ventanas fantasma
- [ ] RF15: systemctl import-environment y dbus-update-activation-environment en autostart

## 4. Restricciones Técnicas

- Stack: Hyprland Lua API (hl.config, hl.window_rule, hl.exec_cmd)
- Sólo modificar archivos existentes — NO crear nuevos módulos
- Mantener compatibilidad con Nix + Home Manager (no tocar home.nix)
- Mantener todas las window rules existentes, sólo añadir nuevas al final
- Mantener todos los autostart existentes, sólo añadir nuevos
- NO cambiar variables globales (_G.hypr) ni binds existentes
- NO modificar la paleta Gruvbox Material (colores existentes)
- Los cambios deben ser sintácticamente válidos en Lua

## 5. Criterios de Éxito

- [ ] El archivo hyprland.lua carga los 7 módulos sin errores
- [ ] `hyprctl configinfo` no muestra errores sintácticos
- [ ] groupbar visible al agrupar ventanas (Mod+G)
- [ ] repeat_rate y repeat_delay aplican al teclear
- [ ] numlock activo al iniciar sesión
- [ ] Cursor desaparece al escribir
- [ ] Touchpad responde a clickfinger_behavior
- [ ] El scratchpad no persiste al cambiar workspace
- [ ] Las apps no se redimensionan al arrastrar bordes accidentalmente
- [ ] `uhm` ejecuta sin errores

## 6. Edge Cases

| Escenario | Comportamiento Esperado |
|-----------|-------------------------|
| No hay ventanas agrupadas | groupbar no se muestra |
| XWayland app sin clase/título | No recibe foco automático |
| Workspace sin ventanas special | hide_special_on_workspace_change no afecta |
| App maximizada y se cambia foco | fullscreen se mantiene (on_focus_under_fullscreen=1) |
| ANR: app deja de responder tras 3 pings | Hyprland muestra notificación |

## 7. Mapa de Archivos Afectados

| Archivo | Cambios |
|---------|---------|
| hypr/lua/decorations.lua | + groupbar config |
| hypr/lua/input.lua | + repeat_rate, repeat_delay, numlock, touchpad |
| hypr/lua/cursor.lua | + hide_on_key_press |
| hypr/lua/general.lua | + resize_on_border, force_split |
| hypr/lua/misc.lua | + disable_scale_notification, anr, focus_on_activate, on_focus, hide_special |
| hypr/lua/windowrules.lua | + suppress_event, XWayland fix |
| hypr/lua/autostart.lua | + systemd env imports |
