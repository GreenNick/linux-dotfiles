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

  -- Keybindings for code comments
  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  }

  -- Commands to work with "surroundings"
  use 'tpope/vim-surround'

  -- Sync plugins after installing packer
  if packer_bootstrap then
    require('packer').sync()
  end
end)

