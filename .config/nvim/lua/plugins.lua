-- Plugin Setup --

-- Download packer if it is not installed
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({
    'git',
    'clone',
    '--shallow-submodules',
    'https://github.com/wbthomason/packer.nvim',
    install_path
  })
end

-- Resync packer when plugins are modified
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup END
]])

-- Load plugins
return require('packer').startup(function(use)
  -- Package manager
  use 'wbthomason/packer.nvim'

  -- Language Server Protocol configurations
  use 'neovim/nvim-lspconfig'

  -- Language parsing and syntax highlighting
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  -- Run external tools on events
  use 'neomake/neomake'

  -- Catppuccin color schemes
  use {
    'catppuccin/nvim',
    as = 'catppuccin'
  }

  -- Icons for nvim
  use 'nvim-tree/nvim-web-devicons'

  -- Setup nnn as file explorer
  use {
    'luukvbaal/nnn.nvim',
    config = function()
      local opts = {
        explorer = {
          width = 32
        },
        auto_open = {
          tabpage = 'picker'
        },
        replace_netrw = 'picker'
      }

      require('nnn').setup(opts)
    end
  }

  -- Git integration
  use 'lewis6991/gitsigns.nvim'

  -- Keybindings for code comments
  use 'echasnovski/mini.comment'

  -- Custom statusline
  use 'echasnovski/mini.statusline'

  -- Commands to work with "surroundings"
  use 'echasnovski/mini.surround'

  -- Highlight trailing whitespace
  use 'echasnovski/mini.trailspace' 

  -- Sync plugins after installing packer
  if packer_bootstrap then
    require('packer').sync()
  end
end)

