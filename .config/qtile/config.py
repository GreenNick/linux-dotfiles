# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os
import subprocess
from libqtile import bar, hook, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

mod = "mod4"
terminal = guess_terminal()

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

    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(),
        desc="Toggle between layouts"),
    Key([mod], "q", lazy.window.kill(),
        desc="Quit focused window"),
    Key([mod, "control"], "r", lazy.reload_config(),
        desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(),
        desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawn('rofi -modes "drun,run,window" -show drun'),
        desc="Run rofi launcher"),
]

groups = [
    Group('top'),
    Group('www',
          matches=[Match(wm_class='firefox')]),
    Group('dev',
          matches=[Match(wm_class='Alacritty')]),
    Group('fun',
          matches=[Match(wm_class='Steam')]),
    Group('irc',
          matches=[Match(wm_class='discord'),
                   Match(wm_class='Slack')])
]

for i, group in enumerate(groups):
    keys.extend(
        [
            # Switch to group by index
            Key([mod], str(i + 1), lazy.group[group.name].toscreen(),
                desc=f'Switch to group {group.name}'),
            # Move focused window to group by index
            Key([mod, 'shift'], str(i + 1),
                lazy.window.togroup(group.name, switch_group=True),
                desc=f'Move focused window to group {group.name}')
        ]
    )

layouts = [
    layout.Tile(
        border_focus='#7287fd',  # Latte Lavender
        border_normal='#b7bdf8',  # Macchiato Lavender
        border_width=3,
        margin=4
    ),
    layout.Max(),
    layout.Floating(),
    # layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=2),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font='NotoSans Nerd Font Medium',
    fontsize=14,
    padding=4,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.Spacer(length=8),
                widget.GroupBox(
                    highlight_method='block',
                    block_highlight_text_color='#24273a',  # Macchiato Base
                    this_current_screen_border='#c6a0f6',  # Macchiato Mauve
                    active='#cad3f5',  # Macchiato Text
                    inactive='#6e738d',  # Macchiato Overlay0
                    urgent_text='#FF0000',
                    spacing=0
                ),
                widget.Prompt(),
                widget.Spacer(),
                # widget.WindowName(),
                # widget.Chord(
                #     chords_colors={
                #         "launch": ('#ff0000', '#ffffff'),
                #     },
                #     name_transform=lambda name: name.upper(),
                # ),
                # widget.TextBox("default config", name="default"),
                # widget.TextBox("Press &lt;M-r&gt; to spawn", foreground="#d75f5f"),
                # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
                # widget.StatusNotifier(),
                widget.Systray(),
                widget.Battery(
                    charge_char='󰂄',
                    discharge_char='󰁾',
                    full_char='󰁹',
                    show_short_text=False,
                    foreground='#cad3f5',
                    format='{char} {percent:2.0%}'
                ),
                widget.CurrentLayout(foreground='#cad3f5', fmt=' {}'),
                widget.Clock(foreground='#cad3f5', format='󰸘 %a, %b %d'),
                widget.Clock(foreground='#cad3f5', format='󰅐 %I:%M'),
                widget.Spacer(length=8)
            ],
            36,
            margin=[8, 8, 4, 8],
            background='#24273a',  # Macchiato Base
        ),
        right=bar.Gap(4),
        left=bar.Gap(4),
        bottom=bar.Gap(4),
        wallpaper='~/Pictures/Wallpaper.png',
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
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
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# Run dex to autostart programs
@hook.subscribe.startup_once
def autostart():
    subprocess.run(os.path.expandvars('$XDG_CONFIG_HOME/qtile/autostart.sh'))

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
