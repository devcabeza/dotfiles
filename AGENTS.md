# AGENTS.md — dotfiles

Idioma de trabajo: **español**. Todas las respuestas y comentarios deben ser en español.

## Cómo desplegar

La fuente de verdad es `home-manager/home.nix`. Cambiar un archivo de configuración no basta — hay que linkearlo en `home.nix` bajo `home.file`, luego ejecutar:

```bash
uhm
```

El alias `uhm` (definido en `.bashrc`) equivale a:
```
home-manager switch -b backup --impure --flake ~/.dotfiles/home-manager#alejandrocabeza
```

**Sin `uhm` los cambios no toman efecto** — los dotfiles se copian/symlinkean a `~/.config/` durante el switch.

## Qué hace cada directorio

| Dir | Propósito | ¿Linkeado en `home.nix`? |
|-----|-----------|-------------------------|
| `hypr/` | Hyprland Lua config (entry: `hyprland.lua`, +19 módulos en `lua/`) | ✅ sí |
| `waybar/` | Barra de estado Wayland (JSON + CSS) | ✅ sí |
| `alacritty/` | Terminal (toml) | ✅ sí |
| `nvim/` | Neovim config (NixCats + Lua) — ver `nvim/AGENTS.md` | ✅ sí |
| `dunst/` | Notificaciones (solo `dunstrc`) | ❌ **no** — hay que añadirlo |
| `gtk-3.0/` | GTK3 theme settings | ❌ **no** |
| `gtk-4.0/` | GTK4 theme settings | ❌ **no** |
| `swappy/` | Screenshot annotation | ❌ **no** |
| `tmux/` | Tmux config (prefix `Ctrl+t`) | ✅ sí |
| `fish/` | Fish shell (Vi mode, Starship) | ✅ sí |
| `ranger/` | File manager | ✅ sí |
| `lazygit/` | Git TUI | ✅ sí |
| `walker/` | Application launcher | ❌ **no** |
| `scripts/` | Bash scripts estilo Omarchy (`org.omarchy.*` class names) | ✅ adjuntos al repo |
| `opencode/` | OpenCode config + commands + skills | ✅ en `~/.config/opencode` |

Los directorios marcados ❌ fueron creados pero aún no se despliegan hasta que se añadan a `home.nix`.

## Arquitectura del sistema

- **WM**: Hyprland con Lua API (`hl.config`, `hl.bind`, `hl.dsp.*`, etc.)
- **Gestión**: Nix + Home Manager (flake en `home-manager/`)
- **Shell principal**: Fish (modo Vi)
- **Terminal**: Alacritty (lanza `tmux` automáticamente)
- **Prompt**: Starship con bloques sólidos Gruvbox
- **Theme general**: Gruvbox Material oscuro (#282828 bg, #ddc7a1 fg, #7daea3 accent)
- **Launcher**: Walker (no Wofi, el README está desactualizado)
- **Notificaciones**: Dunst (con Gruvbox Material, requiere `uhm` para linkear)

## Patrón "Omarchy"

Los scripts y configuraciones usan un namespace `org.omarchy.*` para identificar apps lanzadas desde terminal como ventanas flotantes. Cada script usa `APP_ID=org.omarchy.<nombre>` como `--class` de Alacritty. Las `windowrules.lua` capturan estas clases y las ponen en modo flotante.

Los 8 scripts Omarchy:
- `org.omarchy.wifi` → `wifi_menu.sh`
- `org.omarchy.bluetui` → `bluetooth_menu.sh`
- `org.omarchy.package-manager` → `package_manager.sh`
- `org.omarchy.keybinds-menu` → `keybinds_menu.sh`
- `org.omarchy.screenshot` → `screenshot.sh`
- `org.omarchy.wallpaper-picker` → `wallpaper_picker.sh`
- `org.omarchy.btop` → `btop_menu.sh`
- `org.omarchy.sysmenu` → `sysmenu.sh`

## Convenciones para agentes

1. **Siempre en español** — respuestas, comentarios en código, nombres de commits
2. **README.md está desactualizado** (menciona ghostty/wofi que ya no se usan, no lista los nuevos módulos Lua ni dunst/gtk/swappy). No confiar en él como fuente de verdad.
3. **La fuente de verdad es el código fuente** — `home.nix` para paquetes y links, `binds.lua` para atajos, `scripts/` para herramientas
4. **Para añadir un nuevo paquete**: editar `home-manager/home.nix` bajo `home.packages`
5. **Para añadir un nuevo archivo de configuración**: (a) crear el archivo en el directorio correspondiente, (b) añadir `home.file` entry en `home-manager/home.nix`, (c) ejecutar `uhm`
6. **Commits**: formato conventional commits (`feat(hypr):`, `fix(scripts):`, `docs:`, etc.)
7. **La rama por defecto es `Master`** (no `main`)
8. **Neovim tiene su propio `nvim/AGENTS.md`** con sus propias reglas
