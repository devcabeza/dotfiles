import os
import subprocess
from libqtile import bar, layout, qtile, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

mod = "mod4"
terminal = "alacritty"

colors = {
    "bg":        "#282828",
    "bg0":       "#32302f",
    "bg1":       "#3c3836",
    "bg2":       "#504945",
    "fg":        "#ddc7a1",
    "fg_dim":    "#a89984",
    "fg_bright": "#ebdbb2",
    "red":       "#ea6962",
    "green":     "#a9b665",
    "yellow":    "#d8a657",
    "blue":      "#7daea3",
    "magenta":   "#d3869b",
    "cyan":      "#89b482",
    "orange":    "#e78a4e",
    "gray":      "#928374",
}

keys = [
    # Navigation
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    # Move windows
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Resize windows
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle split
    Key([mod, "shift"], "Return", lazy.layout.toggle_split(), desc="Toggle between split and unsplit"),
    # Apps
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "b", lazy.spawn("firefox"), desc="Launch browser"),
    Key([mod, "shift"], "b", lazy.spawn("thunar"), desc="Launch file manager"),
    # Launcher
    Key([mod], "space", lazy.spawn("rofi -show drun -theme gruvbox-material"), desc="Launch rofi"),
    Key([mod, "shift"], "space", lazy.spawn("rofi -show window -theme gruvbox-material"), desc="Window switcher"),
    # Layout management
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating"),
    # Screenshots
    Key([], "Print", lazy.spawn("grim"), desc="Full screenshot"),
    Key(["shift"], "Print", lazy.spawn('grim -g "$(slurp)"'), desc="Area screenshot"),
    # Qtile system
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn command"),
]

# VT switching for Wayland
for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
            desc=f"Switch to VT{vt}",
        )
    )

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
        Key([mod], i.name, lazy.group[i.name].toscreen(), desc=f"Switch to group {i.name}"),
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True), desc=f"Move window to group {i.name}"),
    ])

layouts = [
    layout.MonadTall(
        margin=8,
        border_width=2,
        border_focus=colors["blue"],
        border_normal=colors["bg1"],
        single_border_width=0,
        single_margin=8,
    ),
    layout.Columns(
        border_focus=colors["blue"],
        border_normal=colors["bg1"],
        border_width=2,
        margin=8,
    ),
    layout.Max(margin=8),
]

widget_defaults = dict(
    font="Hack Nerd Font Mono",
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.CurrentLayoutIcon(
                    custom_icon_paths=[],
                    foreground=colors["blue"],
                    background=colors["bg0"],
                    padding=0,
                    scale=0.7,
                ),
                widget.Spacer(length=4, background=colors["bg0"]),
                widget.GroupBox(
                    font="Hack Nerd Font Mono",
                    fontsize=12,
                    margin_y=3,
                    margin_x=0,
                    padding_y=6,
                    padding_x=5,
                    borderwidth=0,
                    active=colors["fg"],
                    inactive=colors["gray"],
                    rounded=False,
                    highlight_color=colors["bg1"],
                    highlight_method="line",
                    this_current_screen_border=colors["blue"],
                    this_screen_border=colors["bg2"],
                    other_current_screen_border=colors["bg2"],
                    other_screen_border=colors["bg1"],
                    foreground=colors["fg"],
                    background=colors["bg0"],
                    urgent_alert_method="text",
                    urgent_text=colors["red"],
                    urgent_border=colors["red"],
                ),
                widget.Prompt(
                    foreground=colors["fg"],
                    background=colors["bg0"],
                ),
                widget.Spacer(background=colors["bg0"]),
                widget.WindowName(
                    foreground=colors["fg"],
                    background=colors["bg0"],
                    width=bar.CALCULATED,
                ),
                widget.Spacer(background=colors["bg0"]),
                widget.Clock(
                    format="%Y-%m-%d %a %H:%M",
                    foreground=colors["fg"],
                    background=colors["bg0"],
                    padding=10,
                ),
                widget.Spacer(length=4, background=colors["bg0"]),
                widget.Systray(
                    foreground=colors["fg"],
                    background=colors["bg0"],
                    padding=5,
                ),
                widget.Spacer(length=4, background=colors["bg0"]),
                widget.QuickExit(
                    default_text="\uf011",
                    foreground=colors["red"],
                    background=colors["bg0"],
                    padding=10,
                    fontsize=16,
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

mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

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

wl_input_rules = None
wl_xcursor_theme = None
wl_xcursor_size = 24

idle_timers = []
idle_inhibitors = []

wmname = "LG3D"

@hook.subscribe.startup_once
def autostart():
    # Wallpaper (cambiar ruta si se desea)
    wallpaper = os.path.expanduser("~/wallpaper.jpg")
    if os.path.exists(wallpaper):
        subprocess.Popen(["feh", "--bg-fill", wallpaper])
    # NetworkManager applet
    subprocess.Popen(["nm-applet"])
