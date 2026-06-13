# 🚀 Waybar — Barra de Estado Flotante

**Waybar** es un reemplazo moderno de polybar para compositores Wayland. Esta config usa Hyprland como WM y está diseñada como una **barra flotante** (no ocupa todo el ancho).

## 🎨 Diseño Flotante

- **Layer**: `top`, posición superior
- **Margen**: `8px` arriba, `12px` a los lados → la barra no toca los bordes
- **Border-radius**: `12px` → efecto pastilla flotante
- **Altura**: `32px`

## 📦 Módulos

| Lado     | Módulos                                     |
| -------- | ------------------------------------------- |
| Izquierda | `hyprland/workspaces` · `hyprland/window` |
| Centro   | `clock`                                     |
| Derecha  | `pulseaudio` · `cpu` · `network` · `bluetooth` · `battery` · `tray` |

Cada módulo:
- 🔊 **pulseaudio** — icono + volumen, scroll para ajustar, click mute, click derecho → `pavucontrol`
- 💻 **cpu** — icono, click → `btop_menu.sh` (Omarchy)
- 🌐 **network** — icono + señal WiFi/Ethernet, click → `wifi_menu.sh` (Omarchy)
- 📡 **bluetooth** — icono + alias del dispositivo conectado, click → `bluetooth_menu.sh` (Omarchy)
- 🔋 **battery** — icono dinámico según carga, colores por estado (good/warning/critical)
- 🗂️ **tray** — iconos de apps en segundo plano
- 🗔 **window** — título de la ventana activa (50 caracteres máx), rewrite para Firefox/GNOME Terminal
- ⌨️ **workspaces** — iconos Nerd Font (󰎯–󰎹), solo muestra 4 workspaces persistentes

## 🎨 Estilo Gruvbox Material

Tema consistente con el resto del sistema:

| Elemento          | Color      |
| ----------------- | ---------- |
| Fondo barra       | `#1d2021` @ 90% opacidad |
| Texto             | `#ddc7a1` |
| Borde             | `#504945` |
| Accent (ws activo)| `#7daea3` |
| Hover             | `#3c3836` |
| Fuente            | `JetBrainsMono Nerd Font` 12px |

Los módulos tienen colores distintivos al hover:
- Pulseaudio → cyan, Network → verde, Bluetooth → púrpura, Battery → amarillo

## 🛠️ Cómo Modificar

### Añadir/quitar módulos

Edita `config.jsonc` y coloca el nuevo módulo en `modules-left`, `modules-center` o `modules-right`:

```jsonc
// Ejemplo: añadir módulo custom
"modules-right": ["pulseaudio", "cpu", "network", "bluetooth", "battery", "tray", "custom/mymod"]
```

### Cambiar estilos

Edita `styles.css` — los colores están definidos como `@define-color` al inicio del archivo para fácil modificación.

## 📦 Despliegue

```bash
uhm   # home-manager switch — linkea waybar/ a ~/.config/waybar/
```

El directorio está linkeado desde `home-manager/home.nix` mediante `home.file`. Siempre ejecutar `uhm` después de cualquier cambio.
