# Walker — Application Launcher 🚀

**Walker** es un application launcher para Wayland escrito en Go. Rápido, extensible mediante plugins nativos, con un potente sistema de prefixes. Es el launcher principal del sistema (hyprlauncher queda como secundario).

## ¿Por qué Walker?

| Característica | Walker | wofi/rofi |
|---------------|--------|-----------|
| Plugins nativos | ✅ | ❌ |
| Prefixes potentes | ✅ | ❌ |
| Rendimiento | ⚡ Go nativo | 🐍 scripting |
| Tema CSS | ✅ | limitado |

## Sistema de Prefixes 🎯

Escribe el prefix seguido de tu consulta:

| Prefix | Plugin | Qué hace |
|--------|--------|----------|
| `>` | runner | Ejecuta un comando |
| `=` | calc | Calculadora |
| `@` | websearch | Busca en la web |
| `:` | clipboard | Historial del portapapeles |
| `$` | windows | Cambia entre ventanas (switcher) |
| `;` | providerlist | Lista todos los providers |
| `/` | files | Busca archivos |
| `%` | bookmarks | Marcadores |
| `.` | symbols | Símbolos/emojis |
| `!` | todo | Notas rápidas |
| `'` | _(built-in)_ | Búsqueda exacta |

Además, el delimitador global `#` permite pasar argumentos a los comandos (ej. `> btop#--dark`).

## Plugins Disponibles 🔌

- **applications** — lanza apps del sistema
- **shell** — ejecuta comandos (modo overlay con exclusive_zone=-1)
- **websearch** — búsqueda web
- **calc** — calculadora integrada
- **clipboard** — historial del portapapeles vía cliphist
- **emoji** — selector de emojis
- **finder** — búsqueda de archivos
- **swallow** — ejecuta y cierra al abrir la app
- **hyprland** — cambia workspace y ventanas de Hyprland
- **wallpaper** — cambia el wallpaper
- **bluetooth** — gestiona dispositivos Bluetooth
- **switcher** — cambia entre ventanas abiertas
- **wifi** — gestión de redes WiFi

## Tema 🎨

Tema personalizado **Gruvbox Material** (`themes/default.css`) que sigue la paleta exacta del sistema (waybar, tmux, starship). Ventana redondeada con fondo semitransparente, tipografía Hack Nerd Font Mono, y placeholders en español.

## Atajo ⌨️

| Tecla | Acción |
|-------|--------|
| `SUPER + Space` | Abrir/cerrar Walker |

El keybind lo gestiona el propio Walker (no está en los binds de Hyprland).

## Despliegue 📦

Los archivos se linkean desde `home-manager/home.nix` mediante `home.file`. Para aplicar cambios:

```bash
uhm   # alias → home-manager switch -b backup --impure --flake ~/.dotfiles/home-manager#alejandrocabeza
```

## Archivos

```
walker/
├── config.toml        # Configuración principal
├── themes/
│   └── default.css    # Tema Gruvbox Material
└── README.md          # Este archivo
```
