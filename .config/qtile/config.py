# import custom_widgets
import os
import subprocess
from catppuccin import Flavor
from libqtile import bar, hook, layout, qtile
from libqtile.backend.wayland import InputConfig
from libqtile.config import (Click, Drag, DropDown, Group, Key, Match,
                             ScratchPad, Screen)
from libqtile.lazy import lazy
from libqtile import widget
# from qtile_extras import widget

mod = "mod4"
home = os.path.expandvars('$HOME')
config_home = os.path.expandvars('$XDG_CONFIG_HOME')
screenshot_dir = f'{home}/Pictures/screenshots'
launcher = 'app-launcher'
if qtile.core.name == 'wayland':
    terminal = 'foot'
    screenshot = f'grim -g "$(slurp)" {screenshot_dir}/$(date +"%F@%T.png")'
else:
    terminal = 'alacritty'
    screenshot = ''

# Color themes
dark = Flavor.macchiato()
light = Flavor.latte()

# Keybindings
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
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(),
        desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(),
        desc="Move window up"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(),
        desc="Move window to the right"),

    # Resize windows
    Key([mod, "control"], "h", lazy.layout.grow_left(),
        desc="Grow window to the left"),
    Key([mod, "control"], "j", lazy.layout.grow_down(),
        desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(),
        desc="Grow window up"),
    Key([mod, "control"], "l", lazy.layout.grow_right(),
        desc="Grow window to the right"),
    Key([mod], "n", lazy.layout.normalize(),
        desc="Reset all window sizes"),

    Key([mod], 'Return', lazy.spawn(terminal),
        desc='Launch terminal'),
    Key([mod], 's', lazy.spawn(screenshot, shell=True),
        desc='Take a screenshot'),

    # Toggle between different layouts as defined below
    Key([mod], 'Tab', lazy.next_layout(),
        desc='Toggle between layouts'),
    Key([mod], 'm', lazy.window.toggle_maximize(),
        desc='Maximize window'),
    Key([mod, 'shift'], 'm', lazy.window.toggle_fullscreen(),
        desc='Fullscreen window'),
    Key([mod], 'q', lazy.window.kill(),
        desc='Quit focused window'),
    Key([mod, 'control'], 'r', lazy.reload_config(),
        desc='Reload the config'),
    Key([mod, 'control'], "q", lazy.shutdown(),
        desc='Shutdown Qtile'),
    Key([mod], 'r', lazy.spawn(launcher),
        desc='Run application launcher'),

    Key([], 'XF86AudioRaiseVolume', lazy.spawn('amixer -q sset Master 5%+'),
        desc=''),
    Key([], 'XF86AudioLowerVolume', lazy.spawn('amixer -q sset Master 5%-'),
        desc=''),

    Key([mod], 'b', lazy.group['scratch'].dropdown_toggle('btm'),
        desc=''),
    Key([mod], 'c', lazy.group['scratch'].dropdown_toggle('calcurse'),
        desc=''),
    Key([mod], 'n', lazy.group['scratch'].dropdown_toggle('newsboat'),
        desc=''),
    Key([mod], 'f', lazy.group['scratch'].dropdown_toggle('nnn'),
        desc='')
]

drop_kwargs = {
    'opacity': 1,
    'height': 0.66,
    'width': 0.64,
    'x': 0.18,
    'y': 0.17
}
groups = [
    Group('www',
          matches=[Match(wm_class='firefox'),
                   Match(wm_class='floorp')]),
    Group('dev',
          matches=[Match(wm_class='Alacritty'),
                   Match(wm_class='foot')]),
    Group('log',
          matches=[Match(wm_class='Logseq')]),
    Group('fun',
          matches=[Match(wm_class='steam')]),
    Group('irc',
          matches=[Match(wm_class='discord'),
                   Match(wm_class='Slack')]),
    ScratchPad('scratch', [
        DropDown('btm', 'foot -e btm', **drop_kwargs),
        DropDown('calcurse', 'foot -e calcurse', **drop_kwargs),
        DropDown('newsboat', 'foot -e newsboat', **drop_kwargs),
        DropDown('nnn', 'foot -e nnn -de', **drop_kwargs)
    ])
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
        add_after_last=True,
        border_focus=light.lavender,
        border_normal=dark.lavender,
        border_width=3,
        margin=3
    ),
    layout.Max()
]

floating_layout = layout.Floating(
    border_focus=light.lavender,
    border_normal=dark.lavender,
    border_width=3,
    float_rules=[
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
    font='NotoSans Nerd Font SemiBold',
    fontsize=14,
    padding=4,
    theme_path=f'{config_home}/qtile/icons'
)
extension_defaults = widget_defaults.copy()

# decor_group = {
#     'decorations': [
#         widget.decorations.RectDecoration(
#             colour=dark.surface0,
#             radius=12,
#             filled=True,
#             padding_y=5,
#             group=True
#         )
#     ],
#     'padding': 10
# }
#
# decor = {
#     'decorations': [
#         widget.decorations.RectDecoration(
#             colour=dark.surface0,
#             radius=12,
#             filled=True,
#             padding_y=5
#         )
#     ],
#     'padding': 10
# }

BAT_PATH = '/sys/class/power_supply'
batteries = [f for f in os.listdir(BAT_PATH) if f.startswith('BAT')]

if len(batteries) != 0:
    battery_widget = widget.Battery(
        charge_char='󱐋 ',
        discharge_char='',
        full_char='',
        not_charging_char='',
        show_short_text=False,
        foreground=dark.green,
        low_foreground=dark.red,
        format='{char} {percent:2.0%}',
        # **decor
    )
else:
    battery_widget = widget.TextBox(
        foreground=dark.green,
        fmt='',
        # **decor
    )

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.Spacer(length=4),
                widget.TextBox(
                    '󰌽', foreground=dark.blue,
                    # **decor
                ),
                widget.Spacer(length=4),
                widget.GroupBox(
                    highlight_method='text',
                    block_highlight_text_color=dark.base,
                    this_current_screen_border=dark.mauve,
                    active=dark.text,
                    inactive=dark.overlay0,
                    urgent_text=dark.red,
                    padding_x=2,
                    rounded=False,
                    disable_drag=True,
                    # **decor_group
                ),
                widget.Prompt(),
                widget.Spacer(),
                widget.Spacer(),
                # widget.ALSAWidget(
                #     foreground=dark.text,
                #     bar_colour_normal=dark.blue,
                #     bar_colour_high=dark.peach,
                #     bar_colour_loud=dark.red,
                #     bar_colour_mute=dark.overlay0,
                #     bar_background=dark.overlay0,
                #     mode='both',
                #     bar_height=24,
                #     icon_size=24,
                #     # **decor_group
                # ),
                # widget.WiFiIcon(
                #     foreground=dark.text,
                #     active_colour=dark.text,
                #     inactive_colour=dark.overlay0,
                #     interface='wlo1',
                #     # **decor_group
                # ),
                widget.Spacer(length=4),
                battery_widget,
                widget.Spacer(length=4),
                # custom_widgets.CurrentLayout(
                #     foreground=dark.yellow,
                #     layout_icons={
                #         'tile': '',
                #         'max': ''
                #     },
                #     **decor
                # ),
                widget.Spacer(length=4),
                widget.Clock(
                    foreground=dark.sky,
                    format='󰃭 %a, %b %d',
                    # **decor
                ),
                widget.Spacer(length=4),
                widget.Clock(
                    foreground=dark.pink,
                    format=' %I:%M',
                    # **decor
                ),
                widget.Spacer(length=4)
            ],
            36,
            margin=[0, 0, 3, 0],
            background=dark.base,
        ),
        right=bar.Gap(3),
        left=bar.Gap(3),
        bottom=bar.Gap(3),
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
