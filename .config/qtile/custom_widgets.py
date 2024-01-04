from libqtile import bar
from qtile_extras import widget

class CurrentLayout(widget.CurrentLayout):
    defaults = [('layout_icons', {},
                 'Dictionary with layout names as keys and icons as values')]

    def __init__(self, width=bar.CALCULATED, **config):
        widget.CurrentLayout.__init__(self, width, **config)
        self.add_defaults(CurrentLayout.defaults)

    def hook_response(self, layout, group):
        if group.screen is not None and group.screen == self.bar.screen:
            name = layout.name
            icon = self.layout_icons[name]
            self.text = f'{icon} {name}'
            self.bar.draw()
