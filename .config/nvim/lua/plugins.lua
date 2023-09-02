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
  -- Language Server Protocol configurations
  'neovim/nvim-lspconfig',

  -- Language parsing and syntax highlighting
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate'
  },

  -- Catppuccin color schemes
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    config = function()
      require('catppuccin').setup({
        integrations = {
          gitsigns = true,
          leap = true,
          mini = true,
          nvimtree = true,
          treesitter = true
        }
      })
    end
  },

  -- Icons for nvim
  'nvim-tree/nvim-web-devicons',

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
        open_on_setup = true,
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
    end
  },

  -- Fuzzy searching
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'BurntSushi/ripgrep',
      'nvim-lua/plenary.nvim'
    }
  },

  -- Java language server
  'mfussenegger/nvim-jdtls',

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

local opts = { }
require('lazy').setup(plugins, opts)

