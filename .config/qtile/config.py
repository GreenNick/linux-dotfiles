import os
import subprocess
from libqtile import bar, hook, layout, qtile
from libqtile.backend.wayland import InputConfig
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from qtile_extras import widget

mod = "mod4"
home = os.path.expandvars('$HOME')
config_home = os.path.expandvars('$XDG_CONFIG_HOME')
screenshot_dir = f'{home}/Pictures/screenshots'
if qtile.core.name == 'wayland':
    launcher = f'{config_home}/eww/scripts/eww-launcher.sh --wayland'
    terminal = 'foot'
    screenshot = f'grim -g "$(slurp)" {screenshot_dir}/$(date +"%F@%T.png")'
else:
    launcher = f'{config_home}/eww/scripts/eww-launcher.sh --x11'
    terminal = 'alacritty'
    screenshot = ''

keys = [
    # Move window focus
    Key([mod], "h", lazy.layout.left(),
        desc="Move focus to left"),
    Key([mod], "j", lazy.layout.down(),
        desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(),
        desc="Move focus up"),
    Key([mod], "l", lazy.layout.right(),
        desc="Move focus to right"),
    Key([mod], "space", lazy.layout.next(),
        desc="Move window focus to other window"),

    # Move windows
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(),
        desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(),
        desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(),
        desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(),
        desc="Move window up"),

    # Resize windows
    Key([mod, "control"], "h", lazy.layout.grow_left(),
        desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(),
        desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(),
        desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(),
        desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(),
        desc="Reset all window sizes"),

    # lazy.window.toggle_maximize()

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([mod, "shift"], "Return", lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack"),
    Key([mod], "Return", lazy.spawn(terminal),
        desc="Launch terminal"),
    Key([mod], "s", lazy.spawn(screenshot, shell=True),
        desc="Take a screenshot"),

    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(),
        desc="Toggle between layouts"),
    Key([mod], 'm', lazy.window.toggle_maximize(),
        desc='Maximize window'),
    Key([mod], 'f', lazy.window.toggle_fullscreen(),
        desc='Fullscreen window'),
    Key([mod], "q", lazy.window.kill(),
        desc="Quit focused window"),
    Key([mod, "control"], "r", lazy.reload_config(),
        desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(),
        desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawn(launcher),
        desc="Run application launcher"),

    Key([], 'XF86AudioRaiseVolume', lazy.spawn('amixer -q sset Master 5%+'),
        desc=''),
    Key([], 'XF86AudioLowerVolume', lazy.spawn('amixer -q sset Master 5%-'),
        desc=''),
]

groups = [
    Group('top', layout='max'),
    Group('www',
          matches=[Match(wm_class='firefox'),
                   Match(wm_class='floorp')]),
    Group('dev',
          matches=[Match(wm_class='Alacritty'),
                   Match(wm_class='foot')]),
    Group('fun',
          matches=[Match(wm_class='Steam')]),
    Group('irc',
          matches=[Match(wm_class='discord'),
                   Match(wm_class='Slack')])
]

for i, group in enumerate(groups):
    keys.extend([
        # Switch to group by index
        Key([mod], str(i + 1), lazy.group[group.name].toscreen(),
            desc=f'Switch to group {group.name}'),
        # Move focused window to group by index
        Key([mod, 'shift'], str(i + 1),
            lazy.window.togroup(group.name, switch_group=False),
            desc=f'Move focused window to group {group.name}')
    ])

layouts = [
    layout.Tile(
        border_focus='#7287fd',  # Latte Lavender
        border_normal='#b7bdf8',  # Macchiato Lavender
        border_width=3,
        margin=4
    ),
    layout.Max(),
]

floating_layout = layout.Floating(
    border_focus='#7287fd',  # Latte Lavender
    border_normal='#b7bdf8',  # Macchiato Lavender
    border_width=3,
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

widget_defaults = dict(
    font='NotoSans Nerd Font Medium',
    fontsize=14,
    padding=4,
    theme_path=f'{config_home}/qtile/icons'
)
extension_defaults = widget_defaults.copy()

decor_group = {
    "decorations": [
        widget.decorations.RectDecoration(
            colour="#363a4f",
            radius=12,
            filled=True,
            padding_y=5,
            group=True
        )
    ],
    'padding': 10
}

decor = {
    "decorations": [
        widget.decorations.RectDecoration(
            colour="#363a4f",
            radius=12,
            filled=True,
            padding_y=5
        )
    ],
    'padding': 10
}

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.Spacer(length=4),
                widget.GroupBox(
                    highlight_method='text',
                    block_highlight_text_color='#24273a',  # Macchiato Base
                    this_current_screen_border='#c6a0f6',  # Macchiato Mauve
                    active='#cad3f5',  # Macchiato Text
                    inactive='#6e738d',  # Macchiato Overlay0
                    urgent_text='#ed8796',
                    padding_x=3,
                    rounded=False,
                    **decor_group
                ),
                widget.Prompt(),
                widget.Spacer(),
                widget.ALSAWidget(
                    foreground='#cad3f5',
                    bar_colour_normal='#8aadf4',
                    bar_colour_high='#f5a97f',
                    bar_colour_loud='#ed8796',
                    bar_colour_mute='#6e738d',
                    bar_background='#6e738d',
                    mode='both',
                    bar_height=24,
                    icon_size=24,
                    **decor_group
                ),
                widget.WiFiIcon(
                    foreground='#cad3f5',
                    active_colour='#cad3f5',
                    inactive_colour='#6e738d',
                    interface='wlo1',
                    **decor_group
                ),
                widget.Spacer(length=4),
                widget.Battery(
                    charge_char='󱐋  ',
                    discharge_char=' ',
                    full_char=' ',
                    show_short_text=False,
                    foreground='#a6da95',
                    low_foreground='#ed8796',
                    format='{char}  {percent:2.0%}',
                    **decor
                ),
                widget.Spacer(length=4),
                widget.CurrentLayout(foreground='#eed49f', fmt=' {}', **decor),
                widget.Spacer(length=4),
                widget.Clock(foreground='#91d7e3', format='󰃭 %a, %b %d', **decor),
                widget.Spacer(length=4),
                widget.Clock(foreground='#f5bde6', format=' %I:%M', **decor),
                widget.Spacer(length=4)
            ],
            36,
            margin=[0, 0, 4, 0],
            background='#24273a',  # Macchiato Base
        ),
        right=bar.Gap(4),
        left=bar.Gap(4),
        bottom=bar.Gap(4),
        wallpaper='~/Pictures/Wallpaper.png',
    ),
]

# Allow applications to auto-fullscreen themselves
auto_fullscreen = True
# Allow applications to auto-minimize after losing focus
auto_minimize = True
# Bring floating windows to the front when clicked
bring_front_click = 'floating_only'
# Warp cursor to the center of the focused window after hotkey
cursor_warp = True
# Send windows to groups based on matching rules
dgroups_app_rules = []
# Generate dynamic hotkeys for groups
dgroups_key_binder = None
# Allow applications to capture focus if they are in the current group
focus_on_window_activation = 'smart'
# Automatically focus window under cursor
follow_mouse_focus = True
# Automatically reconfigure screens after randr configuration changes
reconfigure_screens = True
# Set wmname to whitelisted string for java compatibility
wmname = 'LG3D'

# Configure input devices on Wayland
wl_input_rules = {
    'type:touchpad': InputConfig(
        click_method='clickfinger',
        natural_scroll=True,
        tap=True
    ),
    'type:keyboard': InputConfig(
        kb_layout='us',
        kb_options='caps:ctrl_modifier'
    )
}

# Run dex to autostart programs
@hook.subscribe.startup_once
def autostart():
    subprocess.run(f'{config_home}/qtile/autostart.sh')
