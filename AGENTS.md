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
| `alacritty/` | Terminal (toml) | ✅ sí |
| `nvim/` | Neovim config (NixCats + Lua) — ver `nvim/AGENTS.md` | ✅ sí |
| `gtk-3.0/` | GTK3 theme settings | ✅ sí |
| `gtk-4.0/` | GTK4 theme settings | ✅ sí |
| `tmux/` | Tmux config (prefix `Ctrl+t`) | ✅ sí |
| `fish/` | Fish shell (Vi mode, Starship) | ✅ sí |
| `ranger/` | File manager | ✅ sí |
| `lazygit/` | Git TUI | ✅ sí |
| `opencode/` | OpenCode config + commands + skills | ✅ en `~/.config/opencode` |

## Arquitectura del sistema

- **Gestión**: Nix + Home Manager (flake en `home-manager/`)
- **Shell principal**: Fish (modo Vi)
- **Terminal**: Alacritty (lanza `tmux` automáticamente)
- **Prompt**: Starship con bloques sólidos Gruvbox
- **Theme general**: Gruvbox Material oscuro (#282828 bg, #ddc7a1 fg, #7daea3 accent)

## Convenciones para agentes

1. **Siempre en español** — respuestas, comentarios en código, nombres de commits
2. **La fuente de verdad es el código fuente** — `home.nix` para paquetes y links
3. **Para añadir un nuevo paquete**: editar `home-manager/home.nix` bajo `home.packages`
4. **Para añadir un nuevo archivo de configuración**: (a) crear el archivo en el directorio correspondiente, (b) añadir `home.file` entry en `home-manager/home.nix`, (c) ejecutar `uhm`
5. **Commits**: formato conventional commits (`fix(scripts):`, `docs:`, etc.)
6. **La rama por defecto es `Master`** (no `main`)
7. **Neovim tiene su propio `nvim/AGENTS.md`** con sus propias reglas
