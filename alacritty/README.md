# Alacritty

**Alacritty** es un emulador de terminal multiplataforma, acelerado por GPU, escrito en [Rust](https://www.rust-lang.org/).

## 🧠 ¿Por qué Alacritty?

- ⚡ **Rendimiento**: Renderizado vía GPU, mínima latencia, sin parpadeo.
- 📝 **Configuración TOML**: Limpia, legible, sin JavaScript/CSS.
- 🏞️ **Wayland nativo**: Corre directamente bajo Wayland sin capas de compatibilidad.
- 🎯 **Filosofía minimalista**: Solo es un lienzo — no gestiona pestañas ni sesiones.

## 🎨 Configuración visual

| Aspecto | Valor |
|---------|-------|
| Bordes | `none` — totalmente inmersivo |
| Opacidad | 95% translúcida — el blur lo aplica Hyprland |
| Padding | `8px` dinámico |
| Dimensiones | 120×35 columnas |
| Fuente | `Hack Nerd Font Mono` 12pt |
| Tema | Gruvbox Material oscuro (`#282828` bg, `#ddc7a1` fg) |
| Cursor | Block parpadeante |

La transparencia se combina con el `blur` de Hyprland para un efecto vidrio oscuro.

## 🔗 Integración con tmux

Alacritty ejecuta automáticamente `tmux new-session -A -s Main` al arrancar:

```toml
[terminal.shell]
program = "tmux"
args = ["new-session", "-A", "-s", "Main"]
```

Alacritty es el lienzo; **tmux es el gestor de sesiones**.

## ⌨️ Atajos

| Tecla | Acción |
|-------|--------|
| `Alt + C` | Clear screen alternativo (`0x0c`) |

## ✏️ Cómo modificar

```toml
# Cambiar fuente
[font]
size = 14
normal = { family = "FiraCode Nerd Font", style = "Regular" }

# Ajustar opacidad
[window]
opacity = 0.85

# Cambiar colores (ver alacritty.toml para la paleta completa)
[colors.primary]
background = "#1e1e2e"
```

## 🚀 Despliegue

Este directorio está linkeado via `home-manager/home.nix`:

```nix
"alacritty" = { source = ./alacritty; recursive = true; };
```

Los cambios se aplican con:

```bash
uhm
```
