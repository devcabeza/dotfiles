# GTK 4.0 — Configuración de Tema

```
gtk-4.0/
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
gtk-application-prefer-dark-theme = 1
gtk-decoration-layout = menu:close
```

## 🔍 Diferencias con GTK3

GTK4 tiene una API más restrictiva — varias opciones de GTK3 **no están disponibles** en GTK4:

| Opción | GTK3 | GTK4 | Razón |
|--------|------|------|-------|
| `gtk-toolbar-style` | ✅ | ❌ | GTK4 elimina la personalización de toolbars |
| `gtk-toolbar-icon-size` | ✅ | ❌ | Se delega al tema/desarrollador |
| `gtk-button-images` | ✅ | ❌ | GTK4 no soporta iconos en botones globalmente |
| `gtk-menu-images` | ✅ | ❌ | Eliminado en GTK4 |
| `gtk-enable-event-sounds` | ✅ | ❌ | Sonidos se configuran vía freedesktop |
| `gtk-xft-*` | ✅ | ❌ | Anti-aliasing se configura a nivel de sistema, no GTK |

Las opciones compartidas (tema, iconos, fuente, cursor, dark theme, decoration) son idénticas.

## 🚀 Despliegue

Linkeado vía `home-manager/home.nix` → `home.file`. Ejecutar `uhm` para aplicar.
