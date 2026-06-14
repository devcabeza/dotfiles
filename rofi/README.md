# 🚀 Rofi — Application Launcher

[Rofi](https://github.com/davatorium/rofi) es un lanzador de aplicaciones y selector de ventanas para X11. En esta configuración se usa como **launcher principal para la sesión Qtile** (X11), mientras que [Walker](../walker/) cumple el mismo rol en Hyprland (Wayland).

## 🎯 ¿Por qué Rofi?

| Característica | Rofi | dmenu | wofi |
|---------------|------|-------|------|
| Modos múltiples | ✅ drun, run, window | ❌ solo stdin | ⚠️ limitado |
| Temas rasi | ✅ completo | ❌ solo Xresources | ⚠️ CSS básico |
| Iconos | ✅ nativo | ❌ | ⚠️ |
| X11 nativo | ✅ | ✅ | ❌ (Wayland) |
| Personalización | ✅ variables, herencia | ❌ | ⚠️ |

Rofi es el launcher ideal para sesiones X11 como Qtile: maduro, rápido, con soporte completo de temas y modos de operación flexibles.

## ✨ Características principales

- **3 modos de operación**: `drun` (apps), `run` (comandos), `window` (ventanas)
- **Tema Gruvbox Material** personalizado con paleta completa
- **Ventana centrada** con bordes redondeados y transparencia
- **2 columnas** para mejor uso del espacio horizontal
- **Iconos habilitados** para identificación visual rápida
- **Labels en español**: "📂 Apps", "⌨ Run", "🪟 Ventanas"

## ⌨️ Atajo de teclado

| Tecla | Acción |
|-------|--------|
| `Alt + Space` | Abrir Rofi (configurado en Qtile) |

> En la sesión Hyprland (Wayland), el launcher es **Walker** con `SUPER + Space`.

## 📂 Archivos de configuración

```
rofi/
├── config.rasi                # Configuración principal
├── themes/
│   └── gruvbox-material.rasi  # Tema Gruvbox Material
└── README.md                  # Este archivo
```

### `config.rasi` — Configuración principal

| Parámetro | Valor | Descripción |
|-----------|-------|-------------|
| `modi` | `drun,run,window` | Modos disponibles (apps, comandos, ventanas) |
| `font` | `monospace 12` | Tipografía del launcher |
| `terminal` | `alacritty` | Terminal por defecto para comandos |
| `show-icons` | `true` | Mostrar iconos de las aplicaciones |
| `drun-display-format` | `{name}` | Mostrar nombre de la app (no el .desktop) |
| `window-display-format` | `{title}` | Mostrar título de la ventana |
| `display-drun` | `📂 Apps` | Label del modo drun |
| `display-run` | `⌨ Run` | Label del modo run |
| `display-window` | `🪟 Ventanas` | Label del modo window |
| `sidebar-mode` | `false` | Sin barra lateral (cambio de modo con Tab) |
| `line-margin` | `8` | Margen vertical entre elementos |
| `line-padding` | `8` | Padding horizontal de cada elemento |
| `columns` | `2` | Dos columnas en la lista |

El tema se aplica con:

```rasi
@theme "themes/gruvbox-material";
```

### `themes/gruvbox-material.rasi` — Tema personalizado

#### Paleta de colores

| Variable | Color | Uso |
|----------|-------|-----|
| `bg` | `#282828` | Fondo principal |
| `bg-alt` | `#32302f` | Fondo alternativo (elementos seleccionados) |
| `bg-dark` | `#1d2021` | Fondo oscuro (inputbar) |
| `fg` | `#ddc7a1` | Texto principal |
| `fg-dim` | `#bdae93` | Texto secundario (placeholders) |
| `accent` | `#7daea3` | Color de acento (teal) |
| `red` | `#ea6962` | Rojo Gruvbox |
| `green` | `#a9b665` | Verde Gruvbox |
| `yellow` | `#d8a657` | Amarillo Gruvbox |
| `purple` | `#d3869b` | Púrpura Gruvbox |
| `gray` | `#928374` | Gris Gruvbox |

#### Estilos de ventana

| Aspecto | Valor |
|---------|-------|
| Ancho | `600px` |
| Transparencia | `rgba(40, 40, 40, 0.88)` — 88% opacidad |
| Posición | Centrada |
| Bordes redondeados | `12px` |
| Borde | `2px` color `accent` |

#### Estilos de elementos

| Widget | Estilo destacado |
|--------|-----------------|
| `inputbar` | Fondo `bg-dark`, padding 8px, bordes redondeados 8px |
| `prompt` | Color `accent` (teal) |
| `entry` | Texto `fg`, placeholder `fg-dim`, cursor `accent` |
| `element selected` | Fondo `bg-alt`, texto `accent` |
| `element-icon` | 24px, padding 8px |
| `scrollbar` | Handle `accent`, fondo `bg-alt`, 6px ancho, redondeado |

## 🎨 Personalización del tema

### Cambiar colores

Edita las variables al inicio de `themes/gruvbox-material.rasi`:

```rasi
* {
    bg: #282828;        /* Fondo principal */
    fg: #ddc7a1;        /* Texto */
    accent: #7daea3;    /* Acento — cambia esto para un look diferente */
}
```

### Cambiar tamaño de ventana

En `themes/gruvbox-material.rasi`, modifica:

```rasi
window {
    width: 800px;           /* Más ancho */
    border-radius: 8px;     /* Menos redondeado */
}
```

### Cambiar número de columnas

En `config.rasi`:

```rasi
configuration {
    columns: 3;    /* Más columnas para pantallas anchas */
}
```

### Cambiar fuente

En `config.rasi`:

```rasi
configuration {
    font: "Hack Nerd Font Mono 14";
}
```

## 🔄 Rofi vs Walker

Este proyecto usa **dos launchers** según la sesión:

| Sesión | WM | Launcher | Atajo |
|--------|-----|----------|-------|
| Wayland | Hyprland | [Walker](../walker/) | `SUPER + Space` |
| X11 | Qtile | **Rofi** | `Alt + Space` |

Rofi es necesario porque Walker depende de Wayland. En X11, Rofi es la alternativa natural y madura.

## 🚀 Despliegue

El directorio `rofi/` se linkea desde `home-manager/home.nix`:

```nix
home.file."rofi".source = ../rofi;
```

Para aplicar cambios:

```bash
uhm   # alias → home-manager switch -b backup --impure --flake ~/.dotfiles/home-manager#alejandrocabeza
```

> ⚠️ **Sin `uhm` los cambios no toman efecto.** Los dotfiles se copian/symlinkean a `~/.config/rofi/` durante el switch de Home Manager.

---

> 🧠 **Fuente de verdad**: Este README describe la configuración actual. Para detalles exactos, consulta `config.rasi` y `themes/gruvbox-material.rasi`.
