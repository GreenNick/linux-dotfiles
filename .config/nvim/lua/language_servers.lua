-- Language Servers --

local lspconfig = require('lspconfig')

-- Flow configuration
lspconfig.flow.setup {
  cmd = { 'flow', 'lsp' }
}

-- Python configuration
lspconfig.pylsp.setup {
  settings = {
    pylsp = {
      plugins = {
        -- Formating
        black = { enabled = true },
        autopep8 = { enabled = false },
        yapf = { enabled = false },
        pylsp_isort = { enabled = true },
        -- Linting
        ruff = { enabled = true },
        pycodestyle = { enabled = false },
        pyflakes = { enabled = false },
        pylint = { enabled = false },
        -- Type checking
        pylsp_mypy = {
          enabled = true,
          overrides = { '--python-executable', py_path, true },
          report_progress = true,
          live_mode = false
        },
        -- Auto-completion
        jedi_completion = { fuzzy = true }
      }
    }
  }
}

