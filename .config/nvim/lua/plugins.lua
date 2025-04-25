-- Plugin Setup --

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  -- Language parsing and syntax highlighting
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate'
  },

  -- Language Server Protocol configuration
  {
    'neovim/nvim-lspconfig',
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(_, bufnr)
          -- Show diagnostics on hover
          vim.api.nvim_create_autocmd('CursorHold', {
            buffer = bufnr,
            callback = function()
              local opts = {
                focusable = false,
                close_events = {
                  'BufLeave',
                  'CursorMoved',
                  'InsertEnter',
                  'FocusLost'
                },
                border = 'rounded',
                source = 'always',
                prefix = '',
                scope = 'cursor'
              }
              vim.diagnostic.open_float(nil, opts)
            end
          })
        end
      })

      vim.diagnostic.config({
        -- Disable virtual text
        virtual_text = false,
        -- Define custom diagnostic signs
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = '',
            [vim.diagnostic.severity.WARN] = '',
            [vim.diagnostic.severity.HINT] = '',
            [vim.diagnostic.severity.INFO] = ''
          }
        }
      })

      -- Load language configurations
      require('language_servers')
    end,
    dependencies = { 'saghen/blink.cmp' }
  },

  -- Language Server Protocol autocompletion
  {
    'saghen/blink.cmp',
    version = '*',
    opts = {
      keymap = { preset = 'default' },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono'
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' }
      },
      fuzzy = { implementation = 'prefer_rust_with_warning' }
    },
    opts_extend = { 'sources.default' }
  },

  -- Java language server
  'mfussenegger/nvim-jdtls',

  -- Support for linters
  {
    'mfussenegger/nvim-lint',
    config = function()
      local lint = require('lint')
      lint.linters_by_ft = {
        java = { 'checkstyle' },
        javascript = { 'eslint' }
      }

      lint.linters.checkstyle.config_file = 'checkstyle.xml'

      vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
        callback = function()
          lint.try_lint()
        end
      })
    end
  },

  -- Improved UI for messages, cmdline, and pop-ups
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
      'nvim-treesitter/nvim-treesitter'
    },
    config = function()
      require('noice').setup({
        lsp = {
          override = {
            ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
            ['vim.lsp.util.stylize_markdown'] = true,
            ['cmp.entry.get_documentation'] = true
          }
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = false,
        }
      })
    end
  },

  -- LaTeX support
  {
    'lervag/vimtex',
    config = function()
      vim.g.vimtex_view_method = 'zathura'
    end
  },

  -- Catppuccin color schemes
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    config = function()
      require('catppuccin').setup({
        integrations = {
          blink_cmp = true,
          gitsigns = true,
          leap = true,
          mason = true,
          mini = true,
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
            },
            underlines = {
              errors = { "underline" },
              hints = { "underline" },
              warnings = { "underline" },
              information = { "underline" },
            },
            inlay_hints = {
              background = true,
            },
          },
          noice = true,
          nvim_surround = true,
          snacks = {
            enabled = true,
            indent_scope_color = 'lavender'
          },
          treesitter = true
        }
      })
    end,
    priority = 1000
  },

  -- Highlight color strings
  'norcalli/nvim-colorizer.lua',

  -- Git integration
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end
  },

  -- Custom statusline
  {
    'nvim-lualine/lualine.nvim',
    opts = {
      theme = 'catppuccin',
      options = {
        component_separators = '',
        section_separators = {
          left = '',
          right = ''
        }
      }
    },
    dependencies = {
      'nvim-tree/nvim-web-devicons'
    }
  },

  -- Collection of QoL plugins
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      -- Tree file explorer
      explorer = { enabled = true },
      -- Mark indent levels
      indent = {
        enabled = true,
        animate = { enabled = false }
      },
      -- Fuzzy searching
      picker = { enabled = true }
    },
    keys = {
      { '<leader>ff', function() Snacks.picker.files({ ignored = true }) end, desc = 'Find files' },
      { '<leader>fb', function() Snacks.picker.buffers() end, desc = 'Find buffers' },
      { '<leader>f/', function() Snacks.picker.grep() end, desc = 'Live grep' },
      { '<leader>fh', function() Snacks.picker.help() end, desc = 'Search help' },
      { '<leader>ft', function() Snacks.explorer() end, desc = 'Open explorer' }
    }
  },

  -- Jump with 2-char search
  {
    'ggandor/leap.nvim',
    config = function()
      require('leap').opts.highlight_unlabeled_phase_one_targets = true
      require('leap').add_default_mappings()
    end,
    dependencies = {
      'tpope/vim-repeat'
    }
  },

  -- Commands to work with "surroundings"
  {
    'kylechui/nvim-surround',
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end
  },

  -- Keybindings for code comments
  {
    'echasnovski/mini.comment',
    config = function()
      require('mini.comment').setup()
    end
  },

  -- Automatically insert "paired" characters
  {
    'echasnovski/mini.pairs',
    config = function()
      require('mini.pairs').setup()
    end
  },

  -- Highlight trailing whitespace
  {
    'echasnovski/mini.trailspace',
    config = function()
      require('mini.trailspace').setup()
    end
  }
}

local opts = {}
require('lazy').setup(plugins, opts)
