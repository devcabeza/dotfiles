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
| **Compositor** | Hyprland (Wayland) con configuración modular en Lua |
| **Terminal** | Ghostty + Alacritty |
| **Shell** | Fish con modo Vi, Starship prompt y fastfetch |
| **Multiplexor** | Tmux (prefix: `Ctrl+t`) con tema Gruvbox Material |
| **Editor** | Neovim (Lua, +40 plugins) |
| **Barra** | Waybar con estilos CSS personalizados |
| **Launcher** | Wofi |
| **Gestor de Node** | Fnm (Fast Node Manager) |
| **Wallpaper** | swaybg con scripts de wallpaper picker/carousel |

---

## Estructura del Proyecto

```
dotfiles/
├── home-manager/
│   ├── home.nix              # Configuración principal de Home Manager
│   ├── flake.nix             # Flake para gestión declarativa
│   └── flake.lock
├── hypr/
│   ├── hyprland.lua          # Entry point de Hyprland (Lua)
│   ├── old.hyprland.conf     # Configuración legacy
│   └── lua/
│       ├── variables.lua     # Variables globales
│       ├── helpers.lua       # Funciones auxiliares
│       ├── monitors.lua      # Configuración de monitores
│       ├── input.lua         # Teclado, mouse, touchpad
│       ├── general.lua       # Settings generales de Hyprland
│       ├── windowrules.lua   # Reglas por aplicación
│       ├── animations.lua    # Animaciones y curvas
│       ├── autostart.lua     # Programas al iniciar
│       └── binds.lua         # Keybindings
├── nvim/                     # Neovim configuración completa
│   ├── lua/
│   │   ├── plugins/          # +40 plugins (LSP, DAP, Treesitter, etc.)
│   │   └── setup/            # Setup de LSP, snacks dashboard, etc.
│   └── tests/
├── fish/
│   ├── config.fish           # Configuración principal de Fish
│   ├── conf.d/               # Configuraciones modulares
│   └── functions/            # Funciones personalizadas
├── ghostty/
│   └── config                # Ghostty terminal config
├── alacritty/
│   └── alacritty.toml        # Alacritty terminal config
├── waybar/
│   ├── config.jsonc          # Configuración de la barra
│   └── styles.css            # Estilos CSS
├── wofi/
│   ├── config                # Configuración del launcher
│   └── style.css             # Estilos del launcher
├── scripts/                  # Scripts de automatización
│   ├── wallpaper_picker.sh   # Selector de wallpapers
│   ├── wallpaper_carousel.sh # Carousel de wallpapers
│   ├── screenshot.sh         # Capturas de pantalla
│   ├── btop_menu.sh          # Menú de monitor de sistema
│   ├── keybinds_menu.sh      # Menú de atajos de teclado
│   ├── package_manager.sh    # Gestor de paquetes
│   ├── wifi_menu.sh          # Menú de WiFi
│   └── bluetooth_menu.sh     # Menú de Bluetooth
├── wallpapers/               # Colección de fondos de pantalla
├── opencode/
│   ├── opencode.jsonc        # Configuración de OpenCode
│   └── agents/               # Agentes personalizados
├── cron/
│   └── backup.sh             # Script de backup programado
├── .gitconfig                # Configuración de Git
├── .bashrc                   # Fallback bash
├── utils                     # Utilidades
└── README.md
```

---

## Paquetes Instalados (Home Manager)

### Desarrollo
- **PHP 8.4** con extensiones: imagick, gd, pdo_sqlite, pdo_mysql, pdo_pgsql, intl, zip, bcmath, sodium, opcache, redis
- **Composer** (override con PHP custom)
- **Node.js** via Fnm
- **Bun** — Runtime alternativo de JS
- **Python 3.13**
- **Rust** (rustup)
- **Lua** (luarocks-nix)
- **SQLite** / **PostgreSQL**
- **GNU Make 4.2**
- **Docker**

### Terminal & Productividad
- **Neovim** — Editor principal
- **Fish** — Shell con modo Vi
- **Tmux** — Multiplexor de terminal
- **Ghostty** — Terminal moderna
- **Alacritty** — Terminal GPU-accelerated
- **Starship** — Prompt cross-shell
- **Fastfetch** — Info del sistema
- **Bat** — Cat con syntax highlighting
- **Eza** — Reemplazo moderno de ls
- **Fzf** — Fuzzy finder
- **Fd** — Find alternativo
- **Ripgrep** — Grep acelerado
- **Delta** — Diff viewer
- **Lazygit** — TUI para Git

### Wayland & UI
- **Hyprland** — Compositor Wayland
- **Waybar** — Barra de estado
- **Wofi** — Application launcher
- **Swaybg** — Wallpaper daemon
- **Dunst** — Notificaciones
- **Grim** + **Slurp** — Screenshots en Wayland
- **Brightnessctl** — Control de brillo

### Red & Hardware
- **IWD** — Daemon WiFi
- **NetworkManager** applet
- **Blueman** + **Bluetui** — Bluetooth
- **Impala** — Gestión de red

### Utilidades
- **ImageMagick** — Procesamiento de imágenes
- **Jq** — JSON processor
- **xclip** / **xsel** / **wl-clipboard** — Clipboard
- **Lsof** — List open files
- **btop** — Monitor de recursos
- **Nerd Fonts** (Hack + Symbols)
- **Engram** — Tool custom (build from source)

---

## Tema & Apariencia

- **Tema de colores:** Gruvbox Material
- **Fuente principal:** Hack Nerd Font Mono
- **Prompt:** Starship con formato de bloques sólidos Gruvbox
- **Tmux:** Tema Gruvbox Material con powerline symbols
- **Fzf:** Colores Gruvbox Material

---

## Cómo Instalar

### Prerrequisitos

1. Tener **Nix** instalado en tu sistema
2. Tener **Home Manager** instalado

### Instalación

```bash
# 1. Clonar el repositorio
git clone https://github.com/tu-usuario/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# 2. Aplicar la configuración con Home Manager
home-manager switch --flake .#alejandrocabeza

# O si usas flakes directamente:
nix run home-manager/master -- switch --flake ~/.dotfiles/home-manager#alejandrocabeza
```

### Post-Instalación

```bash
# Iniciar sesión en Fish (si no es el shell por defecto)
chsh -s $(which fish)

# Verificar que todo funciona
fastfetch    # Debería mostrar info del sistema
nvim         # Debería abrir con todos los plugins
```

---

## Atajos de Teclado

### Tmux (prefix: `Ctrl+t`)

| Atajo | Acción |
|---|---|
| `prefix + /` | Split vertical |
| `prefix + -` | Split horizontal |
| `prefix + h/j/k/l` | Navegar entre paneles |
| `prefix + Ctrl+h/j/k/l` | Redimensionar paneles |
| `prefix + r` | Recargar configuración |
| `prefix + y` | Copiar en modo copia (wl-copy) |
| `prefix + o` | Abrir directorio actual en file manager |
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
| `leader + fe` | Explorador de archivos (Oil/NvimTree) |
| `leader + sg` | Búsqueda global (grep) |
| `leader + tt` | Toggle terminal |
| `leader + gc` | Git commit |
| `leader + gd` | Diffview |

---

## Scripts Personalizados

Todos los scripts están en `~/.dotfiles/scripts/`:

| Script | Descripción |
|---|---|
| `wallpaper_picker.sh` | Selector interactivo de wallpapers |
| `wallpaper_carousel.sh` | Rota wallpapers automáticamente |
| `screenshot.sh` | Captura de pantalla con slurp + grim |
| `btop_menu.sh` | Menú rápido para monitor de sistema |
| `keybinds_menu.sh` | Menú visual de atajos de teclado |
| `package_manager.sh` | Gestor de paquetes interactivo |
| `wifi_menu.sh` | Menú para conectar WiFi |
| `bluetooth_menu.sh` | Menú para gestionar Bluetooth |

---

## Notas

- La configuración de **PHP** incluye un memory limit de 512M y extensiones comunes para Laravel
- **Engram** se compila desde source con un patch para la versión de Go
- **Ghostty** está configurado para auto-attach a Tmux al abrir
- **Fish** detecta si está en Warp Terminal y desactiva fastfetch/starship para evitar conflictos
- Los **keybindings de Tmux** usan `Ctrl+t` como prefix en lugar de `Ctrl+b`
- Todo el clipboard está configurado para **Wayland** (wl-copy)

---

## Licencia

MIT — Haz lo que quieras con esto. Si te sirve, me alegra. 🇻🇪