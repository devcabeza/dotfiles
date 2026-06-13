# 🧠 Home Manager — Nix + Flake

![Nix](https://img.shields.io/badge/Nix-✓-informational?style=flat)
![Home Manager](https://img.shields.io/badge/Home%20Manager-✓-blueviolet?style=flat)
![Flake](https://img.shields.io/badge/Flake-✓-7daea3?style=flat)
![x86_64](https://img.shields.io/badge/Arch-x86__64--linux-5294e2?style=flat)

> **El corazón del sistema.** Todo lo demás — Hyprland, Neovim, Waybar, scripts — existe porque esto lo orquesta.

---

## 📋 Tabla de Contenidos

- [🎯 ¿Qué es Nix + Home Manager?](#-qué-es-nix--home-manager)
- [🏗️ Arquitectura del Directorio](#️-arquitectura-del-directorio)
- [❄️ El Flake](#️-el-flake)
- [📦 Categorías de Paquetes](#-categorías-de-paquetes)
- [🔗 Archivos Linkeados](#-archivos-linkeados)
- [🌍 Variables de Entorno](#-variables-de-entorno)
- [🚀 Despliegue con `uhm`](#-despliegue-con-uhm)
- [⚡ Hooks de Activación](#-hooks-de-activación)
- [📝 Notas](#-notas)

---

## 🎯 ¿Qué es Nix + Home Manager?

[Nix](https://nixos.org/) es un gestor de paquetes **puramente funcional** y **declarativo**. En lugar de instalar cosas una por una con `apt install`, describes el estado deseado de tu sistema en un archivo, y Nix deriva los pasos necesarios para alcanzarlo. Cada cambio es atómico y reversible.

[Home Manager](https://github.com/nix-community/home-manager) extiende Nix al *home directory*: paquetes, archivos de configuración, variables de entorno, servicios de usuario, programas. Todo se gestiona desde un solo punto de entrada.

### Por qué esta combinación

| Razón | Explicación |
|---|---|
| **Reproducibilidad** | `uhm` despliega exactamente el mismo entorno en cualquier máquina con Nix. Sin sorpresas. |
| **Declaratividad** | El archivo `home.nix` describe *qué* quieres, no *cómo*. No hay scripts de instalación. |
| **Atomicidad** | Cada `home-manager switch` es una transacción: o todo funciona, o nada cambia. |
| **Rollback** | `home-manager generations` lista versiones anteriores; `home-manager switch --rollback` restaura. |
| **Gestión de dependencias** | Si necesitas PHP 8.4 con extensiones específicas, se declara una vez y Home Manager lo resuelve. |

---

## 🏗️ Arquitectura del Directorio

```
home-manager/
├── home.nix       # 📄 Config principal — paquetes, files, env vars, programas
├── flake.nix      # ❄️ Entrada del flake Nix (inputs, outputs)
├── flake.lock     # 🔒 Lock file (versiones inmutables de inputs)
└── result/        # 📁 Build result (generado por Nix, no trackeado)
```

### Cómo se relaciona con el resto de dotfiles

Este directorio es el **orquestador**. Cada directorio de configuración (`hypr/`, `waybar/`, `nvim/`, `fish/`, etc.) es *source* en `home.nix` y se symlinkea a `~/.config/` durante el `switch`.

```
dotfiles/
├── home-manager/  ← 🧠 Orquesta TODO
├── hypr/          ←  Source, linkeado por home-manager
├── waybar/        ←  Source, linkeado por home-manager
├── nvim/          ←  Source, linkeado por home-manager
├── ...
└── scripts/       ←  Adjuntos al repo (no linkeados, se usan desde ~/.dotfiles/scripts)
```

---

## ❄️ El Flake

[`flake.nix`](flake.nix) es el punto de entrada estándar de Nix para proyectos reproducibles.

```nix
{
  description = "Home Manager configuration of alejandrocabeza";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }: {
    homeConfigurations."alejandrocabeza" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [ ./home.nix ];
    };
  };
}
```

### Cómo funciona

| Componente | Rol |
|---|---|
| **inputs** | Fuentes externas: `nixpkgs` (nixos-unstable, la rama de paquetes más actualizada) y `home-manager` (sigue la misma versión de nixpkgs). |
| **outputs** | Genera una configuración de Home Manager para el usuario `alejandrocabeza` en `x86_64-linux`. |
| **modules** | La lista de módulos que definen la configuración. Aquí solo `home.nix`, pero podría incluir más para separar concerns. |

El `flake.lock` congela las versiones de `nixpkgs` y `home-manager` para que cada `uhm` sea determinista. Para actualizar: `nix flake update`.

---

## 📦 Categorías de Paquetes

Un total de ~50 paquetes gestionados declarativamente en `home.nix`. Agrupados por propósito:

### 🛠️ Desarrollo Back-End

| Paquete | Detalle |
|---|---|
| **PHP 8.4** | Extensiones: imagick, gd, pdo_sqlite/mysql/pgsql, intl, zip, bcmath, sodium, opcache, redis. Memory limit: 512M. |
| **Composer** | Override con el PHP custom de arriba |
| **Node.js** | Via `fnm` (Fast Node Manager) — multi-versión por proyecto |
| **Bun** | Runtime JS/TS alternativo |
| **Python** | 3.13 |
| **Rust** | Via `rustup` (toolchains múltiples) |
| **SQLite / PostgreSQL** | Motores de base de datos locales |
| **GNU Make** | 4.2 |
| **Lua** | Luacheck, stylua |
| **Formatter suite** | Biome, prettierd, blade-formatter |

### 🖥️ Terminal & Productividad

| Categoría | Paquetes |
|---|---|
| **Shell** | Fish (config linkeada), Starship, Fastfetch |
| **Multiplexor** | Tmux (config linkeada) |
| **Herramientas CLI** | Bat, Eza, Fzf, Fd, Ripgrep, Delta |
| **TUI Suite** | Lazygit, Lazydocker, Lazyjournal, Lazysql, Lazyssh |
| **Monitor** | Btop |

### 🪟 Wayland & Hyprland Ecosystem

| Categoría | Paquetes |
|---|---|
| **WM** | Hyprland (config linkeada) |
| **Barra** | Waybar (config linkeada) |
| **Launcher** | Walker (config linkeada) |
| **Notificaciones** | Dunst (config linkeada) |
| **Wallpaper** | Swaybg, librsvg |
| **Screenshots** | Grim, Slurp, Swappy (config linkeada) |
| **Bloqueo / Idle** | Hyprlock, Hypridle |
| **Utilidades** | Hyprpicker, Hyprsunset, Cliphist, Brightnessctl |

### 📡 Red & Hardware

| Paquete | Propósito |
|---|---|
| IWD | Daemon WiFi |
| NetworkManager applet | Applet GTK para redes |
| Blueman + Bluetui | Bluetooth GUI + TUI |
| Nerd Fonts (Hack + Symbols-only) | Fuentes con iconos |

### 🧰 Utilidades

| Paquete | Propósito |
|---|---|
| ImageMagick | Procesamiento de imágenes |
| Jq | Procesador JSON en terminal |
| wl-clipboard, xclip, xsel | Clipboard (Wayland + X11) |
| Lsof | Listar archivos abiertos |
| Ranger + ueberzugpp | File manager con previsualizaciones |
| Poppler-utils, xlsx2csv, glow, ffmpegthumbnailer, exiftool, odt2txt | Previews para Ranger |
| Bibata-cursors, adw-gtk3, Papirus-icon-theme | Tema GTK, cursores, iconos |

### 🤖 Memoria Persistente

| Paquete | Detalle |
|---|---|
| **Engram** | Compilado desde source con patch para Go 1.25 (`substituteInPlace go.mod --replace "go 1.25.10" "go 1.25.0"`). Base de datos de memoria persistente para agentes AI en `~/.local/share/engram/engram.db`. |

---

## 🔗 Archivos Linkeados

Cada entrada en `home.file` de `home.nix` crea un symlink desde `~/.dotfiles/<directorio>` a `~/.config/<destino>`. Aquí el mapeo completo:

### Core

| Source (`../`) | Destino (`~/.config/` o `~/`) |
|---|---|
| `.gitconfig` | `~/.gitconfig` |
| `.bashrc` | `~/.bashrc` |
| `utils` | `~/utils` |

### Editores & Terminal

| Source | Destino |
|---|---|
| `nvim` | `~/.config/nvim` |
| `alacritty` | `~/.config/alacritty` |

### Shell

| Source | Destino |
|---|---|
| `fish/conf.d` | `~/.config/fish/conf.d` |
| `fish/config.fish` | `~/.config/fish/config.fish` |
| `fish/functions` | `~/.config/fish/functions` |

### WM & UI

| Source | Destino |
|---|---|
| `hypr` | `~/.config/hypr` |
| `waybar` | `~/.config/waybar` |
| `dunst/dunstrc` | `~/.config/dunst/dunstrc` |
| `walker/config.toml` | `~/.config/walker/config.toml` |
| `walker/themes/default.css` | `~/.config/walker/themes/default.css` |

### TUI Apps

| Source | Destino |
|---|---|
| `tmux/tmux.conf` | `~/.config/tmux/tmux.conf` |
| `lazygit` | `~/.config/lazygit` |
| `ranger/rc.conf` | `~/.config/ranger/rc.conf` |
| `ranger/scope.sh` | `~/.config/ranger/scope.sh` |

### GTK & Herramientas

| Source | Destino |
|---|---|
| `gtk-3.0/settings.ini` | `~/.config/gtk-3.0/settings.ini` |
| `gtk-4.0/settings.ini` | `~/.config/gtk-4.0/settings.ini` |
| `swappy/config` | `~/.config/swappy/config` |

### OpenCode

| Source | Destino |
|---|---|
| `opencode/opencode.jsonc` | `~/.config/opencode/opencode.jsonc` |
| `opencode/agents` | `~/.config/opencode/agents` |
| `opencode/skills` | `~/.config/opencode/skills` |
| `opencode/commands` | `~/.config/opencode/commands` |

> ⚠️ **Importante**: Si creas un nuevo archivo de configuración, debes (1) crear el archivo en el directorio correspondiente, (2) añadir la entrada en `home.file` de `home.nix`, (3) ejecutar `uhm`. Sin el paso 2, el archivo no se despliega.

---

## 🌍 Variables de Entorno

Definidas en `home.sessionVariables` de `home.nix`. Home Manager las inyecta automáticamente en el shell del usuario.

### Esenciales

| Variable | Valor | Propósito |
|---|---|---|
| `EDITOR` | `nvim` | Editor por defecto del sistema |
| `COMPOSER_HOME` | `~/.composer` | Hogar de paquetes globales de Composer |
| `XDG_CONFIG_HOME` | `~/.config` | Directorio estándar de configuraciones |
| `ENGRAM_DB_PATH` | `~/.local/share/engram/engram.db` | Ruta a la base de datos de Engram |
| `DOCKER_API_VERSION` | `1.40` | Compatibilidad con API de Docker |

### 🌐 Wayland Environment

Todas las aplicaciones deben saber que corren bajo Wayland. Estas variables lo garantizan:

| Variable | Valor | Afecta a |
|---|---|---|
| `XCURSOR_SIZE` | `24` | Tamaño del cursor (global) |
| `XCURSOR_THEME` | `Bibata-Modern-Classic` | Tema del cursor |
| `GDK_BACKEND` | `wayland,x11` | GTK3/4 (prioriza Wayland, fallback X11) |
| `QT_QPA_PLATFORM` | `wayland;xcb` | Qt (prioriza Wayland, fallback XCB) |
| `QT_QPA_PLATFORMTHEME` | `qt5ct` | Tema de aplicaciones Qt |
| `QT_WAYLAND_DISABLE_WINDOWDECORATION` | `1` | Sin decoraciones nativas en Qt |
| `MOZ_ENABLE_WAYLAND` | `1` | Firefox (Wayland nativo) |
| `SDL_VIDEODRIVER` | `wayland` | Juegos y apps SDL2 |
| `_JAVA_AWT_WM_NONREPARENTING` | `1` | Aplicaciones Java (evita bugs de rendering) |
| `CLUTTER_BACKEND` | `wayland` | Clutter toolkit |
| `ELECTRON_OZONE_PLATFORM_HINT` | `wayland` | Electron apps (VS Code, etc.) |

---

## 🚀 Despliegue con `uhm`

### El alias

Definido en `.bashrc`:

```bash
alias uhm='home-manager switch -b backup --impure --flake ~/.dotfiles/home-manager#alejandrocabeza'
```

### Qué hace `uhm` paso a paso

1. **Evalúa el flake** — Nix lee `flake.nix`, resuelve inputs y carga `home.nix`
2. **Construye el entorno** — Descarga/computa paquetes necesarios
3. **Genera perfiles** — Crea el perfil de Home Manager en `/nix/store/`
4. **Symlinkea configuraciones** — Cada entrada de `home.file` se enlaza
5. **Ejecuta hooks de activación** — `createEngramDir`, `installTpm`, etc.
6. **Backup automático** — La flag `-b backup` renombra archivos preexistentes con extensión `.backup`

### Comandos útiles

```bash
uhm                          # Desplegar cambios
home-manager generations     # Listar versiones anteriores
home-manager switch --rollback  # Volver a la generación anterior
nix flake update             # Actualizar flake.lock a últimas versiones
```

---

## ⚡ Hooks de Activación

Home Manager permite ejecutar scripts personalizados durante el `switch`. Definidos en `home.activation` de `home.nix`:

### `createEngramDir`

```bash
mkdir -p /home/alejandrocabeza/.local/share/engram
```

Crea el directorio donde Engram almacena su base de datos SQLite de memoria persistente. Se ejecuta después de `writeBoundary` (fase de escritura de archivos).

### `installTpm`

```bash
mkdir -p "$HOME/.config/tmux/plugins"
if [ ! -d "$HOME/.config/tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm "$HOME/.config/tmux/plugins/tpm"
fi
```

Clona [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) si no existe. Se ejecuta después de `linkGeneration` (fase de symlinks), asegurando que el directorio `tmux/plugins` existe.

---

## 📝 Notas

### Programas configurados además de paquetes

Además de instalar paquetes y linkear archivos, `home.nix` configura:

- **neovim** — Habilitado como programa de Home Manager (para integración con `programs.neovim`)
- **ripgrep** — Con `--smart-case` por defecto
- **fzf** — Colores Gruvbox Material personalizados (`--color=fg:#d4be98,bg:-1,hl:#e67e80`, etc.), layout reverse, altura 40%
- **starship** — Prompt de bloques sólidos segmentados: `[username] → [dir] → [git] → [nix_shell] → [cmd_duration] ➜`

### Paquetes compilados desde source

| Paquete | Por qué |
|---|---|
| **Engram** | No está en nixpkgs; se compila con `buildGoModule` y un patch para Go 1.25.10 → 1.25.0 |

### PHP override

PHP no usa la versión por defecto de nixpkgs. Se construye con 10 extensiones adicionales y `memory_limit = 512M`. Composer se overridea para usar este PHP en lugar del estándar.

### `fonts.fontconfig.enable = true`

Hace que las Nerd Fonts (Hack, Symbols-only) estén disponibles globalmente en el sistema a través de fontconfig.

---

<p align="center">
  <sub>Hecho con ☕, ❄️ Nix y mucha paciencia • Alejandro Cabeza • 2025</sub>
</p>
