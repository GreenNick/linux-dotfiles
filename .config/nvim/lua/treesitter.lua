-- Treesitter Configuration --

require'nvim-treesitter.configs'.setup {
  -- Install all language parsers
  ensure_installed = 'all',

  -- Enable syntax highlighting
  highlight = { enable = true },

  -- Enable indentation
  indent = { enable = true }
}
