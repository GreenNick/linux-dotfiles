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

  -- Run external tools on events
  'neomake/neomake',

  -- Catppuccin color schemes
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    config = function()
      require('catppuccin').setup({
        integrations = {
          gitsigns = true,
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

  -- Tree file explorer
  {
    'nvim-tree/nvim-tree.lua',
    tag = 'nightly',
    config = function()
      require('nvim-tree').setup()
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

  -- Keybindings for code comments
  {
    'echasnovski/mini.comment',
    config = function()
      require('mini.comment').setup()
    end
  },

  -- Custom statusline
  {
    'echasnovski/mini.statusline',
    config = function()
      require('mini.statusline').setup({
        content = {
          active = function()
            local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
            local git = MiniStatusline.section_git({ trunc_width = 75 })
            local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
            local filename = MiniStatusline.section_filename({ trunc_width = vim.o.columns + 1 })
            local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
            local location = MiniStatusline.section_location({ trunc_width = 75 })

            return MiniStatusline.combine_groups({
              { hl = mode_hl, strings = { mode } },
              { hl = 'MiniStatuslineDevinfo', strings = { git, diagnostics } },
              '%<', -- Mark general truncate point
              { hl = 'MiniStatuslineFilename', strings = { filename } },
              '%=', -- End left alignment
              { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
              { hl = mode_hl, strings = { location } },
            })
          end,
          inactive = nil
        },
        set_vim_settings = false
      })
    end
  },

  -- Commands to work with "surroundings"
  {
    'echasnovski/mini.surround',
    config = function()
      require('mini.surround').setup()
    end
  },

  -- Highlight trailing whitespace
  {
    'echasnovski/mini.trailspace',
    config = function()
      require('mini.trailspace').setup()
    end
  },

  {
    'nvim-neorg/neorg',
    build = ':Neorg sync-parsers',
    opts = {
      load = {
        ['core.defaults'] = {},
        ['core.concealer'] = {},
        ['core.dirman'] = {
          config = {
            workspaces = {
              notes = '~/Notes'
            }
          }
        },
        ['core.export'] = {},
        ['core.export.markdown'] = {
          config = {
            extensions = 'all'
          }
        }
      }
    },
    dependencies = { 'nvim-lua/plenary.nvim' }
  }
}

local opts = { }
require('lazy').setup(plugins, opts)

