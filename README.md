# 🏡 Dotfiles — Alejandro Cabeza

![Nix](https://img.shields.io/badge/Nix-✓-informational?style=flat)
![Home Manager](https://img.shields.io/badge/Home%20Manager-✓-blueviolet?style=flat)
![Fish](https://img.shields.io/badge/Shell-Fish-7c5f9b?style=flat)
![Wayland](https://img.shields.io/badge/Protocol-Wayland-7daea3?style=flat)
![Gruvbox](https://img.shields.io/badge/Theme-Gruvbox%20Material-d8a657?style=flat)
![GNOME](https://img.shields.io/badge/DE-GNOME-4a86cf?style=flat)
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
| **Estética funcional** | El tema Gruvbox Material no es solo bonito — está diseñado para reducir fatiga visual y mantener consistencia en cada rincón del sistema. |

> ⚠️ **Fuente de verdad**: Este README es una guía general. Para convenciones exactas y detalles de implementación, consulta el archivo [`AGENTS.md`](AGENTS.md). La fuente de verdad última **es el código fuente** (`home.nix`, configuraciones).

---

## ⚡ Stack Principal

```
Gestor   →  Nix + Home Manager (flake)
DE       →  GNOME (Wayland)
Terminal →  Alacritty → Tmux (prefix Ctrl+t) → Fish (Vi mode)
Prompt   →  Starship (bloques sólidos Gruvbox)
Editor   →  Neovim (NixCats + Lua)
Git      →  Delta (diff) + Lazygit (TUI)
Node     →  Fnm (Fast Node Manager)
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
├── ranger/                # 📁 File manager (previews, icons)
│   ├── rc.conf
│   └── scope.sh
│
├── lazygit/               # 🔧 Git TUI
│   └── config.yml
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
| **Tmux** | Gruvbox Material, powerline symbols (), pane-active-border verde |
| **Starship** | Bloques sólidos segmentados: username → dir → git → nix → cmd_duration |
| **Fzf** | Colores Gruvbox Material personalizados, layout reverse con borde |
| **Prompt** | Carácter `➜` verde en éxito, rojo en error |

### Fuentes

- **Hack Nerd Font Mono** — Terminal (Alacritty, Tmux, Neovim)
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

### 📡 Red & Hardware

| Paquete | Propósito |
|---|---|
| IWD | Daemon WiFi |
| NetworkManager applet | Applet GTK para WiFi |
| Blueman + Bluetui | Gestión Bluetooth |
| Brightnessctl | Control de brillo CLI |

### 🧰 Utilidades

| Paquete | Propósito |
|---|---|
| ImageMagick | Procesamiento de imágenes |
| Jq | Procesador JSON |
| wl-clipboard, xclip, xsel | Clipboard Wayland + X11 |
| Lsof | Listar archivos abiertos |
| Nerd Fonts Hack + Symbols-only | Fuentes con iconos |
| Grim + Slurp | Screenshots CLI (Wayland) |
| Engram | Memoria persistente para agentes AI (build from source) |
| ueberzugpp / poppler-utils / ffmpegthumbnailer / exiftool / glow | Previews para Ranger |
| Tesseract + FFmpeg | OCR y procesamiento multimedia |

---

## ⌨️ Atajos de Teclado

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

## 📝 Notas

### Arquitectura y decisiones

- **`uhm` es el corazón del sistema** — sin él, los cambios no toman efecto. Siempre ejecutar después de modificar configuraciones.
- **Engram** (memoria persistente para agentes) se compila desde source con un patch para Go 1.25.
- **PHP tiene memory_limit 512M** y extensiones optimizadas para Laravel.
- **Tmux usa `Ctrl+t`** como prefix (en lugar de `Ctrl+b`), liberando `Ctrl+b` para scroll nativo.

### Ambiente de desarrollo

Este entorno está diseñado para desarrollo **Back-End** (PHP, Laravel, Node.js, Python, Rust) pero es perfectamente usable para cualquier tipo de trabajo en terminal. El LAMP stack en Docker (`utils/lamp/`) incluye Apache + MySQL + PHPMyAdmin para desarrollo web tradicional.

---

## 🤝 Contribuir / Fork

¿Te gusta algo de esto? ¡Adelante!

1. **Haz fork** del repositorio
2. **Cambia las referencias personales** (`alejandrocabeza` → tu usuario)
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
