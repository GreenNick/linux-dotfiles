-- Language Servers --

local lspconfig = require('lspconfig')

-- Flow (JavaScript)
lspconfig.flow.setup {}

-- HTML
lspconfig.html.setup {}

-- CSS
lspconfig.cssls.setup {}

-- Java
lspconfig.jdtls.setup {
  -- TODO: remove when recursive root search works
  root_dir = function()
    return vim.fn.getcwd()
  end
}

-- Python
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

-- Global diagnostic options
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = false
})

-- LSP setup autocmd
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf

    -- Use LSP suggestions for omnifunc
    if client.server_capabilities.completionProvider then
      vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
    end

    -- Use LSP tags for tagfunc
    if client.server_capabilities.definitionProvider then
      vim.bo[bufnr].tagfunc = 'v:lua.vim.lsp.tagfunc'
    end

    -- Use LSP formatting for formatexpr
    if client.server_capabilities.formatProvider then
      vim.bo[bufnr].formatexpr = 'v:lua.vim.lsp.formatexpr()'
    end

    -- Show diagnostics in hover window
    vim.api.nvim_create_autocmd('CursorHold', {
      buffer = bufnr,
      callback = function()
        local opts = {
          focusable = false,
          close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter', 'FocusLost' },
          border = 'single',
          source = 'always',
          prefix = '',
          scope = 'cursor'
        }
        vim.diagnostic.open_float(nil, opts)
      end
    })
  end
})

