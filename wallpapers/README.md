# Wallpapers — Colección

```
wallpapers/
├── ~127 imágenes
├── .jpg / .png
├── 3840x2160 (4K)
└── 5120x2880 (5K)
```

## 🖼️ Contenido

Colección de ~127 wallpapers de alta resolución:

- **Anime** — mayoría (One Piece, Demon Slayer, Jujutsu Kaisen, Naruto, etc.)
- **Autos** — BMW, Ducati, Triumph
- **Paisajes** — astronautas, bioluminiscencia, atardeceres
- **Juegos** — GTA VI, Call of Duty, Ghost of Yōtei, Spider-Man
- **Películas/Series** — Dune, Arcane, Blue Eye Samurai, The Fantastic Four

## 🔗 Integración

| Script | Función |
|--------|---------|
| `wallpaper_carousel.sh` (org.omarchy.wallpaper-picker) | Carrusel automático — rota wallpapers aleatoriamente cada N segundos |
| `wallpaper_picker.sh` | Selector interactivo con `fzf` — permite elegir wallpaper |

Ambos scripts usan **swaybg** para renderizar el fondo de pantalla (compatible con Hyprland/Wayland).

## 🚀 Despliegue

Los scripts están en `scripts/` y los wallpapers en este directorio. No requieren linkeo — se referencian por ruta relativa.
