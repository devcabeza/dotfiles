# Swappy — Anotación de Capturas

```
swappy/
└── config
```

## 📸 ¿Qué es Swappy?

[Swappy](https://github.com/jtheoof/swappy) es una herramienta ligera de anotación de capturas de pantalla. Se integra con `grim` + `slurp` (el stack de screenshot de Wayland) para permitir dibujar, escribir texto y resaltar áreas sobre capturas.

## ⚙️ config

```ini
[Default]
save_dir=$HOME/Imágenes/Capturas
save_filename_format=captura-%Y%m%d-%H%M%S.png
show_panel=false
show_magnifier=false
line_size=3
text_size=18
text_font=JetBrainsMono Nerd Font
paint_color=#7daea3
font_color=#ebdbb2
```

### 🔍 Detalle

| Opción | Valor | Explicación |
|--------|-------|-------------|
| `save_dir` | `~/Imágenes/Capturas` | Directorio de salida para capturas anotadas |
| `save_filename_format` | `captura-%Y%m%d-%H%M%S.png` | Nomenclatura con timestamp |
| `show_panel` | `false` | Panel de herramientas oculto al iniciar |
| `show_magnifier` | `false` | Lupa deshabilitada |
| `line_size` | `3` | Grosor de línea de dibujo |
| `text_size` | `18` | Tamaño de fuente para texto |
| `text_font` | `JetBrainsMono Nerd Font` | Fuente monoespaciada (consistente con el sistema) |
| `paint_color` | `#7daea3` | Color teal (acento del tema Gruvbox Material) |
| `font_color` | `#ebdbb2` | Color crema claro (fg del tema) |

### 🔗 Integración

Swappy es llamado por `screenshot.sh` (script Omarchy `org.omarchy.screenshot`) después de seleccionar un área con `grim` + `slurp`. La captura original se envía a Swappy para anotación y luego se guarda.

## 🚀 Despliegue

Pendiente de añadir a `home-manager/home.nix`. Cuando se linkee, ejecutar `uhm`.
