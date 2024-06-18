import { Application } from 'types/service/applications'
const applications = await Service.import('applications')

const WINDOW_NAME = 'app-launcher'

const AppLauncher = () => {
  const search = Variable('')
  const searchResults = Utils.derive([search], s =>
    applications
      .query(s)
      .sort((a, b) => a.name.localeCompare(b.name))
  )

  const closeLauncher = () => {
    search.value = ''
    App.closeWindow(WINDOW_NAME)
  }

  const SearchBox = Widget.Entry({
    placeholder_text: '',
    text: search.bind(),
    hexpand: true,
    onChange: ({ text }) => {
      search.value = text ?? ''
    },
    onAccept: () => {
      searchResults.value[0].launch()
      closeLauncher()
    }
  })

  const SearchBar = Widget.Box({
    className: 'search-bar',
    vertical: false,
    spacing: 5,
    children: [
      Widget.Label('Apps'),
      SearchBox
    ]
  })

  const AppListItem = (app: Application) => Widget.Button({
    visible: true,
    child: Widget.Box({
      vertical: false,
      spacing: 8,
      children: [
        Widget.Icon({
          icon: app.icon_name ?? 'application-default-icon',
          size: 32
        }),
        Widget.Label(app.name)
      ]
    }),
    onClicked: () => {
      app.launch()
      closeLauncher()
    }
  })

  const AppList = Widget.Scrollable({
    className: 'scrollable',
    hscroll: 'never',
    vscroll: 'always',
    child: Widget.ListBox({
      className: 'app-list'
    }).hook(searchResults, self => {
      self.foreach(w => w.destroy())
      searchResults
        .getValue()
        .map(AppListItem)
        .forEach(a => self.add(a))
    })
  })

  return Widget.Window({
    name: WINDOW_NAME,
    className: 'App-Launcher',
    keymode: 'on-demand',
    visible: false,
    child: Widget.Box({
      className: 'launcher-container',
      vertical: true,
      children: [
        SearchBar,
        AppList
      ]
    })
  }).keybind('Escape', closeLauncher)
}

export default AppLauncher
