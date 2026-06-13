# Dotfiles — Alejandro Cabeza

## Introducción

Hola, mi nombre es **Alejandro Cabeza**, soy un desarrollador **Venezolano** apasionado por la customización y las automatizaciones de tareas. Durante mucho tiempo busqué la forma de automatizar mi proceso de instalación del entorno de desarrollo. Gracias a mi trabajo como desarrollador estoy constantemente en la terminal, lo que me hizo entender el poder de los scripts de automatización y la importancia de la replicabilidad de mis configuraciones.

Todos los que trabajamos con Linux sabemos lo que pasa: nos cambiamos de **Distro** o de **OS** y toca hacer un gran esfuerzo para que todo funcione igual como lo teníamos antes. **Esta es mi solución.**

Estas configuraciones están orientadas a las herramientas que uso diariamente como **Back-End Developer**, diseñadas para tener alta disponibilidad y replicabilidad en todos los entornos de escritorio y sistemas operativos en los que me muevo.

---

## Stack Principal

| Componente | Descripción |
|---|---|
| **Gestor de paquetes** | Nix + Home Manager (configuración declarativa y reproducible) |
| **Compositor** | Hyprland (Wayland) con configuración modular en Lua (19 módulos) |
| **Terminal** | Alacritty con Tmux integrado (prefix: `Ctrl+t`) |
| **Shell** | Fish con modo Vi, Starship prompt (bloques sólidos Gruvbox) y fastfetch |
| **Editor** | Neovim (NixCats + Lua, +40 plugins) |
| **Barra** | Waybar flotante con estilos CSS Gruvbox Material |
| **Launcher** | Walker (con prefixes: `>` runner, `=` calc, `@` web, `:` clipboard) |
| **Launcher secundario** | Hyprlauncher (Alfred-style, atajo `ALT+SPACE`) |
| **Notificaciones** | Dunst con tema Gruvbox Material |
| **Asistente de voz** | Handy + Whisper + AI (GPT-local) |
| **Gestor de Node** | Fnm (Fast Node Manager) |
| **Wallpaper** | swaybg con carrusel automático y selector interactivo |

---

## Estructura del Proyecto

```
dotfiles/
├── AGENTS.md                 # Guía para agentes OpenCode (fuente de verdad)
├── home-manager/
│   ├── home.nix              # Configuración principal de Home Manager
│   ├── flake.nix             # Flake para gestión declarativa
│   └── flake.lock
├── hypr/                     # Hyprland (WM Wayland)
│   ├── hyprland.lua          # Entry point (carga 19 módulos)
│   ├── hyprlauncher.conf     # Launcher Alfred-style
│   ├── hyprtoolkit.conf      # Tema del toolkit
│   ├── old.hyprland.conf     # Config legacy (referencia)
│   ├── hyprlock.conf         # Pantalla de bloqueo
│   ├── hypridle.conf         # Daemon de inactividad
│   └── lua/
│       ├── env.lua           # Variables de entorno Wayland
│       ├── variables.lua     # Variables globales (mod, apps)
│       ├── helpers.lua       # Función o.bind() estilo Omarchy
│       ├── monitors.lua      # Monitores y resolución
│       ├── input.lua         # Teclado, mouse, touchpad
│       ├── general.lua       # Gaps, bordes, layout (dwindle)
│       ├── decorations.lua   # Blur, sombras, redondeo, opacidad
│       ├── animations.lua    # Curvas + 10 hojas de animación
│       ├── cursor.lua        # Tema y comportamiento del cursor
│       ├── gestures.lua      # Swipe de workspaces (3 dedos)
│       ├── misc.lua          # VFR, VRR, DPMS, logo, etc.
│       ├── render.lua        # Explicit sync, direct scanout
│       ├── opengl.lua        # OpenGL introspection
│       ├── xwayland.lua      # XWayland scaling
│       ├── ecosystem.lua     # Sin nag de donación
│       ├── windowrules.lua   # Reglas flotantes (Omarchy + apps)
│       ├── layerrules.lua    # Blur en waybar, dunst, etc.
│       ├── submaps.lua       # Modos de teclado (sistema)
│       ├── autostart.lua     # Servicios al iniciar
│       └── binds.lua         # Todos los keybindings
├── nvim/                     # Neovim (NixCats + Lua, ver nvim/AGENTS.md)
│   ├── init.lua
│   ├── flake.nix
│   └── lua/
│       ├── config/           # Core settings, keymaps, autocmds
│       ├── plugins/          # +40 plugins (LSP, DAP, Treesitter…)
│       ├── setup/            # LSP servers, snacks dashboard
│       └── nixCatsUtils/    # Bridge Nix ↔ Lua
├── alacritty/
│   └── alacritty.toml        # Terminal (Gruvbox, sin bordes, 95% opacidad)
├── waybar/
│   ├── config.jsonc          # Barra flotante con workspaces, clock, pulse…
│   └── styles.css            # CSS Gruvbox Material (bordes redondeados)
├── dunst/
│   └── dunstrc               # Notificaciones Gruvbox Material
├── gtk-3.0/
│   └── settings.ini          # Tema oscuro GTK3
├── gtk-4.0/
│   └── settings.ini          # Tema oscuro GTK4
├── walker/
│   ├── config.toml           # Launcher (prefixes, providers, keybinds)
│   └── themes/default.css    # Tema personalizado
├── swappy/
│   └── config                # Anotaciones de capturas
├── tmux/
│   └── tmux.conf             # Tmux (prefix Ctrl+t, Gruvbox, TPM)
├── fish/
│   ├── config.fish           # Shell principal (Vi mode, Starship)
│   ├── conf.d/               # Tide config (legacy)
│   └── functions/            # FZF functions (historial, git, kill…)
├── ranger/
│   ├── rc.conf               # File manager (previews, icons)
│   └── scope.sh              # Previsualizaciones
├── lazygit/
│   └── config.yml            # Git TUI
├── scripts/                  # Scripts de automatización
│   ├── org.omarchy.*         # 8 scripts con namespace Omarchy
│   │   ├── wifi_menu.sh           # Menú WiFi (nmtui)
│   │   ├── bluetooth_menu.sh      # Menú Bluetooth (bluetui)
│   │   ├── package_manager.sh     # Gestor de paquetes (fzf)
│   │   ├── keybinds_menu.sh       # Atajos de teclado
│   │   ├── screenshot.sh          # Capturas (grim + slurp)
│   │   ├── wallpaper_picker.sh    # Selector de wallpapers (fzf + swaybg)
│   │   ├── btop_menu.sh           # Monitor de recursos (btop)
│   │   └── sysmenu.sh             # Menú de sistema (apagar, reiniciar…)
│   ├── wallpaper_carousel.sh # Carrusel automático de wallpapers
│   ├── ranger_scope.sh       # Previews para ranger
│   ├── whisper-dictation.sh  # Dictado por voz (Whisper)
│   ├── voice_control.sh      # Control por voz (Handy)
│   ├── voice_control_handy.sh # Proxy de voz Handy
│   ├── handy_voice_setup.sh  # Configuración de Handy
│   ├── handy_ai_processor.sh # Procesador AI de Handy
│   └── handy_ai_processor.py # Procesador AI en Python
├── wallpapers/               # +40 fondos de pantalla
├── opencode/
│   ├── opencode.jsonc        # Config OpenCode (MCP: engram, supabase, vercel…)
│   ├── commands/             # Comandos personalizados (commit-push, pull-request)
│   └── skills/               # Skills (context7, spec-driven-dev, planning-protocol)
├── crobjob/
│   └── backup.sh             # Backup programado
├── nix/
│   └── nix.conf              # Configuración global de Nix
├── utils/lamp/               # LAMP stack (Docker Compose + PHPMyAdmin)
├── .gitconfig                # Git config (delta, alias, conventional commits)
├── .bashrc                   # Fallback bash (uhm alias, fnm, tmux auto)
└── AGENTS.md                 # ⬅️ Fuente de verdad para agentes
```

---

## Paquetes Instalados (Home Manager)

### Desarrollo
- **PHP 8.4** con extensiones: imagick, gd, pdo_sqlite, pdo_mysql, pdo_pgsql, intl, zip, bcmath, sodium, opcache, redis
- **Composer** (override con PHP custom, memory_limit 512M)
- **Node.js** via Fnm — gestión multi-versión
- **Bun** — Runtime alternativo de JS/TS
- **Python 3.13**
- **Rust** (rustup)
- **Lua** (luarocks-nix) + luacheck + stylua
- **SQLite** / **PostgreSQL**
- **GNU Make 4.2**
- **Biome** / **Prettierd** / **Blade Formatter** — formateo de código

### Terminal & Productividad
- **Neovim** — Editor principal (NixCats + Lua)
- **Fish** — Shell con modo Vi
- **Tmux** — Multiplexor de terminal (prefix `Ctrl+t`)
- **Alacritty** — Terminal GPU-accelerated (sin bordes, Gruvbox)
- **Starship** — Prompt cross-shell (bloques sólidos)
- **Fastfetch** — Info del sistema
- **Bat** — Cat con syntax highlighting
- **Eza** — Reemplazo moderno de `ls` (iconos, colores)
- **Fzf** + **Fd** + **Ripgrep** — Búsqueda y filtrado
- **Delta** — Diff viewer con tema Gruvbox
- **Lazygit** / **Lazydocker** / **Lazyjournal** / **Lazysql** / **Lazyssh** — Lazysuite TUI
- **btop** — Monitor de recursos

### Wayland & UI
- **Hyprland** — Compositor Wayland (configuración modular en Lua)
- **Waybar** — Barra de estado flotante (CSS personalizado)
- **Walker** — Application launcher (prefixes, temas)
- **Hyprlauncher** — Launcher estilo Alfred
- **Dunst** — Notificaciones (tema Gruvbox Material)
- **Swaybg** — Wallpaper daemon
- **Grim** + **Slurp** — Screenshots nativos Wayland
- **Swappy** — Anotación de capturas
- **Brightnessctl** — Control de brillo
- **Hyprlock** — Pantalla de bloqueo
- **Hypridle** — Daemon de inactividad (auto-lock + DPMS + suspend)
- **Hyprpicker** — Color picker
- **Hyprsunset** — Filtro de luz azul nocturna
- **Cliphist** — Clipboard manager con historial

### Red & Hardware
- **IWD** — Daemon WiFi
- **NetworkManager** applet — Applet GTK para WiFi
- **Blueman** + **Bluetui** — Bluetooth
- **Impala** — Gestión de red por TUI

### Asistente de Voz
- **Handy** — Asistente por voz
- **Whisper** — Modelo de dictado (STT)
- **whisper-dictation.sh** — Dictado por voz a texto

### Utilidades
- **ImageMagick** — Procesamiento de imágenes
- **Jq** — JSON processor
- **wl-clipboard** — Clipboard Wayland
- **Lsof** — List open files
- **Nerd Fonts** (Hack + Symbols-only)
- **Engram** — Memoria persistente para agentes (build from source, Go patched)
- **ueberzugpp** / **poppler-utils** / **ffmpegthumbnailer** / **exiftool** — Previews para ranger

---

## Tema & Apariencia

- **Tema de colores:** Gruvbox Material oscuro (#282828 bg, #ddc7a1 fg, #7daea3 accent)
- **Fuente principal:** Hack Nerd Font Mono (terminal), JetBrainsMono Nerd Font (barra/notificaciones)
- **Prompt:** Starship con bloques sólidos segmentados (username → directory → git → nix → cmd_duration)
- **Terminal:** Alacritty sin bordes, 95% opacidad, padding 8px
- **Hyprland:** Bordes teal (#7daea3), redondeo 10px, blur activo (5px/2 passes), sombras sutiles
- **Waybar:** Barra flotante con bordes redondeados (12px), workspaces con iconos Nerd Font
- **Tmux:** Tema Gruvbox Material con powerline symbols (), pane-active-border verde
- **Dunst:** Notificaciones oscuras con bordes, highlights por urgencia (teal/verde/rojo)
- **Fzf:** Colores Gruvbox Material personalizados
- **GTK:** Tema oscuro (adw-gtk3-dark), iconos gruvbox-plus, cursor Bibata

---

## Atajos de Teclado

### Hyprland (Window Manager)

| Atajo | Acción |
|---|---|
| `SUPER + Return` | Abrir terminal (Alacritty) |
| `SUPER + F` | Abrir gestor de archivos (nautilus) |
| `ALT + Space` | Launcher (hyprlauncher) |
| `SUPER + Q` | Cerrar sesión de Hyprland |
| `SUPER + W` | Cerrar ventana activa |
| `SUPER + M` | Toggle fullscreen |
| `SUPER + SHIFT + M` | Toggle flotante |
| `SUPER + H/J/K/L` | Moverse entre ventanas (Vim) |
| `SUPER + SHIFT + H/J/K/L` | Intercambiar ventanas |
| `SUPER + SHIFT + ←/↑/↓/→` | Redimensionar ventanas |
| `SUPER + mouse:272` | Arrastrar ventana |
| `SUPER + mouse:273` | Redimensionar ventana |
| `SUPER + 1-4` | Ir al workspace 1-4 |
| `SUPER + SHIFT + 1-4` | Mover ventana al workspace 1-4 |
| `SUPER + [ / ]` | Workspace anterior / siguiente |
| `SUPER + SHIFT + [ / ]` | Mover ventana al workspace ant/sig |
| `SUPER + minus` | Toggle scratchpad (workspace especial) |
| `SUPER + SHIFT + minus` | Mover ventana al scratchpad |
| `SUPER + SHIFT + R` | Recargar configuración |
| `SUPER + G` / `SUPER + Tab` | Grupos de ventanas (tabs) |
| `SUPER + Escape` | Entrar al modo sistema (submap) |
| `— L / S / R / P` | (dentro del modo) Lock / Suspend / Reboot / Poweroff |
| `SUPER + N` | Menú WiFi |
| `SUPER + B` | Menú Bluetooth |
| `SUPER + P` | Selector de wallpaper |
| `Print` / `Scroll_Lock` | Notificaciones: pop / close |
| `SUPER + SHIFT + S` | Captura de pantalla |
| `SUPER + slash` | Menú de atajos de teclado |
| `SUPER + SHIFT + P` | Gestor de paquetes |
| `SUPER + C` (press) | Activar control por voz |
| `SUPER + C` (release) | Desactivar control por voz |
| `XF86AudioRaise/Lower` | Volumen ±5% (con repetición) |
| `XF86AudioMute` | Silenciar audio |
| `XF86AudioMicMute` | Silenciar micrófono |
| `XF86MonBrightnessUp/Down` | Brillo ±5% (con repetición) |
| `SUPER + SHIFT + D` | Toggle "no molestar" (dunst) |
| `SUPER + SHIFT + N` | Night light toggle (hyprsunset) |

### Tmux (prefix: `Ctrl+t`)

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

### Fish Shell

| Atajo | Acción |
|---|---|
| Modo Vi | Navegación y edición estilo Vim |
| `Ctrl+r` | Búsqueda en historial (fzf) |

### Neovim

| Atajo | Acción |
|---|---|
| `leader + ff` | Telescope fuzzy finder |
| `leader + fe` | Explorador de archivos (Oil) |
| `leader + sg` | Búsqueda global (grep) |
| `leader + tt` | Toggle terminal |
| `leader + gc` | Git commit |
| `leader + gd` | Diffview |
| `leader + ca` | Code actions (LSP) |
| `K` | Hover documentation (LSP) |
| `gd` | Go to definition (LSP) |

---

## Scripts Personalizados

Todos los scripts están en `~/.dotfiles/scripts/` y usan el namespace `org.omarchy.*` para identificarse como ventanas flotantes en Hyprland:

| Script | Class (org.omarchy.*) | Descripción |
|---|---|---|
| `wifi_menu.sh` | `wifi` | Menú WiFi con nmtui (flotante 700×450) |
| `bluetooth_menu.sh` | `bluetui` | Menú Bluetooth con bluetui (flotante 700×450) |
| `package_manager.sh` | `package-manager` | Busca/instala paquetes (flotante 900×600) |
| `keybinds_menu.sh` | `keybinds-menu` | Muestra atajos de teclado (flotante 700×500) |
| `screenshot.sh` | `screenshot` | Captura con grim + slurp (flotante 700×450) |
| `wallpaper_picker.sh` | `wallpaper-picker` | Selecciona wallpaper con fzf + swaybg (flotante 800×600) |
| `btop_menu.sh` | `btop` | Monitor de recursos (flotante 900×600) |
| `sysmenu.sh` | `sysmenu` | Menú de sistema: apagar, reiniciar, suspender (flotante 350×220) |

---

## Scripts Adicionales

| Script | Descripción |
|---|---|
| `wallpaper_carousel.sh` | Rota wallpapers automáticamente cada N tiempo |
| `voice_control.sh` | Control por voz (Handy) — start/stop |
| `handy_voice_setup.sh` | Configuración del asistente Handy (normal/AI) |
| `whisper-dictation.sh` | Dictado por voz usando Whisper |
| `ranger_scope.sh` | Previsualizaciones para ranger |

---

## Notas

- **Nix + Home Manager** es la espina dorsal. Un solo comando (`uhm`) despliega toda la configuración.
- **El alias `uhm`** (definido en `.bashrc`) equivale a: `home-manager switch -b backup --impure --flake ~/.dotfiles/home-manager#alejandrocabeza`
- **La configuración de PHP** incluye un memory limit de 512M y extensiones comunes para Laravel.
- **Engram** se compila desde source con un patch para Go 1.25.
- **Fish** detecta si está en Warp Terminal y desactiva fastfetch/starship para evitar conflictos.
- **Los keybindings de Tmux** usan `Ctrl+t` como prefix (en lugar de `Ctrl+b`).
- **Todo el clipboard** está configurado para Wayland (wl-copy, cliphist).
- **El patrón Omarchy**: los scripts de terminal usan `--class org.omarchy.*` para que Hyprland los reconozca y los ponga en modo flotante automáticamente.
- **El README.md** puede quedar desactualizado. La fuente de verdad es `AGENTS.md` para convenciones y el código fuente para implementación.
- **Neovim** tiene su propia guía en `nvim/AGENTS.md`.

---

## Licencia

MIT — Haz lo que quieras con esto. Si te sirve, me alegra. 🇻🇪
