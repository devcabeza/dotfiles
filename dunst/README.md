# Dunst — Notificaciones

[Dunst](https://dunst-project.org/) es un gestor de notificaciones ligero para Wayland y X11. Muestra las notificaciones del sistema de forma minimalista y configurable.

## 🎨 Configuración visual

- **Posición**: esquina superior derecha (`top-right`)
- **Offset**: `16x52` — justo debajo de Waybar
- **Tamaño**: 320×300 px
- **Fondo**: `#282828` (oscuro), texto `#ddc7a1` (claro)
- **Frame**: `#504945`, 1 px de grosor
- **Separador**: color del frame
- **Fuente**: `JetBrainsMono Nerd Font 10`
- **Transparencia**: 5 %
- **Límite**: 5 notificaciones visibles
- **Markup**: `full` (soporta HTML en el cuerpo)
- **Iconos**: 24–48 px, alineados a la izquierda

## ⚠️ Urgencias

| Urgencia | Foreground | Highlight | Timeout |
|----------|-----------|-----------|---------|
| LOW      | `#a89984` | `#7daea3` (teal) | 5 s |
| NORMAL   | `#ddc7a1` | `#a9b665` (verde) | 8 s |
| CRITICAL | `#ea6962` (rojo) | `#ea6962` (rojo) | ∞ |

## ⌨️ Keybindings

| Tecla | Acción |
|-------|--------|
| `Print` | `dunstctl history-pop` — mostrar última notificación |
| `Scroll_Lock` | `dunstctl close` — cerrar notificación activa |
| `SUPER` + `SHIFT` + `N` | `dunstctl history` — abrir historial |
| `SUPER` + `SHIFT` + `D` | `dunstctl set-paused toggle` — modo no molestar |

## 🔗 Integración con Hyprland

Los atajos se definen en `hypr/binds.lua`. Además, se aplica `layerrule` para difuminar el fondo (`blur`).

## 🚀 Despliegue

El archivo `dunstrc` se linkea a `~/.config/dunst/dunstrc` via `home-manager/home.nix` con Home Manager. Para aplicar cambios:

```bash
uhm
```
