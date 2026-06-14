# ~/.dotfiles/qtile/config.py
# Qtile Configuration — Migrated from Hyprland dotfiles
# Tema: Gruvbox Material | Layout: BSP (≈ Hyprland Dwindle)
#
# Uso:
#   qtile start                    # X11 (recomendado + picom)
#   qtile start -b wayland         # Wayland experimental
#
# Dependencias (añadidas en home.nix):
#   pkgs.qtile, pkgs.picom, pkgs.i3lock, pkgs.rofi, pkgs.wlr-randr
# Wayland: qtile start -b wayland  |  X11: qtile start + picom

import os
import subprocess
from libqtile import bar, layout, hook, widget
from libqtile.config import Click, Drag, Group, Key, Match, Rule, Screen
from libqtile.lazy import lazy


# ═══════════════════════════════════════════
# VARIABLES GLOBALES (≈ variables.lua)
# ═══════════════════════════════════════════

mod       = "mod4"   # SUPER
alt       = "mod1"   # ALT
shift     = "shift"
control   = "control"

terminal    = "alacritty"
filemanager = "nautilus"
home        = os.path.expanduser("~")
scripts     = f"{home}/.dotfiles/scripts"
nix_bin     = f"{home}/.nix-profile/bin"
wallpaper_dir = f"{home}/.dotfiles/wallpapers"

# Paleta Gruvbox Material (≈ decorations.lua + general.lua)
C = {
    "bg":            "#282828",
    "bg0_h":         "#1d2021",
    "bg0_s":         "#32302f",
    "fg":            "#ddc7a1",
    "fg_dim":        "#bdae93",
    "accent":        "#7daea3",
    "border_off":    "#504945",
    "red":           "#ea6962",
    "green":         "#a9b665",
    "yellow":        "#d8a657",
    "blue":          "#7daea3",
    "purple":        "#d3869b",
    "gray":          "#928374",
}


# ═══════════════════════════════════════════
# LAYOUTS (≈ general.lua dwindle)
# ═══════════════════════════════════════════

layouts = [
    layout.Bsp(
        name="dwindle",
        border_width=2,
        margin=10,                     # ≈ gaps_out = 10
        margin_on_single=10,
        border_focus=C["accent"],
        border_normal=C["border_off"],
        border_on_single=True,
        fair=False,                    # ≈ force_split = 2 (preserve split)
        grow_amount=2,
        ratio=0.5,
    ),
    layout.MonadTall(
        name="monadtall",
        border_width=2,
        margin=10,
        border_focus=C["accent"],
        border_normal=C["border_off"],
        ratio=0.55,
    ),
    layout.Max(
        name="max",
        border_width=2,
        border_focus=C["accent"],
        border_normal=C["border_off"],
    ),
    # Layout flotante (≈ windowrules.lua)
    layout.Floating(
        name="floating",
        border_width=2,
        border_focus=C["accent"],
        border_normal=C["border_off"],
    ),
]

# Para BSP: grow/shrink usa control+mod4+hjkl (≈ resize)
# Para MonadTall: grow/shrink también funciona
# layout.flip() para cambiar orientación de división


# ═══════════════════════════════════════════
# GRUPOS / WORKSPACES (≈ 4 workspaces + magic special)
# ═══════════════════════════════════════════

groups = []
for i in [1, 2, 3, 4]:
    groups.append(Group(str(i), label=f" {i} "))

# Scratchpad (≈ special:magic)
groups.append(Group("scratch", label="  "))


# ═══════════════════════════════════════════
# WINDOW RULES — Omarchy + comunes (≈ windowrules.lua)
# ═══════════════════════════════════════════

float_rules = [
    # Defaults de Qtile (diálogos, popups, etc.)
    *layout.Floating.default_float_rules,

    # ── Scripts Omarchy (APP_ID = org.omarchy.*) ──
    Match(wm_class="org.omarchy.wifi"),
    Match(wm_class="org.omarchy.bluetui"),
    Match(wm_class="org.omarchy.package-manager"),
    Match(wm_class="org.omarchy.keybinds-menu"),
    Match(wm_class="org.omarchy.screenshot"),
    Match(wm_class="org.omarchy.wallpaper-picker"),
    Match(wm_class="org.omarchy.btop"),
    Match(wm_class="org.omarchy.monitor-menu"),
    Match(wm_class="org.omarchy.sysmenu"),
    Match(wm_class="org.omarchy.text-extraction"),
    Match(wm_class="org.omarchy.audio-output"),
    Match(wm_class="org.omarchy.screenrecord"),
    Match(wm_class="org.omarchy.gaps-toggle"),
    Match(wm_class="org.omarchy.close-all"),

    # ── Apps comunes flotantes ──
    Match(wm_class="pavucontrol"),
    Match(wm_class="org.gnome.Calculator"),
    Match(wm_class="org.pwmt.zathura"),
    Match(wm_class="mpv"),
    Match(wm_class="imv"),
    Match(wm_class="org.keepassxc.KeePassXC"),
    Match(wm_class="Lxappearance"),
    Match(wm_class="bluetuith"),

    # ── Picture-in-Picture ──
    Match(title="Picture-in-Picture"),
]


# ═══════════════════════════════════════════
# KEYBINDS (≈ binds.lua — réplica completa)
# ═══════════════════════════════════════════

keys = [

    # ── Aplicaciones básicas ──
    Key([mod], "f",       lazy.spawn(filemanager),
        desc="Abrir gestor de archivos"),
    Key([alt], "space",   lazy.spawn("rofi -show drun -theme gruvbox-material"),
        desc="Launcher (≈ hyprlauncher)"),
    Key([mod], "space",   lazy.spawn(f"{scripts}/sysmenu.sh"),
        desc="Menú de sistema"),
    Key([mod], "Return",  lazy.spawn(terminal),
        desc="Abrir terminal"),
    Key([mod, shift], "q", lazy.shutdown(),
        desc="Cerrar sesión Qtile"),
    Key([mod], "w",       lazy.window.kill(),
        desc="Cerrar ventana"),
    Key([mod, shift], "m", lazy.window.toggle_floating(),
        desc="Toggle flotante"),
    Key([mod], "m",       lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen"),

    # Nota: conflicto original de Hyprland también usaba SUPER+SHIFT+M para
    # mic_toggle.sh — aquí prevalece toggle_floating, como en el original
    # (en Hyprland el último bind gana)

    # ── Movimiento de foco (Vim) ──
    Key([mod], "h", lazy.layout.left(),   desc="Foco izquierda"),
    Key([mod], "l", lazy.layout.right(),  desc="Foco derecha"),
    Key([mod], "k", lazy.layout.up(),     desc="Foco arriba"),
    Key([mod], "j", lazy.layout.down(),   desc="Foco abajo"),

    # ── Workspaces 1-4 ──
    Key([mod], "1", lazy.group["1"].toscreen(toggle=False), desc="WS 1"),
    Key([mod], "2", lazy.group["2"].toscreen(toggle=False), desc="WS 2"),
    Key([mod], "3", lazy.group["3"].toscreen(toggle=False), desc="WS 3"),
    Key([mod], "4", lazy.group["4"].toscreen(toggle=False), desc="WS 4"),
    Key([mod, shift], "1", lazy.window.togroup("1"), desc="Mover a WS 1"),
    Key([mod, shift], "2", lazy.window.togroup("2"), desc="Mover a WS 2"),
    Key([mod, shift], "3", lazy.window.togroup("3"), desc="Mover a WS 3"),
    Key([mod, shift], "4", lazy.window.togroup("4"), desc="Mover a WS 4"),

    # ── Redimensionar ventanas (grow/shrink en BSP) ──
    Key([mod, control], "h", lazy.layout.grow_left(),   desc="Reducir"),
    Key([mod, control], "l", lazy.layout.grow_right(),  desc="Agrandar"),
    Key([mod, control], "k", lazy.layout.grow_up(),     desc="Agrandar arriba"),
    Key([mod, control], "j", lazy.layout.grow_down(),   desc="Reducir abajo"),

    # ── Mover ventanas (≈ swap) ──
    Key([mod, shift], "h", lazy.layout.shuffle_left(),  desc="Swap izquierda"),
    Key([mod, shift], "l", lazy.layout.shuffle_right(), desc="Swap derecha"),
    Key([mod, shift], "k", lazy.layout.shuffle_up(),    desc="Swap arriba"),
    Key([mod, shift], "j", lazy.layout.shuffle_down(),  desc="Swap abajo"),

    # ── WiFi, Bluetooth, Wallpaper ──
    Key([mod], "n", lazy.spawn(f"{scripts}/wifi_menu.sh"),     desc="WiFi"),
    Key([mod], "b", lazy.spawn(f"{scripts}/bluetooth_menu.sh"), desc="Bluetooth"),
    Key([mod], "p", lazy.spawn(f"{scripts}/wallpaper_picker.sh"), desc="Wallpaper"),

    # ── Notificaciones (dunst) ──
    Key([], "Print",     lazy.spawn("dunstctl history-pop"), desc="Última notif"),
    Key([], "Scroll_Lock", lazy.spawn("dunstctl close"),     desc="Cerrar notif"),
    Key([mod, shift], "n", lazy.spawn("dunstctl history"),   desc="Historial"),
    Key([mod, shift], "d", lazy.spawn("dunstctl set-paused toggle"), desc="No molestar"),

    # ── Screenshots ──
    Key([mod, shift], "s", lazy.spawn(f"{scripts}/screenshot.sh"), desc="Screenshot"),

    # ── Screen recording & OCR ──
    Key([mod, shift], "r", lazy.spawn(f"{scripts}/screenrecord.sh"), desc="Grabar pantalla"),
    Key([mod, shift], "t", lazy.spawn(f"{scripts}/text_extraction.sh"), desc="OCR"),

    # ── Audio ──
    Key([mod, shift], "a", lazy.spawn(f"{scripts}/audio_output_switch.sh"), desc="Salida audio"),

    # Multimedia volume keys
    Key([], "XF86AudioRaiseVolume", lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),
        desc="Subir volumen"),
    Key([], "XF86AudioLowerVolume", lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
        desc="Bajar volumen"),
    Key([], "XF86AudioMute",        lazy.spawn("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
        desc="Toggle mute"),
    Key([], "XF86AudioMicMute",     lazy.spawn("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
        desc="Mute mic"),

    # ── Brillo ──
    Key([], "XF86MonBrightnessUp",   lazy.spawn("brightnessctl set 5%+"), desc="Subir brillo"),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 5%-"), desc="Bajar brillo"),

    # ── Utilidades ──
    Key([mod, alt], "g", lazy.spawn(f"{scripts}/gaps_toggle.sh"),        desc="Toggle gaps"),
    Key([mod, alt], "w", lazy.spawn(f"{scripts}/close_all_windows.sh"),  desc="Cerrar todo"),

    # ── Monitores ──
    Key([mod], "o", lazy.spawn(f"{scripts}/monitor_qtile.sh"), desc="Monitores"),

    # ── Sistema y Sesión ──
    Key([mod], "Escape",
        lazy.spawn(f"sudo {scripts}/sysmenu.sh"), desc="Menú sudo"),
    Key([mod, control], "r", lazy.reload_config(), desc="Recargar Qtile"),
    Key([mod, shift], "Escape",
        lazy.spawn("i3lock -c 1d2021"), desc="Bloquear pantalla (≈ hyprlock)"),

    # ── Atajos adicionales ──
    Key([mod], "slash",   lazy.spawn(f"{scripts}/keybinds_menu.sh"),   desc="Atajos"),
    Key([mod, shift], "p", lazy.spawn(f"{scripts}/package_manager.sh"), desc="Paquetes"),

    # ── Scratchpad (≈ special:magic) ──
    Key([mod, shift], "minus", lazy.window.togroup("scratch"), desc="Enviar a scratchpad"),
    Key([mod], "minus", lazy.group["scratch"].toscreen(),      desc="Toggle scratchpad"),

    # ── Navegación rápida entre workspaces ──
    Key([mod], "bracketright",  lazy.group.nextgroup(),        desc="Siguiente WS"),
    Key([mod], "bracketleft",   lazy.group.prevgroup(),        desc="WS anterior"),
    Key([mod, shift], "bracketright", lazy.window.togroup("+1"),  desc="Ventana al siguiente"),
    Key([mod, shift], "bracketleft",  lazy.window.togroup("-1"),  desc="Ventana al anterior"),

    # ── Cambiar layout ──
    Key([mod], "Tab", lazy.next_layout(), desc="Siguiente layout"),

    # ═══════════════════════════════════════════
    # LIMITACIONES CONOCIDAS — no replicable exactamente
    # ═══════════════════════════════════════════

    # ❌ Voice push-to-talk (release binds):
    #    Hyprland permite hl.bind(..., { release = true }) para detectar
    #    cuando se suelta la tecla. Qtile NO soporta on-release.
    #    Workaround: script externo con wev/xinput --test-xi2
    Key([alt], "i", lazy.spawn(f"{scripts}/voice_chat.sh start"),
        desc="Voice chat SOLO start (sin release)"),

    # ❌ Window groups (tabs) — no existe en Qtile
    #    Hyprland: hl.bind(SUPER+G, hl.dsp.group.toggle())
    #    Qtile no tiene "window grouping" con tabs.
    #    Alternativa: layout.Max o Stack

    # ❌ Locked binds (teclas que funcionan con pantalla bloqueada)
    #    En Qtile el locker captura todo. Depende del locker usado.
]


# ═══════════════════════════════════════════
# MOUSE (≈ binds.lua mouse:272 / mouse:273)
# ═══════════════════════════════════════════

mouse = [
    # SUPER + click izquierdo → mover ventana flotante
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    # SUPER + click derecho → redimensionar ventana flotante
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    # SUPER + click medio → cerrar
    Click([mod], "Button2", lazy.window.kill()),
]


# ═══════════════════════════════════════════
# HOOKS (≈ windowrules.lua assignment + decorations)
# ═══════════════════════════════════════════

@hook.subscribe.client_new
def assign_app_groups(client):
    """≈ windowrules.lua — Asigna por clase"""
    wm_class_list = client.get_wm_class() or []
    wm_class = " ".join(wm_class_list).lower()
    win_title = (client.name or "").lower()

    # Firefox → workspace 1 (excepto PiP)
    if "firefox" in wm_class and "picture-in-picture" not in win_title:
        client.togroup("1")

    # VSCode / Code → workspace 3
    if "code" in wm_class or "code-oss" in wm_class:
        client.togroup("3")


@hook.subscribe.client_focus
def on_focus(window):
    """≈ decorations.lua active/inactive opacity
    client_unfocus fue eliminado en Qtile moderno, así que
    iteramos todas las ventanas del grupo desde client_focus"""
    if not window:
        return
    try:
        window.opacity = 1.0
        for win in window.group.windows:
            if win != window and hasattr(win, 'opacity'):
                win.opacity = 0.92
    except Exception:
        pass


@hook.subscribe.float_change
def center_floating(window):
    """≈ windowrules.lua center=true — centra ventanas flotantes"""
    if window.floating:
        try:
            window.cmd_center()
        except Exception:
            pass


# ═══════════════════════════════════════════
# SCRATCHPAD CONFIG — dropdown terminal
# ═══════════════════════════════════════════

# El grupo "scratch" tiene un dropdown que es una terminal Alacritty
# se muestra/oculta con SUPER + minus
groups[-1].dropdowns = {
    "term": {
        "command": terminal,
        "width": 0.6,
        "height": 0.5,
        "x": 0.2,
        "y": 0.25,
        "opacity": 1.0,
        "match": Match(wm_class="Alacritty"),
        "on_focus_lost_hide": True,
    }
}


# ═══════════════════════════════════════════
# BARRA NATIVA DE QTILE
# Reemplaza a Waybar — muestra workspaces (GroupBox),
# layout actual, bandeja del sistema y reloj
# ═══════════════════════════════════════════

widget_defaults = dict(
    font="monospace",
    fontsize=13,
    padding=3,
    foreground=C["fg"],
    background=C["bg"],
)

screens = [
    Screen(
        top=bar.Bar(
            [
                # Workspaces (≈ waybar hyprland/workspaces)
                widget.GroupBox(
                    active=C["fg"],
                    inactive=C["gray"],
                    highlight_method="block",
                    highlight_color=C["bg0_s"],
                    urgent_border=C["red"],
                    this_current_screen_border=C["accent"],
                    this_screen_border=C["border_off"],
                    rounded=False,
                    spacing=4,
                    padding_x=4,
                    fontsize=14,
                ),
                widget.Spacer(),
                # Layout actual
                widget.CurrentLayout(foreground=C["accent"]),
                widget.Spacer(length=10),
                # Título de la ventana activa
                widget.WindowName(foreground=C["fg_dim"], max_chars=60),
                widget.Spacer(),
                # Bandeja del sistema
                widget.Systray(icon_size=18),
                widget.Spacer(length=5),
                # Reloj
                widget.Clock(format="%a %d %b  %H:%M", foreground=C["fg"]),
                widget.Spacer(length=5),
            ],
            28,
            background=C["bg"],
            border_width=[0, 0, 0, 0],
        ),
    ),
]


# ═══════════════════════════════════════════
# AUTOSTART (≈ autostart.lua)
# ═══════════════════════════════════════════

# Hook para wallpaper independiente (se ejecuta también en recargas)
@hook.subscribe.startup
def set_wallpaper():
    """Fondo de pantalla — se ejecuta en cada reload también"""
    subprocess.Popen(
        f"{nix_bin}/swaybg -i {wallpaper_dir}/$(ls {wallpaper_dir}/ | head -1) -m fill",
        shell=True,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )


@hook.subscribe.startup_once
def autostart():
    """≈ autostart.lua — Servicios al arrancar (una sola vez)"""
    commands = [
        f"{scripts}/wallpaper_carousel.sh",

        # Notificaciones
        f"{nix_bin}/dunst",

        # Polkit agent
        "/usr/lib/hyprpolkitagent",

        # Kanshi (perfiles de monitor automáticos)
        f"{nix_bin}/kanshi",

        # Si usas X11 y picom para blur/sombras:
        # "picom --experimental-backends --blur-method kawase"
    ]

    for cmd in commands:
        subprocess.Popen(cmd, shell=True,
                        stdout=subprocess.DEVNULL,
                        stderr=subprocess.DEVNULL)


# ═══════════════════════════════════════════
# CONFIGURACIÓN DEL SISTEMA (≈ misc.lua, cursor.lua, input.lua)
# ═══════════════════════════════════════════

dgroups_key_binder = None
dgroups_app_rules = []
follow_mouse_focus = True            # ≈ follow_mouse = 1
bring_front_click = False
cursor_warp = False                  # ≈ no_warps = false
auto_fullscreen = True
focus_on_window_activation = "smart" # ≈ focus_on_activate = true
reconfigure_screens = True
auto_minimize = False
wmname = "Qtile"                     # Para compatibilidad con apps

# ═══════════════════════════════════════════
# INPUT RULES — Wayland backend (qtile start -b wayland)
# ═══════════════════════════════════════════
# Descomentar si usas backend Wayland:
#
# from libqtile.backend.wayland import InputConfig
# wl_input_rules = {
#     "type:keyboard": InputConfig(
#         kb_layout="us",
#         kb_variant="altgr-intl",
#     ),
#     "type:touchpad": InputConfig(
#         natural_scroll=False,
#         tap=True,
#     ),
# }
