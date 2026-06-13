# 🏡 Dotfiles — Alejandro Cabeza

![Nix](https://img.shields.io/badge/Nix-✓-informational?style=flat)
![Home Manager](https://img.shields.io/badge/Home%20Manager-✓-blueviolet?style=flat)
![Hyprland](https://img.shields.io/badge/WM-Hyprland-7daea3?style=flat)
![Lua](https://img.shields.io/badge/Config-Lua-000080?style=flat)
![Fish](https://img.shields.io/badge/Shell-Fish-7c5f9b?style=flat)
![Wayland](https://img.shields.io/badge/Protocol-Wayland-7daea3?style=flat)
![Gruvbox](https://img.shields.io/badge/Theme-Gruvbox%20Material-d8a657?style=flat)
![License](https://img.shields.io/badge/License-MIT-green?style=flat)

> **Desarrollador Back-End 🇻🇪** atrapado en un loop infinito de customización de Linux, Nix y Wayland. Bienvenido a mi configuración.

---

## 📋 Tabla de Contenidos

- [🎯 Introducción](#-introducción)
- [⚡ Stack Principal](#-stack-principal)
- [🚀 Instalación & Despliegue](#-instalación--despliegue)
- [📂 Estructura del Proyecto](#-estructura-del-proyecto)
- [🎨 Tema & Apariencia](#-tema--apariencia)
- [📦 Paquetes Instalados](#-paquetes-instalados)
- [⌨️ Atajos de Teclado](#️-atajos-de-teclado)
- [📜 Scripts Personalizados](#-scripts-personalizados)
- [🖼️ Galería](#️-galería)
- [📝 Notas](#-notas)
- [🤝 Contribuir / Fork](#-contribuir--fork)
- [📄 Licencia](#-licencia)

---

## 🎯 Introducción

### El problema

Todos los que vivimos en la terminal lo conocemos: cambias de distro, formateas el disco, o te toca trabajar en una máquina nueva, y **todo se siente extraño**. Tus atajos no funcionan. Tus colores no están. Tus herramientas no existen. Pasar días reconstruyendo tu entorno es frustrante y agotador.

### La solución

Estos dotfiles son mi respuesta a ese problema. No es solo una colección de archivos de configuración — es un **sistema declarativo, reproducible y portable** construido sobre [Nix](https://nixos.org/) + [Home Manager](https://github.com/nix-community/home-manager).

### La filosofía

| Principio | Por qué |
|---|---|
| **Reproducibilidad** | Con un solo comando (`uhm`) mi entorno completo se despliega en cualquier máquina con Nix. No más "después lo configuro". |
| **Declaratividad** | Todo está descrito: qué paquetes instalar, dónde van los dotfiles, qué servicios correr. El sistema deriva el estado deseado. |
| **Modularidad** | Hyprland está dividido en 18 módulos Lua independientes. Cada concern tiene su archivo. Cada script tiene su propósito. |
| **Wayland nativo** | Todo el stack corre sobre Wayland. Sin X11. Sin capas de compatibilidad. |
| **Estética funcional** | El tema Gruvbox Material no es solo bonito — está diseñado para reducir fatiga visual y mantener consistencia en cada rincón del sistema. |

Esto no es "mi config". Es una **herramienta de productividad** que he refinado durante años.

> ⚠️ **Fuente de verdad**: Este README es una guía general. Para convenciones exactas y detalles de implementación, consulta el archivo [`AGENTS.md`](AGENTS.md). La fuente de verdad última **es el código fuente** (`home.nix`, `binds.lua`, los scripts).

---

## ⚡ Stack Principal

```
Gestor   →  Nix + Home Manager (flake)
WM       →  Hyprland (Lua API, 19 módulos)
Terminal →  Alacritty → Tmux (prefix Ctrl+t) → Fish (Vi mode)
Prompt   →  Starship (bloques sólidos Gruvbox)
Editor   →  Neovim (NixCats + Lua)
Barra    →  Waybar flotante (CSS Gruvbox Material)
Launcher →  Walker (> runner, = calc, @ web, : clipboard)
Sec.     →  Hyprlauncher (Alfred-style, ALT+SPACE)
Notifs.  →  Dunst (Gruvbox Material)
Wallp.   →  swaybg + carrusel automático + selector interactivo
Voz      →  Handy + Whisper + AI
Node     →  Fnm (Fast Node Manager)
Git      →  Delta (diff) + Lazygit (TUI)
```

### ¿Por qué Nix + Home Manager?

Porque los dotfiles tradicionales (solo symlinks) resuelven la mitad del problema: distribuyen configuraciones, pero **no gestionan dependencias**. Con Home Manager:

- Los paquetes se instalan **declarativamente** — no hay `apt install` manual
- Las configuraciones se **symlinkean automáticamente** — no hay scripts de bootstrap
- Las variables de entorno se **inyectan en el shell** — no hay que exportarlas a mano
- Los cambios son **atómicos** — `uhm` y todo se actualiza junto, o nada
- Tienes **rollback** — cada switch genera un backup

---

## 🚀 Instalación & Despliegue

### Requisitos

- Nix package manager (con flakes habilitados)
- Home Manager instalado
- Una distribución Linux con Wayland

### Clonar e instalar

```bash
git clone https://github.com/alejandrocabeza/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
uhm
```

### El comando mágico: `uhm`

Definido en `.bashrc`, este alias es el corazón del sistema:

```bash
alias uhm='home-manager switch -b backup --impure --flake ~/.dotfiles/home-manager#alejandrocabeza'
```

**`uhm`** hace tres cosas:
1. Lee `home.nix` y determina qué paquetes instalar
2. Symlinkea cada directorio de configuración a `~/.config/`
3. Ejecuta hooks de activación (crear directorios, clonar TPM, etc.)

> 🔴 **Importante**: Cambiar un archivo de configuración no es suficiente. Debe estar linkeado en `home.nix` bajo `home.file` y luego ejecutar `uhm`. Sin `uhm` los cambios no toman efecto.

### Hooks de activación

| Hook | Qué hace |
|---|---|
| `createEngramDir` | Crea `~/.local/share/engram/` para la base de datos de memoria persistente |
| `installTpm` | Clona [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) si no existe |

---

## 📂 Estructura del Proyecto

```
dotfiles/
├── AGENTS.md              # ⬅️ Fuente de verdad para agentes OpenCode
├── .gitconfig             # Git config (delta, alias, conventional commits)
├── .bashrc                # Bash fallback (uhm alias, fnm, tmux auto-start)
│
├── home-manager/          # 🧠 Corazón del sistema
│   ├── home.nix           #    Config principal (paquetes, files, env vars)
│   ├── flake.nix          #    Flake Nix
│   └── flake.lock
│
├── hypr/                  # 🪟 Hyprland (configuración modular Lua)
│   ├── hyprland.lua       #    Entry point (carga 18 módulos)
│   ├── hyprlauncher.conf  #    Launcher Alfred-style
│   ├── old.hyprland.conf  #    Config legacy (referencia)
│   └── lua/               #    📁 Módulos Lua
│       ├── env.lua        #      Variables de entorno Wayland
│       ├── variables.lua  #      Variables globales (mod, apps)
│       ├── helpers.lua    #      Función helper o.bind()
│       ├── monitors.lua   #      Monitores y resolución
│       ├── input.lua      #      Teclado, mouse, touchpad
│       ├── general.lua    #      Gaps, bordes, layout (dwindle)
│       ├── decorations.lua#      Blur, sombras, redondeo, opacidad
│       ├── animations.lua #      Curvas + 10 hojas de animación
│       ├── cursor.lua     #      Tema y comportamiento del cursor
│       ├── gestures.lua   #      Swipe de workspaces (3 dedos)
│       ├── misc.lua       #      VFR, VRR, DPMS, logo
│       ├── render.lua     #      Explicit sync, direct scanout
│       ├── opengl.lua     #      OpenGL introspection
│       ├── xwayland.lua   #      XWayland scaling
│       ├── ecosystem.lua  #      Sin nag de donación
│       ├── windowrules.lua#      Reglas flotantes (Omarchy + apps)
│       ├── layerrules.lua #      Blur en waybar, dunst, etc.
│       ├── autostart.lua  #      Servicios al iniciar
│       └── binds.lua      #      Todos los keybindings (130 líneas)
│
├── alacritty/             # 🖥️ Terminal (sin bordes, 95% opacidad, Gruvbox)
│   └── alacritty.toml
│
├── tmux/                  # 🔲 Multiplexor (prefix Ctrl+t, Gruvbox, TPM)
│   └── tmux.conf
│
├── fish/                  # 🐟 Shell principal (Vi mode, Starship)
│   ├── config.fish
│   ├── conf.d/
│   └── functions/
│
├── waybar/                # 📊 Barra flotante (CSS Gruvbox Material)
│   ├── config.jsonc
│   └── styles.css
│
├── walker/                # 🔍 Launcher principal (prefixes, temas)
│   ├── config.toml
│   └── themes/default.css
│
├── dunst/                 # 🔔 Notificaciones (Gruvbox Material)
│   └── dunstrc
│
├── nvim/                  # ✏️ Neovim (ver nvim/AGENTS.md)
│   ├── init.lua
│   ├── flake.nix
│   └── lua/
│
├── gtk-3.0/               # 🎨 Tema oscuro GTK3
│   └── settings.ini
├── gtk-4.0/               # 🎨 Tema oscuro GTK4
│   └── settings.ini
│
├── swappy/                # 📸 Anotaciones de capturas
│   └── config
│
├── ranger/                # 📁 File manager (previews, icons)
│   ├── rc.conf
│   └── scope.sh
│
├── lazygit/               # 🔧 Git TUI
│   └── config.yml
│
├── scripts/               # ⚡ Automatización
│   ├── *.omarchy.*.sh     #    8 scripts namespace Omarchy
│   ├── wallpaper_carousel.sh
│   ├── voice_control.sh
│   ├── handy_*.sh / .py
│   ├── whisper-dictation.sh
│   └── ranger_scope.sh
│
├── opencode/              # 🤖 OpenCode (config, commands, skills)
│   ├── opencode.jsonc
│   ├── commands/
│   └── skills/
│
├── wallpapers/            # 🖼️ +100 fondos de pantalla
├── nix/                   # ⚙️ Config global de Nix
│   └── nix.conf
├── crobjob/               # ⏰ Backup programado
│   └── backup.sh
├── utils/lamp/            # 🐳 LAMP stack (Docker Compose + PHPMyAdmin)
└── .bashrc                # 📝 Bash fallback (uhm alias, fnm, tmux auto)
```

---

## 🎨 Tema & Apariencia

Cada píxel está diseñado para ser funcional, consistente y agradable a la vista durante horas frente a la terminal.

### Paleta de colores: Gruvbox Material Oscuro

```
Fondo     → #282828 (dark)
Frente    → #ddc7a1 (warm white)
Acento    → #7daea3 (teal)
Rojo      → #ea6962
Verde     → #a9b665
Amarillo  → #d8a657
Magenta   → #d3869b
Naranja   → #e78a4e
Gris      → #a89984
```

Elegí Gruvbox Material porque tiene **alto contraste sin ser agresivo**, funciona bien tanto de día como de noche, y mantiene una calidez visual que reduce la fatiga ocular.

### Distribución visual

| Componente | Detalle |
|---|---|
| **Terminal** | Alacritty sin bordes, 95% opacidad, padding 8px, Hack Nerd Font Mono |
| **Hyprland** | Bordes teal (`#7daea3`), redondeo 10px, blur 5px/2 passes |
| **Waybar** | Flotante, bordes redondeados 12px, workspaces con iconos Nerd Font, JetBrainsMono NF |
| **Tmux** | Gruvbox Material, powerline symbols (), pane-active-border verde |
| **Dunst** | Notificaciones oscuras con bordes, highlights por urgencia (teal/verde/rojo) |
| **Starship** | Bloques sólidos segmentados: username → dir → git → nix → cmd_duration |
| **Fzf** | Colores Gruvbox Material personalizados, layout reverse con borde |
| **GTK** | Tema adw-gtk3-dark, iconos Papirus, cursores Bibata Modern Classic |
| **Prompt** | Carácter `➜` verde en éxito, rojo en error |

### Fuentes

- **Hack Nerd Font Mono** — Terminal (Alacritty, Tmux, Neovim)
- **JetBrainsMono Nerd Font** — Waybar, notificaciones Dunst
- **Symbols-only Nerd Font** — Iconos adicionales

---

## 📦 Paquetes Instalados

Gestionados completamente por Home Manager en `home-manager/home.nix`.

### 🛠️ Desarrollo

| Paquete | Versión / Detalle |
|---|---|
| **PHP** | 8.4 con extensions: imagick, gd, pdo_sqlite, pdo_mysql, pdo_pgsql, intl, zip, bcmath, sodium, opcache, redis |
| **Composer** | Override con PHP custom, memory_limit 512M |
| **Node.js** | Via Fnm — gestión multi-versión por proyecto |
| **Bun** | Runtime JS/TS alternativo |
| **Python** | 3.13 |
| **Rust** | Via rustup (toolchains múltiples) |
| **Lua** | Con luarocks, luacheck, stylua |
| **SQLite / PostgreSQL** | Motores de base de datos locales |
| **GNU Make** | 4.2 |
| **Biome / Prettierd / Blade Formatter** | Formateo de código |

### 🖥️ Terminal & Productividad

| Categoría | Paquetes |
|---|---|
| **Editor** | Neovim (NixCats + Lua) |
| **Shell** | Fish, Starship, Fastfetch |
| **Multiplexor** | Tmux, Tmux Plugin Manager |
| **Terminal** | Alacritty (GPU-accelerated) |
| **Herramientas** | Bat, Eza, Fzf, Fd, Ripgrep, Delta |
| **TUI Suite** | Lazygit, Lazydocker, Lazyjournal, Lazysql, Lazyssh |
| **Monitor** | btop |

### 🪟 Wayland & UI

| Categoría | Paquetes |
|---|---|
| **WM** | Hyprland (config Lua) |
| **Barra** | Waybar |
| **Launchers** | Walker, Hyprlauncher |
| **Notificaciones** | Dunst |
| **Wallpaper** | Swaybg |
| **Screenshots** | Grim, Slurp, Swappy |
| **Bloqueo** | Hyprlock, Hypridle |
| **Utilidades** | Hyprpicker, Hyprsunset, Cliphist, Brightnessctl |

### 📡 Red & Hardware

| Paquete | Propósito |
|---|---|
| IWD | Daemon WiFi |
| NetworkManager applet | Applet GTK para WiFi |
| Blueman + Bluetui | Gestión Bluetooth |
| Adw-gtk3 + Papirus + Bibata | Tema GTK, iconos, cursores |

### 🎙️ Voz & AI

| Paquete | Propósito |
|---|---|
| Handy | Asistente por voz local |
| Whisper | Modelo de dictado STT |
| `whisper-dictation.sh` | Script de dictado por voz |
| `handy_ai_processor.py` | Procesador AI local |

### 🧰 Utilidades

| Paquete | Propósito |
|---|---|
| ImageMagick | Procesamiento de imágenes |
| Jq | Procesador JSON |
| wl-clipboard | Clipboard Wayland |
| Lsof | Listar archivos abiertos |
| Nerd Fonts Hack + Symbols-only | Fuentes con iconos |
| Engram | Memoria persistente para agentes AI (build from source) |
| ueberzugpp / poppler-utils / ffmpegthumbnailer / exiftool | Previews para Ranger |

---

## ⌨️ Atajos de Teclado

### 🪟 Hyprland (Window Manager)

#### Navegación y ventanas

| Atajo | Acción |
|---|---|
| `SUPER + Return` | Abrir terminal (Alacritty → Tmux) |
| `SUPER + F` | Abrir gestor de archivos |
| `ALT + Space` | Launcher secundario (Hyprlauncher) |
| `SUPER + Q` | Cerrar sesión de Hyprland |
| `SUPER + W` | Cerrar ventana activa |
| `SUPER + M` | Toggle fullscreen |
| `SUPER + SHIFT + M` | Toggle ventana flotante |
| `SUPER + H / J / K / L` | Moverse entre ventanas (estilo Vim) |
| `SUPER + SHIFT + H / J / K / L` | Intercambiar ventanas |
| `SUPER + SHIFT + ←↑↓→` | Redimensionar ventanas (10px) |
| `SUPER + mouse:272` | Arrastrar ventana |
| `SUPER + mouse:273` | Redimensionar ventana |

#### Workspaces

| Atajo | Acción |
|---|---|
| `SUPER + 1-4` | Ir al workspace 1-4 |
| `SUPER + SHIFT + 1-4` | Mover ventana al workspace |
| `SUPER + [` / `SUPER + ]` | Workspace anterior / siguiente |
| `SUPER + SHIFT + [` / `SUPER + SHIFT + ]` | Mover ventana al workspace ant/sig |
| `SUPER + minus` | Toggle scratchpad |
| `SUPER + SHIFT + minus` | Mover ventana al scratchpad |

#### Grupos de ventanas (tabs)

| Atajo | Acción |
|---|---|
| `SUPER + G` | Toggle grupo |
| `SUPER + SHIFT + G` | Lock grupo |
| `SUPER + Tab` | Siguiente grupo |
| `SUPER + SHIFT + Tab` | Grupo anterior |

#### Herramientas y apps

| Atajo | Acción |
|---|---|
| `SUPER + SHIFT + S` | Captura de pantalla (grim + slurp) |
| `SUPER + N` | Menú WiFi (nmtui) |
| `SUPER + B` | Menú Bluetooth (bluetui) |
| `SUPER + P` | Selector de wallpaper |
| `SUPER + Escape` | Menú de sistema (sysmenu.sh) |
| `SUPER + /` | Menú de atajos (keybinds_menu.sh) |
| `SUPER + SHIFT + P` | Gestor de paquetes |
| `PRINT` | Dunstctl history-pop |
| `SCROLL_LOCK` | Dunstctl close |
| `SUPER + SHIFT + N` | Historial de notificaciones |
| `SUPER + SHIFT + D` | Toggle "no molestar" (dunst pause) |

#### Control por voz

| Atajo | Acción |
|---|---|
| `SUPER + C` (press) | Activar control por voz |
| `SUPER + C` (release) | Desactivar control por voz |
| `ALT + I` | Handy voice setup (normal) |
| `ALT + SHIFT + I` | Handy voice setup (AI) |

#### Multimedia

| Atajo | Acción |
|---|---|
| `XF86AudioRaiseVolume` | Volumen +5% (con repetición) |
| `XF86AudioLowerVolume` | Volumen -5% (con repetición) |
| `XF86AudioMute` | Silenciar audio |
| `XF86AudioMicMute` | Silenciar micrófono |
| `XF86MonBrightnessUp` | Brillo +5% (con repetición) |
| `XF86MonBrightnessDown` | Brillo -5% (con repetición) |

#### Sistema

| Atajo | Acción |
|---|---|
| `SUPER + SHIFT + Escape` | Bloquear pantalla (hyprlock) |
| `SUPER + SHIFT + R` | Recargar configuración Hyprland |
| `SUPER + SHIFT + N` | Night light toggle (hyprsunset) |

### 🔲 Tmux (prefix: `Ctrl+t`)

| Atajo | Acción |
|---|---|
| `prefix + /` | Split vertical |
| `prefix + -` | Split horizontal |
| `prefix + h/j/k/l` | Navegar entre paneles |
| `prefix + Ctrl+h/j/k/l` | Redimensionar paneles |
| `prefix + r` | Recargar configuración |
| `prefix + y` | Copiar selección (wl-copy) |
| `prefix + f` | Popup flotante (80%) |
| `prefix + g` | Popup lazygit |
| `prefix + s` | Popup lazyssh |
| `prefix + d` | Popup lazydocker |
| `prefix + o` | Abrir directorio en gestor de archivos |
| `prefix + e` | Cerrar paneles excepto el activo |

### 🐟 Fish Shell

| Atajo | Acción |
|---|---|
| Modo Vi | Navegación y edición estilo Vim |
| `Ctrl + r` | Búsqueda en historial (fzf) |

### ✏️ Neovim (referencia rápida)

| Atajo | Acción |
|---|---|
| `<leader> + ff` | Telescope fuzzy finder |
| `<leader> + fe` | Explorador de archivos (Oil) |
| `<leader> + sg` | Búsqueda global (grep) |
| `<leader> + tt` | Toggle terminal |
| `<leader> + gc` | Git commit |
| `<leader> + gd` | Diffview |
| `<leader> + ca` | Code actions (LSP) |
| `K` | Hover documentation (LSP) |
| `gd` | Go to definition (LSP) |

> Para la lista completa de atajos de Neovim, consulta `nvim/AGENTS.md`.

---

## 📜 Scripts Personalizados

### 🏛️ Patrón Omarchy

Todos los scripts que abren una terminal como ventana flotante usan el namespace **`org.omarchy.*`**. Hyprland detecta estas clases en `windowrules.lua` y las pone automáticamente en modo flotante, centradas y con el tamaño adecuado.

Esto permite que los scripts lancen Alacritty como si fueran aplicaciones nativas, pero manteniendo toda la flexibilidad de la terminal.

### Los 8 scripts Omarchy

| Clase (org.omarchy.*) | Script | Descripción | Tamaño flotante |
|---|---|---|---|
| `wifi` | `wifi_menu.sh` | Menú WiFi con nmtui | 700×450 |
| `bluetui` | `bluetooth_menu.sh` | Gestión Bluetooth con bluetui | 700×450 |
| `package-manager` | `package_manager.sh` | Busca/instala paquetes | 900×600 |
| `keybinds-menu` | `keybinds_menu.sh` | Muestra atajos de teclado | 700×500 |
| `screenshot` | `screenshot.sh` | Captura con grim + slurp | 700×450 |
| `wallpaper-picker` | `wallpaper_picker.sh` | Selecciona wallpaper con fzf + swaybg | 800×600 |
| `btop` | `btop_menu.sh` | Monitor de recursos | 900×600 |
| `sysmenu` | `sysmenu.sh` | Menú del sistema (apagar, reiniciar, etc.) | 350×220 |

### Scripts adicionales

| Script | Descripción |
|---|---|
| `wallpaper_carousel.sh` | Rota wallpapers automáticamente cada N minutos |
| `voice_control.sh` | Inicia/para el control por voz (Handy) |
| `handy_voice_setup.sh` | Configuración del asistente Handy (modo normal o AI) |
| `handy_ai_processor.py` | Procesador AI del asistente Handy |
| `handy_ai_processor.sh` | Shell wrapper del procesador AI |
| `voice_control_handy.sh` | Proxy de control por voz Handy |
| `whisper-dictation.sh` | Dictado por voz usando Whisper STT |
| `ranger_scope.sh` | Previsualizaciones avanzadas para Ranger |

---

## 🖼️ Galería

*(Aquí van las capturas de pantalla — próximamente)*

<details>
<summary>🖥️ Vista del escritorio</summary>

<!-- ![Desktop](screenshots/desktop.png) -->
<!-- ![Neovim](screenshots/neovim.png) -->
<!-- ![Waybar](screenshots/waybar.png) -->

</details>

<details>
<summary>📸 Capturas pendientes</summary>

- [ ] Escritorio completo con Hyprland + Waybar
- [ ] Neovim con varios buffers
- [ ] Walker launcher en acción
- [ ] Tmux con paneles múltiples
- [ ] Menú Omarchy (sysmenu)
- [ ] Dunst notificaciones

</details>

---

## 📝 Notas

### Arquitectura y decisiones

- **`uhm` es el corazón del sistema** — sin él, los cambios no toman efecto. Siempre ejecutar después de modificar configuraciones.
- **El patrón Omarchy es brillante en su simplicidad**: los scripts no necesitan saber que son flotantes. Solo lanzan Alacritty con `--class org.omarchy.*` y Hyprland hace el resto.
- **Fish detecta Warp Terminal** y desactiva fastfetch/starship para evitar conflictos si estás en ese entorno.
- **Engram** (memoria persistente para agentes) se compila desde source con un patch para Go 1.25.
- **Todo el clipboard** está configurado para Wayland nativo — wl-copy + cliphist.
- **PHP tiene memory_limit 512M** y extensiones optimizadas para Laravel.
- **Tmux usa `Ctrl+t`** como prefix (en lugar de `Ctrl+b`), liberando `Ctrl+b` para scroll nativo.

### Archivos no linkeados aún

Los siguientes directorios existen pero **no están en `home.nix`** — necesitan ser añadidos a `home.file`:

| Directorio | Estado |
|---|---|
| `dunst/` | ✅ Ahora linkeado |
| `gtk-3.0/` | ✅ Ahora linkeado |
| `gtk-4.0/` | ✅ Ahora linkeado |
| `swappy/` | ✅ Ahora linkeado |
| `walker/` | ✅ Ahora linkeado |
| `tmux/` | ✅ Linkeado |
| `fish/` | ✅ Linkeado |
| `ranger/` | ✅ Linkeado |
| `lazygit/` | ✅ Linkeado |
| `opencode/` | ✅ Linkeado |

### Ambiente de desarrollo

Este entorno está diseñado para desarrollo **Back-End** (PHP, Laravel, Node.js, Python, Rust) pero es perfectamente usable para cualquier tipo de trabajo en terminal. El LAMP stack en Docker (`utils/lamp/`) incluye Apache + MySQL + PHPMyAdmin para desarrollo web tradicional.

---

## 🤝 Contribuir / Fork

¿Te gusta algo de esto? ¡Adelante!

1. **Haz fork** del repositorio
2. **Cambia las referencias personales** (`alejandrocabeza` → tu usuario, rutas absolutas en scripts)
3. **Ajusta el flake** en `home-manager/flake.nix` para tu username
4. **Ejecuta `uhm`** y disfruta

Si encuentras bugs, mejoras, o ideas, abre un issue o PR. Toda contribución es bienvenida.

### Convenciones del proyecto

- **Commits**: Conventional Commits (`feat:`, `fix:`, `docs:`, `refactor:`, etc.)
- **Rama por defecto**: `Master`
- **Idioma**: Español (código, commits, documentación)
- **Para agentes OpenCode**: La fuente de verdad es `AGENTS.md` y el código fuente

---

## 📄 Licencia

**MIT** — Haz lo que quieras con esto. Si te sirve, me alegra. Si lo mejoras, compártelo. 🇻🇪

---

<p align="center">
  <sub>Hecho con ☕, Nix y mucha paciencia • Alejandro Cabeza • 2025</sub>
</p>
