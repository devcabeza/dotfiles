# tmux

**tmux** es un multiplexor de terminal que permite gestionar múltiples sesiones, ventanas y paneles desde una sola terminal. Todo lo que necesitas para no depender del ratón.

## 🎯 Prefix: `Ctrl+t`

El prefix por defecto (`Ctrl+b`) obliga a estirar los dedos. `Ctrl+t` está justo al lado — el meñique lo alcanza sin moverse del sitio. Más rápido, más cómodo.

Después de `Ctrl+t`:
| Tecla | Acción |
|-------|--------|
| `/` | Split vertical (derecha) |
| `-` | Split horizontal (abajo) |
| `c` | Nueva ventana |
| `,` | Renombrar ventana |
| `h/j/k/l` | Navegar entre paneles |

## 🎨 Tema Gruvbox Material

Status bar en la **parte superior** con colores oscuros Gruvbox Material (`#282828` fondo, `#dfbf8e` texto):

- **Número de sesión** a la izquierda con fondo verde `#a9b665`
- **Ventanas** con separadores powerline ``
- **Ventana activa** resaltada con badge `#45403d`
- **Borde de panel activo** en verde `#a9b665`
- **Fecha y host** a la derecha

## ⌨️ Navegación Vim

| Tecla | Acción |
|-------|--------|
| `h` / `j` / `k` / `l` | Panel izquierdo / abajo / arriba / derecho |
| `Ctrl+h` / `Ctrl+j` / `Ctrl+k` / `Ctrl+l` | Redimensionar 5px |

Splits con el **directorio actual** del panel activo, no el home.

## 📋 Portapapeles Wayland

En copy-mode (`Ctrl+t` + `[`), pulsar `y` copia al portapapeles del sistema mediante `wl-copy` — sin X11, sin xclip, nativo Wayland.

## 🪟 Popups flotantes

Accesos directos que abren aplicaciones en ventanas flotantes (`display-popup`, tmux 3.2+):

| Tecla | App | Ancho/Alto |
|-------|-----|------------|
| `f` | Shell flotante | 80% |
| `g` | **lazygit** | 90% |
| `s` | **lazyssh** | 90% |
| `d` | **lazydocker** | 90% |
| `j` | **lazyjournal** | 90% |
| `o` | **opencode** | 90% |

## 🔌 Plugins (TPM)

| Plugin | Propósito |
|--------|-----------|
| `tmux-plugins/tpm` | Gestor de plugins |
| `tmux-plugins/tmux-sensible` | Valores por defecto sensatos |
| `tmux-plugins/tmux-fzf` | Cambio rápido de ventanas/sesiones con fuzzy search |

Para instalar los plugins: `Ctrl+t` + `I` (mayúscula).

## 🛠️ Utilidades

| Tecla | Acción |
|-------|--------|
| `r` | Recargar configuración |
| `O` | Abrir directorio actual con `xdg-open` |
| `e` | Cerrar todos los paneles excepto el activo |

## 📦 Despliegue

Este `tmux.conf` se despliega mediante **Home Manager**. Está linkeado en `home-manager/home.nix` bajo `home.file`. Para aplicar cambios:

```bash
uhm
```

Equivalente a:

```bash
home-manager switch -b backup --impure --flake ~/.dotfiles/home-manager#alejandrocabeza
```
