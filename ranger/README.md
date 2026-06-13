# Ranger — File Manager de Terminal

```
ranger/
├── rc.conf    # Config principal
└── scope.sh   # Script de previsualizaciones
```

## 📂 ¿Qué es Ranger?

[Ranger](https://ranger.github.io/) es un file manager de terminal con navegación por teclado (atajos Vi). Permite explorar directorios, previsualizar archivos y ejecutar acciones sin salir de la terminal.

## ⚙️ rc.conf

```bash
set use_preview_script true
set preview_script ~/.config/ranger/scope.sh
set preview_images true
set preview_images_method kitty
set preview_files true
set preview_directories true
set collapse_preview true
set draw_borders true
map o shell xdg-open %f &
```

### 🔍 Detalle

| Opción | Explicación |
|--------|-------------|
| `use_preview_script` | Habilita previsualizaciones dinámicas vía `scope.sh` |
| `preview_images` / `preview_images_method kitty` | Renderiza imágenes en terminal usando el protocolo nativo de Kitty (compatible con Alacritty vía kitty protocol) |
| `collapse_preview` | Colapsa previsualización al moverse para mejor rendimiento |
| `draw_borders` | Dibuja bordes entre paneles |
| `map o xdg-open %f &` | Tecla `o` abre archivo con app predeterminada |

## 📦 Dependencias

Instaladas vía `home-manager/home.nix`:

- **ueberzugpp** — fallback para previsualización de imágenes
- **poppler-utils** — previsualización de PDFs (`pdftoppm`)
- **ffmpegthumbnailer** — thumbnails de videos
- **exiftool** — metadatos de imágenes
- **glow** — previsualización de Markdown renderizado

## 🚀 Despliegue

Linkeado vía `home-manager/home.nix` → `home.file`. Ejecutar `uhm` para aplicar.
