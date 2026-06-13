# GTK 3.0 — Configuración de Tema

```
gtk-3.0/
└── settings.ini
```

## 🎨 settings.ini

```ini
[Settings]
gtk-theme-name = adw-gtk3-dark
gtk-icon-theme-name = gruvbox-plus
gtk-font-name = JetBrainsMono Nerd Font 10
gtk-cursor-theme-name = Bibata-Modern-Classic
gtk-cursor-theme-size = 24
gtk-toolbar-style = GTK_TOOLBAR_BOTH
gtk-toolbar-icon-size = GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images = 1
gtk-menu-images = 1
gtk-enable-event-sounds = 0
gtk-enable-input-feedback-sounds = 0
gtk-xft-antialias = 1
gtk-xft-hinting = 1
gtk-xft-hintstyle = hintslight
gtk-xft-rgba = rgb
gtk-application-prefer-dark-theme = 1
gtk-decoration-layout = menu:close
```

### 🔍 Detalle de opciones

| Opción | Valor | Explicación |
|--------|-------|-------------|
| `gtk-theme-name` | `adw-gtk3-dark` | Tema oscuro compatible con libadwaita para apps GTK3 |
| `gtk-icon-theme-name` | `gruvbox-plus` | Iconos estilo Gruvbox, consistentes con el tema general |
| `gtk-font-name` | `JetBrainsMono Nerd Font 10` | Fuente monoespaciada con Nerd Font patches (iconos) |
| `gtk-cursor-theme-name` | `Bibata-Modern-Classic` | Cursor moderno oscuro, tamaño 24px |
| `gtk-toolbar-style` | `GTK_TOOLBAR_BOTH` | Muestra iconos + texto en toolbars |
| `gtk-button-images` / `gtk-menu-images` | `1` | Habilita iconos en botones y menús |
| Sonidos | `0` | Deshabilita sonidos de eventos y feedback |
| `gtk-xft-*` | varios | Anti-aliasing Xft: suavizado, hinting suave, subpixel RGB |
| `gtk-application-prefer-dark-theme` | `1` | Preferencia global por variante oscura |
| `gtk-decoration-layout` | `menu:close` | Solo botón menú + cerrar en ventanas GTK |

## 🚀 Despliegue

Linkeado vía `home-manager/home.nix` → `home.file`. Ejecutar `uhm` para aplicar.
