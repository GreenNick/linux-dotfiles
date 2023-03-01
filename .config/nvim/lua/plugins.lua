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
    name = 'catppuccin'
  },

  -- Icons for nvim
  'nvim-tree/nvim-web-devicons',

  -- Setup nnn as file explorer
  {
    'luukvbaal/nnn.nvim',
    config = function() require('nnn').setup({
        explorer = {
          width = 32
        },
        auto_open = {
          tabpage = 'picker'
        },
        replace_netrw = 'picker'
      })
    end
  },

  -- Git integration
  'lewis6991/gitsigns.nvim',

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
      require('mini.statusline').setup()
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
  }
}

local opts = {
  checker = {
    enabled = true
  }
}

require('lazy').setup(plugins, opts)

