import Apps, { Application } from 'gi://AstalApps'
import Astal from 'gi://Astal'
import { Variable, bind } from 'astal'
import { App, Gdk } from 'astal/gtk3'
import ColorIterator from './ColorIterator'
import ListBox from './ListBox'

const WINDOW_NAME = 'app-launcher'

const apps = new Apps.Apps()
const search = Variable('')
const searchResults = Variable.derive(
  [search],
  (search: string): Array<Application> => apps.fuzzy_query(search)
)

const closeLauncher = () => {
  search.set('')
  App.get_window(WINDOW_NAME)!.hide()
}

const SearchBox = (): JSX.Element =>
  <entry
    placeholderText={''}
    text={bind(search)}
    hexpand
    onChanged={({text}) => search.set(text ?? '')}
    onActivate={() => {
      searchResults.get()[0].launch()
      closeLauncher()
    }}
  />

const SearchBar = (): JSX.Element =>
  <box className='search-bar' spacing={5}>
    <label>Apps</label>
    <SearchBox />
  </box>

const AppListItem = (
  { app, color }: { app: Application, color: string }
): JSX.Element =>
  <button
    visible
    css={`:hover { background-color: ${color} }`}
    onClicked={() => {
      app.launch()
      closeLauncher()
    }}
  >
    <box spacing={8}>
      <icon
        icon={app.icon_name ?? 'application-default-icon'}
        iconSize={32}
      />
      <label>{app.name}</label>
    </box>
  </button>

const AppList = (): JSX.Element =>
  <scrollable
    className={'scrollable'}
  >
    <ListBox className={'app-list'}>
      {searchResults(results => {
        const colorIterator = new ColorIterator()

        return results.map(result =>
          (<AppListItem app={result} color={colorIterator.next()} />)
        )
      })}
    </ListBox>
  </scrollable>

const AppLauncher = (): JSX.Element =>
  <window
    name={'app-launcher'}
    application={App}
    className={'App-Launcher'}
    keymode={Astal.Keymode.ON_DEMAND}
    onKeyPressEvent={(_, event: Gdk.Event) => {
      if (event.get_keyval()[1] === Gdk.KEY_Escape) {
        closeLauncher()
      }
    }}
  >
    <box className={'launcher-container'}>
      <box vertical>
        <SearchBar />
        <AppList />
      </box>
      <box className={'side-image'} />
    </box>
  </window>

export default AppLauncher
