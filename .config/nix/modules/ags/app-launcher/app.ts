import { App } from 'astal/gtk3'
import { exec } from 'astal/process'
import AppLauncher from './widget/AppLauncher'

exec('sass /home/nick/.config/nix/modules/ags/app-launcher/style/sass/:/tmp/ags/style/')

App.start({
  instanceName: 'app-launcher',
  css: '/tmp/ags/style/style.css',

  main(): void {
    AppLauncher()
  },

  client(message: (msg: string) => string): void {
    const response = message('show')
    print(response)

    return
  },

  requestHandler(request: string, response: (msg: number) => void): void {
    const window = App.get_window('app-launcher')
    switch (request) {
      case 'show':
        window!.is_visible() ? window!.hide() : window!.show()
        response(0)
        break
      default:
        response(1)
        break
    }
  }
})
