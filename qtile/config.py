import os
import subprocess
from libqtile import bar, layout, qtile, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy

mod = "mod4"
terminal = "alacritty"


colors = {
    "bg": "#282828",
    "bg0": "#32302f",
    "bg1": "#3c3836",
    "bg2": "#504945",
    "fg": "#ddc7a1",
    "fg_dim": "#a89984",
    "fg_bright": "#ebdbb2",
    "red": "#ea6962",
    "green": "#a9b665",
    "yellow": "#d8a657",
    "blue": "#7daea3",
    "magenta": "#d3869b",
    "cyan": "#89b482",
    "orange": "#e78a4e",
    "gray": "#928374",
}

# --- Atajos de teclado ---
keys = [
    # Navegación entre ventanas
    Key([mod], "h", lazy.layout.left(), desc="Mover foco a la izquierda"),
    Key([mod], "l", lazy.layout.right(), desc="Mover foco a la derecha"),
    Key([mod], "j", lazy.layout.down(), desc="Mover foco hacia abajo"),
    Key([mod], "k", lazy.layout.up(), desc="Mover foco hacia arriba"),
    # Mover ventanas
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Mover ventana a la izquierda"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Mover ventana a la derecha"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Mover ventana hacia abajo"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Mover ventana hacia arriba"),
    # Redimensionar ventanas
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Agrandar ventana a la izquierda"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Agrandar ventana a la derecha"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Agrandar ventana hacia abajo"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Agrandar ventana hacia arriba"),
    Key([mod], "n", lazy.layout.normalize(), desc="Restablecer tamaños de ventana"),
    # Alternar división
    Key([mod, "shift"], "Return", lazy.layout.toggle_split(), desc="Alternar entre división y unión"),
    # Ciclo de escritorios
    Key([mod], "Left", lazy.screen.prev_group(), desc="Cambiar al escritorio anterior"),
    Key([mod], "Right", lazy.screen.next_group(), desc="Cambiar al siguiente escritorio"),
    # Aplicaciones
    Key([mod], "Return", lazy.spawn(terminal), desc="Lanzar terminal"),
    Key([mod], "b", lazy.spawn("firefox"), desc="Lanzar navegador"),
    Key([mod, "shift"], "b", lazy.spawn("thunar"), desc="Lanzar gestor de archivos"),
    # Lanzador
    Key([mod], "space", lazy.spawn("rofi -show drun -theme gruvbox-material"), desc="Lanzar rofi"),
    Key([mod, "shift"], "space", lazy.spawn("rofi -show window -theme gruvbox-material"), desc="Selector de ventanas"),
    # Gestión de ventanas
    Key([mod], "Tab", lazy.next_layout(), desc="Alternar entre layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Cerrar ventana enfocada"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Alternar pantalla completa"),
    Key([mod], "t", lazy.window.toggle_floating(), desc="Alternar flotante"),
    # Control de volumen
    Key([], "XF86AudioMute", lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle"), desc="Silenciar"),
    Key([], "XF86AudioLowerVolume", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%"), desc="Bajar volumen"),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%"), desc="Subir volumen"),
    Key(["shift"], "XF86AudioLowerVolume", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -1%"), desc="Bajar volumen con precisión"),
    Key(["shift"], "XF86AudioRaiseVolume", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +1%"), desc="Subir volumen con precisión"),
    # Control de brillo
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 5%-"), desc="Bajar brillo"),
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set +5%"), desc="Subir brillo"),
    Key(["shift"], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 1%-"), desc="Bajar brillo con precisión"),
    Key(["shift"], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set +1%"), desc="Subir brillo con precisión"),
    # Capturas de pantalla
    Key([], "Print", lazy.spawn("grim"), desc="Captura de pantalla completa"),
    Key(["shift"], "Print", lazy.spawn('grim -g "$(slurp)"'), desc="Captura de área"),
    # Sistema Qtile
    Key([mod, "control"], "r", lazy.reload_config(), desc="Recargar configuración"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Apagar Qtile"),
]

# Cambio de VT para Wayland
for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
            desc=f"Cambiar a VT{vt}",
        )
    )

# --- Grupos ---
groups = [
    Group("1", label="\ue795", layout="monadtall"),
    Group("2", label="\ued59", layout="monadtall"),
    Group("3", label="\ued1e", layout="monadtall"),
    Group("4", label="\uf086", layout="monadtall"),
    Group("5", label="\ued86", layout="monadtall"),
    Group("6", label="\uf001", layout="monadtall"),
    Group("7", label="\ued0b", layout="monadtall"),
    Group("8", label="\uf6ed", layout="max"),
    Group("9", label="\uedc6", layout="monadtall"),
]

for i in groups:
    keys.extend([
        Key([mod], i.name, lazy.group[i.name].toscreen(), desc=f"Cambiar al grupo {i.name}"),
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True), desc=f"Mover ventana al grupo {i.name}"),
    ])

# --- Layouts ---
layouts = [
    layout.MonadTall(
        margin=12,
        border_width=2,
        border_focus=colors["blue"],
        border_normal=colors["bg1"],
        single_border_width=0,
        single_margin=12,
    ),
    layout.Max(margin=12),
]

# --- Widgets y barra ---
widget_defaults = dict(
    font="Hack Nerd Font Mono",
    fontsize=12,
    padding=5,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.CurrentLayout(
                    custom_icon_paths=[],
                    foreground=colors["blue"],
                    background=colors["bg0"],
                    padding=0,
                    scale=0.7,
                ),
                widget.GroupBox(
                    font="Hack Nerd Font Mono",
                    fontsize=12,
                    margin_y=3,
                    margin_x=0,
                    padding_y=8,
                    padding_x=8,
                    borderwidth=0,
                    active=colors["fg"],
                    inactive=colors["gray"],
                    rounded=False,
                    highlight_color=colors["bg2"],
                    highlight_method="block",
                    this_current_screen_border=colors["blue"],
                    this_screen_border=colors["bg1"],
                    other_current_screen_border=colors["bg2"],
                    other_screen_border=colors["bg1"],
                    foreground=colors["fg"],
                    background=colors["bg0"],
                    urgent_alert_method="text",
                    urgent_text=colors["red"],
                    urgent_border=colors["red"],
                ),
                widget.Spacer(length=4, background=colors["bg0"]),
                widget.WindowName(
                    foreground=colors["fg"],
                    background=colors["bg0"],
                    width=bar.CALCULATED,
                ),
                widget.Spacer(background=colors["bg0"]),
                widget.Clock(
                    format="%H:%M",
                    foreground=colors["fg_bright"],
                    background=colors["bg0"],
                    padding=10,
                ),
            ],
            28,
            background=colors["bg0"],
            opacity=0.95,
            margin=[8, 8, 0, 8],
            border_width=[0, 0, 2, 0],
            border_color=[colors["bg1"], colors["bg1"], colors["blue"], colors["bg1"]],
        ),
        wallpaper=None,
        wallpaper_mode="fill",
    ),
]

# --- Ratón ---
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

# --- Configuración general ---
dgroups_key_binder = None
dgroups_app_rules = []
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),
        Match(wm_class="makebranch"),
        Match(wm_class="maketag"),
        Match(wm_class="ssh-askpass"),
        Match(title="branchdialog"),
        Match(title="pinentry"),
        Match(wm_class="pavucontrol"),
        Match(wm_class="blueman-manager"),
        Match(wm_class="nm-connection-editor"),
        Match(wm_class="org.gnome.Nautilus"),
        Match(title="Open File"),
        Match(title="Save As"),
    ],
    border_width=2,
    border_focus=colors["blue"],
    border_normal=colors["bg1"],
)
auto_fullscreen = True
focus_on_window_activation = "smart"
focus_previous_on_window_remove = False
reconfigure_screens = True
auto_minimize = True

# --- Configuración Wayland ---
wl_input_rules = None
wl_xcursor_theme = None
wl_xcursor_size = 24

idle_timers = []
idle_inhibitors = []

wmname = "LG3D"


@hook.subscribe.startup_once
def autostart():
    # Carrusel de wallpapers
    wallpaper_script = os.path.expanduser("~/.dotfiles/scripts/wallpaper-carousel.sh")
    if os.path.exists(wallpaper_script):
        subprocess.Popen(["bash", wallpaper_script])
    # NetworkManager applet
    subprocess.Popen(["nm-applet"])
