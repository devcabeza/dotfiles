# Hyprland Config (Omarchy-inspired)

Configuración modular de Hyprland en Lua, inspirada en [Omarchy](https://github.com/basecamp/omarchy) por DHH.

## Estructura

```
hypr/
├── hyprland.lua          ← Entry point principal
├── hypridle.conf         ← Suspensión/bloqueo automático
├── hyprlock.conf         ← Pantalla de bloqueo
├── lua/
│   ├── monitors.lua      ← Monitores (no tocar)
│   ├── programs.lua      ← Programas (terminal, fm, menu)
│   ├── env.lua           ← Variables de entorno
│   ├── look.lua          ← Apariencia: bordes, blur, animaciones
│   ├── misc.lua          ← Flags del compositor
│   ├── input.lua         ← Teclado, touchpad, gestos
│   ├── keybinds.lua      ← Atajos de teclado
│   ├── windowRules.lua   ← Reglas de ventanas
│   ├── autostart.lua     ← Servicios al arranque
│   └── theme.lua         ← Paleta de colores Gruvbox
├── themes/
│   ├── gruvbox/colors.conf
│   ├── catppuccin/colors.conf
│   ├── tokyo-night/colors.conf
│   ├── kanagawa/colors.conf
│   ├── nord/colors.conf
│   └── rose-pine/colors.conf
└── README.md
```

## Dependencias

### Paquetes (instalar con pacman):
```bash
sudo pacman -S waybar mako walker hyprlock hypridle hyprpicker swaybg swww wlogout foot pavucontrol libnotify playerclip
```

### Ya instalados:
- grim, slurp, brightnessctl, btop, wl-clipboard, jq

## Atajos principales

| Tecla | Acción |
|-------|--------|
| `SUPER + Return` | Terminal (Alacritty) |
| `SUPER + Space` | Launcher (Walker) |
| `SUPER + Shift + S` | Screenshot smart |
| `SUPER + Escape` | Btop++ |
| `SUPER + Shift + L` | Bloquear pantalla |
| `SUPER + 1-9` | Cambiar workspace |
| `SUPER + Shift + 1-9` | Mover ventana a workspace |
| `Print` | Screenshot pantalla completa |
| `SUPER + Print` | Screenshot región |

## Configs asociadas

- `waybar/` — Barra glassmorphic
- `walker/` — Launcher con prefijos
- `mako/` — Notificaciones

## Scripts

- `scripts/screenshot.sh` — Capturas smart/region/fullscreen
- `scripts/swww-random.sh` — Wallpaper aleatorio
- `scripts/wallpaper-rotate.sh` — Rotación continua de wallpapers
- `scripts/setup-symlinks.sh` — Crear symlinks manualmente
