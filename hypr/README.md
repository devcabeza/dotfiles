# 🪟 Hyprland — Configuración Modular en Lua

![Hyprland](https://img.shields.io/badge/WM-Hyprland-7daea3?style=flat)
![Lua](https://img.shields.io/badge/Config-Lua-000080?style=flat)
![Wayland](https://img.shields.io/badge/Protocol-Wayland-7daea3?style=flat)
![Módulos](https://img.shields.io/badge/Módulos-18-blueviolet?style=flat)

> Configuración de **Hyprland**, el compositor Wayland, escrita íntegramente en **Lua** usando su API nativa. Dividida en **18 módulos independientes**, organizada por responsabilidad y desplegada vía Home Manager.

---

## 📋 Tabla de Contenidos

- [🎯 ¿Por qué Hyprland?](#-por-qué-hyprland)
- [🏗️ Arquitectura Modular](#️-arquitectura-modular)
- [📂 Estructura del Directorio](#-estructura-del-directorio)
- [🔧 Los 18 Módulos](#-los-18-módulos)
- [🎨 Configuración Visual](#-configuración-visual)
- [🪟 Window Rules & Layer Rules](#-window-rules--layer-rules)
- [⌨️ Keybindings](#️-keybindings)
- [🚀 Autostart](#-autostart)
- [📦 Despliegue](#-despliegue)

---

## 🎯 ¿Por qué Hyprland?

Hyprland no es solo "otro compositor Wayland". Fue elegido después de probar Sway, River y Wayfire por estas razones:

| Razón | Por qué importa |
|-------|----------------|
| **Wayland nativo** | Sin capas X11. Sin XWayland forzado. Rendimiento puro. |
| **API Lua oficial** | `hl.config()`, `hl.bind()`, `hl.dsp.*` — configuración con un lenguaje real, no un DSL limitado. |
| **Animaciones fluidas** | Curvas bezier personalizadas, 10 hojas de animación configurables por separado. |
| **Blur performante** | Blur optimizado por GPU con 2 passes, noise controlado, contraste ajustable. |
| **Window groups (tabs)** | Agrupación de ventanas nativa con navegación por teclado (SUPER+G, SUPER+Tab). |
| **Ecosistema completo** | Hyprlock, Hypridle, Hyprpicker, Hyprsunset, Hyprpolkitagent — todo del mismo proyecto. |
| **Rendimiento en hardware modesto** | VFR, direct scanout, explicit sync — mínima latencia, máximo FPS. |

---

## 🏗️ Arquitectura Modular

Un solo archivo de configuración monolítico es difícil de mantener y navegar. Por eso Hyprland está dividido en **18 módulos Lua**, cada uno con una responsabilidad única.

### Principios del diseño modular

| Principio | Aplicación |
|-----------|------------|
| **Separación de concerns** | Cada archivo toca un aspecto: decoraciones, animaciones, input, binds, etc. |
| **Orden de carga explícito** | `hyprland.lua` define el orden: variables → helpers → hardware → visual → reglas → servicios → binds |
| **Errores aislados** | `pcall(require, module)` — si un módulo falla, los demás siguen funcionando |
| **Global compartida** | `_G.hypr` expone `mainMod`, `terminal`, `filemanager`, `menu` a todos los módulos |
| **Reutilización** | `helpers.lua` define `o.bind()` que envuelve `hl.bind()` con `hl.dsp.exec_cmd()` automático |

### Orden de carga (definido en `hyprland.lua`)

```
variables → helpers → monitors → input → general → decorations →
animations → cursor → gestures → misc → render → opengl → xwayland →
ecosystem → windowrules → layerrules → autostart → binds
```

---

## 📂 Estructura del Directorio

```
hypr/
├── hyprland.lua           # 🚀 Entry point (carga los 18 módulos)
├── hyprlauncher.conf      # 🔍 Config del launcher secundario (Alfred-style)
├── old.hyprland.conf      # 📜 Config legacy (referencia, formato Hyprland)
└── lua/                   # 📦 18 módulos Lua
    ├── env.lua
    ├── variables.lua
    ├── helpers.lua
    ├── monitors.lua
    ├── input.lua
    ├── general.lua
    ├── decorations.lua
    ├── animations.lua
    ├── cursor.lua
    ├── gestures.lua
    ├── misc.lua
    ├── render.lua
    ├── opengl.lua
    ├── xwayland.lua
    ├── ecosystem.lua
    ├── windowrules.lua
    ├── layerrules.lua
    ├── autostart.lua
    └── binds.lua
```

---

## 🔧 Los 18 Módulos

### 🧱 Base del Sistema

| Módulo | Archivo | Propósito |
|--------|---------|-----------|
| **env** | `env.lua` | Variables de entorno Wayland: `GDK_BACKEND=wayland,x11`, `QT_QPA_PLATFORM=wayland`, `MOZ_ENABLE_WAYLAND=1`, `XCURSOR_SIZE=24`, `XCURSOR_THEME=Bibata-Modern-Classic`, `ELECTRON_OZONE_PLATFORM_HINT=wayland` |
| **variables** | `variables.lua` | Variables globales en `_G.hypr`: `mainMod=SUPER`, `altMod=ALT`, `terminal=alacritty`, `filemanager=nautilus`, `menu=hyprlauncher --dmenu` |
| **helpers** | `helpers.lua` | Función `o.bind()` que envuelve `hl.bind()` con `hl.dsp.exec_cmd()` automático cuando el dispatcher es string |

### 🖥️ Hardware & Pantalla

| Módulo | Archivo | Propósito |
|--------|---------|-----------|
| **monitors** | `monitors.lua` | Configuración de monitores: resolución 1920×1080@60, escala 1x, posición 0x0 |
| **input** | `input.lua` | Teclado: layout `us` variante `altgr-intl`, compose:menu, terminate_ctrl_alt_bksp, repeat_rate=40, repeat_delay=250, numlock_by_default. Touchpad: natural_scroll desactivado, clickfinger_behavior, scroll_factor=0.4 |

### 🎨 Apariencia Visual

| Módulo | Archivo | Propósito |
|--------|---------|-----------|
| **general** | `general.lua` | Gaps (5px internos, 10px externos), bordes 2px teal `#7daea3`, layout dwindle, preserve_split, resize_on_border=false, force_split |
| **decorations** | `decorations.lua` | Redondeo 10px, opacidad (activa 1.0, inactiva 0.92), blur 5px/2 passes, sombras suaves `#1a1a1aee`, groupbar visual personalizado |
| **animations** | `animations.lua` | 10 hojas de animación, curva bezier personalizada `myBezier(0.05,0.9,0.1,1.05)`, popin 80% en salidas |
| **cursor** | `cursor.lua` | Sin hardware cursors, timeout 5s inactive, hide_on_key_press, sync gsettings, hotspot_padding 2. Tema Bibata vía env vars |

### 🎭 Comportamiento & UX

| Módulo | Archivo | Propósito |
|--------|---------|-----------|
| **gestures** | `gestures.lua` | Swipe de 3 dedos entre workspaces, distance 300px, direction lock, creación automática de nuevos workspaces |
| **misc** | `misc.lua` | Sin logo, splash ni scale_notification, VRR desactivado, DPMS, background `#1D2021`, focus_on_activate, anr_missed_pings=3, close_special_on_empty, hide_special_workspace |

### ⚡ Render & GPU

| Módulo | Archivo | Propósito |
|--------|---------|-----------|
| **render** | `render.lua` | Direct scanout nivel 2 (máxima prioridad), expand_undersized_textures |
| **opengl** | `opengl.lua` | Anti-flicker de NVIDIA desactivado (no se usa GPU NVIDIA) |

### 🔄 Compatibilidad

| Módulo | Archivo | Propósito |
|--------|---------|-----------|
| **xwayland** | `xwayland.lua` | Force zero scaling en XWayland, sin nearest neighbor |
| **ecosystem** | `ecosystem.lua` | `no_donation_nag = true` — sin el mensaje de donación al iniciar |

### 📜 Reglas

| Módulo | Archivo | Propósito |
|--------|---------|-----------|
| **windowrules** | `windowrules.lua` | 22 reglas: apps Omarchy flotantes, asignación a workspaces (Firefox→1, Alacritty→2, VS Code→3), suppress_event, XWayland fix |
| **layerrules** | `layerrules.lua` | Blur en waybar, notificaciones (dunst) y gtk-layer-shell. Sin blur en hyprlauncher para máxima legibilidad |

### 🚀 Servicios & Atajos

| Módulo | Archivo | Propósito |
|--------|---------|-----------|
| **autostart** | `autostart.lua` | Servicios que arrancan con Hyprland: dbus, systemd env import, hyprlauncher, swaybg, waybar, handy, dunst, hyprpolkitagent |
| **binds** | `binds.lua` | ~40 keybindings: apps, navegación, workspaces, multimedia, sistema, grupos |

---

## 🎨 Configuración Visual

La apariencia sigue la paleta **Gruvbox Material Oscuro**:

```
Fondo     → #282828      Frente    → #ddc7a1
Acento    → #7daea3      Borde     → #7daea3 (activo) / #504945 (inactivo)
Sombra    → #1a1a1aee    Background → #1D2021
```

### Parámetros clave

| Aspecto | Valor | Detalle |
|---------|-------|---------|
| **Gaps internos** | 5px | Espacio entre ventanas |
| **Gaps externos** | 10px | Margen al borde del monitor |
| **Borde activo** | 2px, `#7daea3` | Teal Gruvbox |
| **Borde grupo** | `#7daea3` / `#504945` | Mismos colores en groupbar de tabs |
| **Borde inactivo** | 2px, `#504945` | Gris oscuro |
| **Redondeo** | 10px | Esquinas suaves en ventanas |
| **Opacidad activa** | 1.0 | 100% |
| **Opacidad inactiva** | 0.92 | Sutil translucidez |
| **Blur** | 5px, 2 passes | Suave, no agresivo |
| **Sombras** | offset 3×3, range 4 | Sutil profundidad |
| **Layout** | Dwindle | Dividido recursivo |
| **Sin gaps when only** | ✅ | Una ventana ocupa toda la pantalla |
| **Groupbar** | height=20, font_size=10 | Barra visual con colores en grupos de ventanas |
| **Resize on border** | Desactivado | Evita redimensionar ventanas al arrastrar el borde accidentalmente |

### Animaciones

10 hojas de animación con una curva bezier personalizada:

```lua
hl.curve("myBezier", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })
```

| Hoja | Speed | Bezier | Extra |
|------|-------|--------|-------|
| windows | 8 | myBezier | — |
| windowsOut | 8 | linear | popin 80% |
| border | 10 | linear | — |
| fade | 6 | linear | — |
| workspaces | 6 | linear | — |
| layers | 6 | myBezier | — |
| layersOut | 6 | myBezier | popin 80% |
| fadeLayers | 6 | myBezier | — |
| fadeLayersOut | 6 | myBezier | — |
| borderangle | 10 | linear | loops -1 |

---

## 🪟 Window Rules & Layer Rules

### Window Rules (22 reglas en `windowrules.lua`)

Todas las apps **Omarchy** flotan automáticamente con tamaño y centrado predefinido:

| Clase | Tamaño | Comportamiento |
|-------|--------|----------------|
| `org.omarchy.wifi` | 700×450 | Flotante, centrada |
| `org.omarchy.bluetui` | 700×450 | Flotante, centrada |
| `org.omarchy.package-manager` | 900×600 | Flotante, centrada |
| `org.omarchy.keybinds-menu` | 700×500 | Flotante, centrada |
| `org.omarchy.screenshot` | 700×450 | Flotante, centrada |
| `org.omarchy.wallpaper-picker` | 800×600 | Flotante, centrada |
| `org.omarchy.btop` | 900×600 | Flotante, centrada |
| `org.omarchy.sysmenu` | 350×220 | Flotante, centrada (menú pequeño) |

Además, flotan automáticamente: `pavucontrol`, `org.gnome.Calculator` (galculator), `org.pwmt.zathura`, `mpv`, `imv`, `org.keepassxc.KeePassXC`, y el **Picture-in-Picture** de Firefox (480×270, fijado en pantalla).

**Asignación a workspaces:**

| Clase | Workspace |
|-------|-----------|
| `firefox` (excepto PiP) | 1 |
| `Alacritty` | 2 |
| `code-oss` / `Code` | 3 |


**Reglas de sistema:**

| Regla | Propósito |
|-------|-----------|
| `suppress_event = "maximize"` | Evita comportamientos erráticos en apps al maximizar |
| `no_focus` en XWayland vacías | Ignora ventanas XWayland sin clase/título que aparecen al conectar monitores |

### Layer Rules (4 reglas en `layerrules.lua`)

| Namespace | Blur | ignore_alpha | Nota |
|-----------|------|--------------|------|
| `waybar` | ✅ + blur_popups | 0.2 | Barra con fondo difuso |
| `notifications` (dunst) | ✅ | 0.2 | Notificaciones con blur |
| `gtk-layer-shell` | ✅ | 0.2 | Diálogos GTK |
| `launcher` (hyprlauncher) | ❌ | — | Sin blur para máxima legibilidad |

---

## ⌨️ Keybindings

~40 binds organizados por categoría. La **SUPER** key (`❖ Windows`) es la modificadora principal, **ALT** para el launcher y voz.

### Aplicaciones

| Atajo | Acción |
|-------|--------|
| `SUPER + Return` | Alacritty (lanza tmux automáticamente) |
| `SUPER + F` | Nautilus (gestor de archivos) |
| `ALT + Space` | Hyprlauncher (lanzador Alfred-style) |
| `SUPER + Q` | Cerrar sesión de Hyprland |
| `SUPER + W` | Cerrar ventana activa |
| `SUPER + M` | Fullscreen toggle |
| `SUPER + Shift + M` | Float toggle |

### Navegación (estilo Vim)

| Atajo | Acción |
|-------|--------|
| `SUPER + H` | Focus izquierda |
| `SUPER + J` | Focus abajo |
| `SUPER + K` | Focus arriba |
| `SUPER + L` | Focus derecha |
| `SUPER + Shift + H/J/K/L` | Swap ventana en dirección |
| `SUPER + Shift + flechas` | Redimensionar ventana |

### Workspaces

| Atajo | Acción |
|-------|--------|
| `SUPER + 1-4` | Ir al workspace N |
| `SUPER + Shift + 1-4` | Mover ventana al workspace N |
| `SUPER + ]` / `SUPER + [` | Siguiente / anterior workspace |
| `SUPER + Shift + ]` / `SUPER + Shift + [` | Mover ventana al siguiente/anterior |
| `SUPER + -` | Toggle scratchpad (workspace especial "magic") |
| `SUPER + Shift + -` | Enviar ventana al scratchpad |

### Mouse

| Atajo | Acción |
|-------|--------|
| `SUPER + click izquierdo` | Arrastrar ventana |
| `SUPER + click derecho` | Redimensionar ventana |

### Grupos de Ventanas (Tabs)

Los grupos permiten agrupar ventanas como pestañas (tabs). Al agrupar, aparece un **groupbar** visual en la parte superior con el nombre de las ventanas y colores Gruvbox Material.

| Atajo | Acción |
|-------|--------|
| `SUPER + G` | Toggle group |
| `SUPER + Shift + G` | Toggle lock group |
| `SUPER + Tab` | Siguiente ventana del grupo |
| `SUPER + Shift + Tab` | Ventana anterior del grupo |

### Sistema

| Atajo | Acción |
|-------|--------|
| `SUPER + Escape` | Sysmenu (apagar, reiniciar, etc.) |
| `SUPER + Shift + Escape` | Hyprlock (bloquear pantalla) |
| `SUPER + Shift + R` | Recargar configuración de Hyprland |
| `SUPER + /` | Menú de keybinds |

### Red & Bluetooth

| Atajo | Acción |
|-------|--------|
| `SUPER + N` | Menú WiFi (org.omarchy.wifi) |
| `SUPER + B` | Menú Bluetooth (org.omarchy.bluetui) |
| `SUPER + P` | Wallpaper picker |
| `SUPER + Shift + P` | Gestor de paquetes |

### Multimedia

| Atajo | Acción |
|-------|--------|
| `XF86AudioRaiseVolume` | Subir volumen (5%, repetible) |
| `XF86AudioLowerVolume` | Bajar volumen (5%, repetible) |
| `XF86AudioMute` | Silenciar/activar audio |
| `XF86AudioMicMute` | Silenciar/activar micrófono |
| `XF86MonBrightnessUp` | Subir brillo (5%, repetible) |
| `XF86MonBrightnessDown` | Bajar brillo (5%, repetible) |

### Capturas de Pantalla

| Atajo | Acción |
|-------|--------|
| `SUPER + Shift + S` | Captura de pantalla (grim + slurp + swappy) |
| `Print` | Mostrar última notificación (dunst history-pop) |
| `Scroll_Lock` | Cerrar notificación activa |

### Voz

| Atajo | Acción |
|-------|--------|
| `SUPER + C` (presionar) | Iniciar control por voz (Handy + Whisper) |
| `SUPER + C` (soltar) | Detener control por voz |
| `ALT + I` | Handy modo normal |
| `ALT + Shift + I` | Handy modo AI |

### Notificaciones

| Atajo | Acción |
|-------|--------|
| `SUPER + Shift + D` | Toggle dunst (no molestar) |
| `SUPER + Shift + N` | Historial de dunst |

---

## 🚀 Autostart

Al iniciar Hyprland, `autostart.lua` ejecuta en orden:

| Servicio | Propósito |
|----------|-----------|
| `dbus-update-activation-environment` | Propagar variables Wayland a systemd |
| `systemctl import-environment` | Propaga todas las variables de entorno a systemd (evita apps lentas al iniciar) |
| `hyprlauncher -d` | Daemon del launcher secundario (sin ventana) |
| `swaybg` | Wallpaper inicial (primera imagen del directorio) |
| `wallpaper_carousel.sh` | Carrusel automático de wallpapers |
| `waybar` | Barra de estado (config + estilo absolutos) |
| `handy --start-hidden` | Servicio de control por voz (inicia oculto) |
| `dunst` | Sistema de notificaciones |
| `hyprpolkitagent` | Agente de autenticación (WiFi, Bluetooth) |

> Todos los paths son **absolutos** para evitar dependencias del `PATH` del shell.

---

## 📦 Despliegue

Esta configuración se despliega exclusivamente vía **Home Manager**. No basta con editar los archivos — hay que ejecutar `uhm`.

### ¿Cómo funciona?

1. `home-manager/home.nix` tiene declarado:

```nix
".config/hypr".source = ../hypr;
```

2. Al ejecutar `uhm`, Home Manager copia/symlinkea todo `hypr/` a `~/.config/hypr/`

3. Hyprland lee automáticamente `~/.config/hypr/hyprland.lua`

### ✨ Comando mágico

```bash
uhm
```

Alias definido en `.bashrc` que equivale a:

```bash
home-manager switch -b backup --impure --flake ~/.dotfiles/home-manager#alejandrocabeza
```

> ⚠️ **Sin `uhm` los cambios no toman efecto.** Los dotfiles se copian/symlinkean durante el switch de Home Manager.

### ¿Cómo añadir un nuevo módulo?

1. Crear `hypr/lua/mi-modulo.lua`
2. Añadirlo al array `modules` en `hyprland.lua`
3. Ejecutar `uhm`

---

> 🧠 **Fuente de verdad**: Este README describe la configuración actual. Para detalles exactos de implementación, consulta el código fuente — especialmente `binds.lua` y `windowrules.lua`.
