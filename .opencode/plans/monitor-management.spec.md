# Monitor Management - Technical Specification

## 1. Feature Overview
**Why**: El usuario no tiene una forma fácil de seleccionar, configurar (escala, resolución, tamaño) ni gestionar monitores externos cuando conecta su laptop a un monitor. Tampoco puede configurar comportamientos como "cerrar tapa → solo monitor externo".

**What**: Sistema dual de gestión de monitores compuesto por:
1. **Script Omarchy TUI** (`monitor_menu.sh`) para control manual interactivo con perfiles predefinidos
2. **Daemon kanshi** para automatización de perfiles según monitores conectados/desconectados

**Scope IN**:
- Script TUI estilo Omarchy (Alacritty + fzf) para seleccionar/configurar monitores
- Perfiles predefinidos: Solo laptop, Solo externo, Extendido derecha, Espejo
- Ajuste de escala interactivo (1.0, 1.25, 1.5, 2.0)
- Ajuste de resolución interactivo (modos disponibles del monitor)
- Perfiles automáticos con kanshi (detectar plug/unplug)
- Soporte para "cerrar tapa → solo externo"
- Notificaciones de cambios con dunst
- Integración con el patrón Omarchy (window rules, binds, APP_ID)

**Scope OUT**:
- No se implementa GUI gráfica (wdisplays, nwg-displays)
- No se implementa rotación de pantalla (se puede añadir después)
- No se implementa gestión avanzada de layout (arrastrar monitores visualmente)
- No se implementa perfiles por aplicación/workspace

## 2. User Stories
- Como usuario de laptop con monitor externo, quiero un menú rápido para cambiar entre "solo laptop", "solo externo", "extendido" y "espejo", para adaptar mi espacio de trabajo según donde esté.
- Como usuario que cierra la tapa de su laptop, quiero que automáticamente el monitor externo se active como único display, para trabajar sin interrupciones.
- Como desarrollador, quiero ajustar la escala de un monitor (ej. 1.5 en 4K), para que los textos sean legibles.
- Como usuario con múltiples resoluciones, quiero seleccionar la resolución de cada monitor, para optimizar espacio y claridad.
- Como usuario de Hyprland, quiero que los cambios se apliquen en caliente sin reiniciar la sesión.

## 3. Functional Requirements
- [ ] **FR1: Script detecta monitores** — `monitor_menu.sh` debe detectar todos los monitores conectados vía `hyprctl monitors -j` y mostrar sus propiedades (nombre, resolución actual, escala, posición)
- [ ] **FR2: Selección de perfil** — Menú con perfiles: "🖥️ Solo laptop", "📺 Solo externo", "↔️ Extendido derecha", "🪞 Espejo", "🔍 Ajustar escala", "📐 Cambiar resolución"
- [ ] **FR3: Perfil "Solo laptop"** — Habilita eDP-1 con resolución preferida, deshabilita todos los demás monitores
- [ ] **FR4: Perfil "Solo externo"** — Detecta el primer monitor externo conectado, lo habilita con resolución preferida, deshabilita eDP-1
- [ ] **FR5: Perfil "Extendido derecha"** — eDP-1 a la izquierda (0x0), externo a la derecha (al ancho de eDP-1 x 0)
- [ ] **FR6: Perfil "Espejo"** — Ambos monitores con la misma resolución y posición (0x0)
- [ ] **FR7: Ajuste de escala** — Submenú con opciones 1.0, 1.25, 1.5, 2.0 aplicado al monitor seleccionado
- [ ] **FR8: Ajuste de resolución** — Submenú con modos disponibles del monitor (obtenidos de `hyprctl monitors -j`), aplica el seleccionado
- [ ] **FR9: Kanshi se inicia con Hyprland** — Daemon de kanshi lanzado en autostart
- [ ] **FR10: Perfiles kanshi** — Configuración con 3 perfiles: `solo_laptop`, `extendido`, `solo_externo`
- [ ] **FR11: Kanshi detecta tapa cerrada** — Cuando eDP-1 se desconecta (lid closed), kanshi aplica perfil `solo_externo`
- [ ] **FR12: Notificaciones** — Los cambios de monitor generan notificaciones con dunst (ej. "Monitor: Modo extendido activado")
- [ ] **FR13: Keybind** — `SUPER + O` lanza el menú de monitores
> **Nota de desviación aprobada**: El spec original especificaba `SUPER + SHIFT + D`, pero esa combinación ya está ocupada por `dunstctl set-paused toggle` (binds.lua línea 146). Se cambió a `SUPER + O` (O de "monitOr") durante la implementación.
- [ ] **FR14: Window rule** — Ventana flotante para `org.omarchy.monitor-menu` (900x650, centrada)

## 4. Technical Constraints
- **Stack**: Bash, hyprctl, jq, fzf, kanshi, dunst
- **Pattern**: Omarchy (APP_ID, window rules, flotante centrado, binds absolutos)
- **Runtime changes**: `hyprctl keyword monitor` para cambios en caliente (NO editar monitors.lua)
- **Automation**: kanshi daemon con archivo de configuración en dotfiles
- **Deploy**: Los scripts no necesitan `uhm`; kanshi sí necesita instalación y link en home.nix
- **PATH**: Usar `export PATH="$HOME/.nix-profile/bin:$PATH"` en scripts
- **Idioma**: Notificaciones y mensajes en español

## 5. Success Criteria (Definition of Done)
- [ ] `monitor_menu.sh` existe, es ejecutable y muestra el menú correctamente
- [ ] Cada perfil aplica la configuración esperada (verificable con `hyprctl monitors`)
- [ ] El keybind `SUPER + O` lanza el script (verificable en binds.lua)
- [ ] La window rule existe en windowrules.lua y la ventana aparece flotante
- [ ] kanshi está instalado en home.nix
- [ ] kanshi/config existe con 3 perfiles
- [ ] kanshi se inicia en autostart.lua
- [ ] Al desconectar/conectar un monitor, kanshi cambia el perfil automáticamente
- [ ] Todos los scripts existentes (monitor_scale.sh, hw_external_monitors.sh, monitor_watch.sh) siguen funcionando
- [ ] `uhm` se ejecuta exitosamente

## 6. Edge Cases & Error Handling
| Scenario | Expected Behavior |
|----------|-------------------|
| No hay monitor externo conectado | Perfiles "Solo externo" y "Extendido" muestran error y notifican |
| El monitor externo se desconecta mientras está activo | Kanshi detecta y cambia a solo_laptop automáticamente |
| La tapa se cierra sin monitor externo | Kanshi mantiene solo_laptop (eDP-1 sigue siendo el único) |
| Monitor externo con resolución no estándar | Se usa su modo preferido (primer modo de la lista) |
| Escala no soportada por el monitor | Si falla, se restaura la escala anterior y se notifica |
| hyprctl falla | Se muestra mensaje de error y se sale con código 1 |
| Varios monitores externos conectados | Se selecciona el primero (HDMI-A-1 > DP-1 > DP-2) |

## 7. Data Model (if applicable)
No aplica — no hay base de datos. La configuración se almacena en:
- `scripts/monitor_menu.sh` — Lógica del menú TUI
- `kanshi/config` — Perfiles automáticos
- `hypr/lua/windowrules.lua` — Regla de ventana flotante
- `hypr/lua/binds.lua` — Keybind
- `hypr/lua/autostart.lua` — Inicio de kanshi
- `home-manager/home.nix` — Paquete kanshi + link de configuración

## 8. API Contract (if applicable)
No aplica — interacción vía CLI (`hyprctl keyword monitor`) y daemon (kanshi).

## 9. Security Considerations
- No se manejan datos sensibles
- Los scripts se ejecutan con permisos de usuario (no requieren sudo)
- hyprctl solo afecta la sesión del usuario actual
- El script valida que los monitores existen antes de aplicar cambios
