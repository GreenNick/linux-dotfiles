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
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    config = function()
      local lsp = require('lsp-zero').preset({})
      lsp.on_attach(function(_, bufnr)
        -- Set default keybindings
        lsp.default_keymaps({ buffer = bufnr })
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
      end)
      -- Disable virtual text
      vim.diagnostic.config({
        virtual_text = false
      })
      -- Define custom diagnostic signs
      lsp.set_sign_icons({
        error = '',
        warn = '',
        hint = '',
        info = ''
      })
      lsp.setup()
      -- Load language configurations
      require('language_servers')
    end,
    dependencies = {
      -- LSP Support
      'neovim/nvim-lspconfig',
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      -- Autocompletion
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp',
      'L3MON4D3/LuaSnip',
    }
  },

  -- Java language server
  'mfussenegger/nvim-jdtls',

  -- Catppuccin color schemes
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    config = function()
      require('catppuccin').setup({
        integrations = {
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
          nvimtree = true,
          telescope = {
            enabled = true
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

  -- Tree file explorer
  {
    'nvim-tree/nvim-tree.lua',
    tag = 'nightly',
    config = function()
      require('nvim-tree').setup({
        hijack_cursor = true,
        sync_root_with_cwd = true,
        view = {
          centralize_selection = true,
          float = {
            enable = true,
            open_win_config = {
              width = 50,
              height = vim.api.nvim_win_get_height(0) - 2
            }
          }
        },
        renderer = {
          group_empty = true
        }
      })
    end,
    dependencies = {
      'nvim-tree/nvim-web-devicons'
    }
  },

  -- Fuzzy searching
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    config = function()
      require('telescope').load_extension('fzf')
    end,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'nvim-treesitter/nvim-treesitter',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make'
      }
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
