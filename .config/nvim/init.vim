" Neovim Configuration "

" Enable plugins with packer
lua require('plugins')

" Add language servers
lua require('language_servers')

" Treesitter configuration
lua require('treesitter')

" Neomake configuration
let g:neomake_javascript_enabled_makers = ['standard']
let g:neomake_javascript_standard_args = []
call neomake#configure#automake('w')

" Setup Catppuccin color scheme
set termguicolors
let g:catppuccin_flavour='macchiato'
colorscheme catppuccin

" Enable dynamic line numbers
set number
augroup number_toggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter *
    \ if &number && mode() != 'i' | set relativenumber | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave *
    \ if &number | set norelativenumber | endif
augroup END

" Hide empty command bar
set cmdheight=0

" Replace tabs with spaces
set tabstop=8
set softtabstop=2
set shiftwidth=2
set expandtab

" Add scroll offset
set scrolloff=3

" Fix hot reload watchers
set backupcopy=yes

" Reduce CursorHold time
set updatetime=500

" Disable netrw banner
let g:netrw_banner=0

" Set list style to tree
let g:netrw_liststyle=3

" Open files in previous window
let g:netrw_browse_split=4

" Decrease Lexplore pane width
let g:netrw_winsize=20

" Set <Leader> to <Space>
nnoremap <Space> <Nop>
let mapleader='<Space>'

" Execute default macro
nnoremap <Enter> @q

" Insert marker tag
inoremap <C-j><C-m> <++>

" Jump to next marker tag in file
nnoremap <C-j><C-j> /<++><Enter>"_cf>
inoremap <C-j><C-j> <Esc>/<++><Enter>"_cf>

