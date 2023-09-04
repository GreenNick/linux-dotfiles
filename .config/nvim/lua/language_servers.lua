-- Language Servers --

local lspconfig = require('lspconfig')

-- Python configuration
lspconfig.pylsp.setup {
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          ignore = {'E302'}
        }
      }
    }
  }
}

