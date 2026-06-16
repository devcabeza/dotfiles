# 🪟 Qtile — Omarchy Minimalist Configuration

**Qtile** es un tiling window manager escrito en Python, 100% hackeable. Esta configuración sigue la filosofía **Omarchy**: minimalista, funcional y enfocada en productividad para desarrollo.

> 📸 Screenshot próximamente

---

## ✨ Características

| Característica | Detalle |
|----------------|---------|
| **Barra minimalista** | Solo 5 widgets: CurrentLayoutIcon, GroupBox, WindowName, Spacer, Clock (`%H:%M`) |
| **Layouts** | `MonadTall` (principal) + `Max` (secundario) |
| **Tema** | Gruvbox Material Dark (`#282828` bg, `#ddc7a1` fg, `#7daea3` accent) |
| **Workspace cycling** | `Super+←/→` para navegar entre workspaces |
| **Control preciso** | `Shift+volumen/brillo` para ajustes de ±1% |
| **Atajos dev** | `Super+Return` (terminal), `Super+b` (browser), `Super+Space` (rofi) |
| **Autostart** | Solo wallpaper (feh) + `nm-applet` |

---

## ⌨️ Atajos de Teclado

### 🖥️ Aplicaciones

| Atajo | Acción |
|-------|--------|
| `Super+Return` | Terminal (Alacritty) |
| `Super+b` | Firefox |
| `Super+Shift+b` | Gestor de archivos (Thunar) |
| `Super+Space` | Rofi launcher (drun) |
| `Super+Shift+Space` | Selector de ventanas (rofi) |

### 🏗️ Navegación (Vim)

| Atajo | Acción |
|-------|--------|
| `Super+h/j/k/l` | Mover foco ← ↓ ↑ → |
| `Super+Shift+h/j/k/l` | Mover ventana |
| `Super+Ctrl+h/j/k/l` | Redimensionar ventana |
| `Super+n` | Restablecer tamaños |
| `Super+Shift+Return` | Alternar división |

### 🔄 Workspaces

| Atajo | Acción |
|-------|--------|
| `Super+←` | Workspace anterior |
| `Super+→` | Workspace siguiente |
| `Super+1..9` | Ir al workspace N |
| `Super+Shift+1..9` | Mover ventana al workspace N |

### 🔊 Multimedia

| Atajo | Acción |
|-------|--------|
| `Vol ↑/↓` | ±5% |
| `Shift+Vol ↑/↓` | ±1% (preciso) |
| `Mute` | Silenciar |
| `Brillo ↑/↓` | ±5% |
| `Shift+Brillo ↑/↓` | ±1% (preciso) |

### 📸 Sistema

| Atajo | Acción |
|-------|--------|
| `Print` | Captura completa (grim) |
| `Shift+Print` | Captura de área (grim+slurp) |
| `Super+Ctrl+r` | Recargar config (hot reload) |
| `Super+Ctrl+q` | Cerrar Qtile |
| `Super+w` | Cerrar ventana |
| `Super+f` | Pantalla completa |
| `Super+Tab` | Siguiente layout |

---

## 🎨 Tema Gruvbox Material

```
Barra bg  → #32302f (bg0)
Texto fg  → #ddc7a1 (fg)
Accent    → #7daea3 (blue)
Inactivo  → #928374 (gray)
Urgente   → #ea6962 (red)
```

Barra con 95% de opacidad, borde inferior azul de 2px, margen de 8px.

---

## 📁 Estructura

```
qtile/
├── config.py     # Toda la configuración
└── README.md     # Este archivo
```

Todo vive en `config.py` — colores, atajos, layouts, widgets y hooks en un solo archivo Python.

---

## 🚀 Despliegue

Linkeado via `home-manager/home.nix` como `.config/qtile`.

```bash
uhm                          # aplicar symlink
# luego Super+Ctrl+r          # recargar Qtile en caliente
```

> ⚠️ Sin `uhm` los cambios no llegan a `~/.config/qtile/`.

---

## 🧪 Tests

```bash
cd ~/.dotfiles && python3 tests/test_qtile_omarchy.py
```

Valida que la configuración cumple con los estándares Omarchy.

---

## 🖱️ Ratón

| Acción | Atajo |
|--------|-------|
| Arrastrar ventana flotante | `Super+Click izquierdo` |
| Redimensionar flotante | `Super+Click derecho` |
| Traer al frente | `Super+Click medio` |

---

<p align="center">
  <sub>Hecho con ☕ y Python</sub>
</p>
