" Neovim Configuration "

" Enable plugins with packer
lua require('plugins')

" Treesitter configuration
lua require('treesitter')

" Enable custom tabline
lua require('tabline').setup()

" Setup Catppuccin color scheme
set termguicolors
colorscheme catppuccin-macchiato

" Save uppercase global variables
" Save marks from up to 100 files
" Do not save register contents
" Max item size of 10 KiB
" Disable effect of hlsearch
set shada=!,'100,<0,s10,h

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

" Use global statusline
set laststatus=3

" Replace tabs with spaces
set tabstop=8
set softtabstop=2
set shiftwidth=2
set expandtab

" Enable smart indentation
set smartindent

" Enable line width marker
set colorcolumn=80

" Highlight search results
set incsearch
set hlsearch

" Break lines at word boundaries
set linebreak

" Add scroll offset
set scrolloff=3

" Fix hot reload watchers
set backupcopy=yes

" Reduce CursorHold time
set updatetime=500

" Set <Leader> to <Space>
nnoremap <Space> <Nop>
let mapleader=' '

" Disable q:, q/, q? keybindings
nnoremap q: <Nop>
nnoremap q/ <Nop>
nnoremap q? <Nop>

" Execute default macro
nnoremap <Enter> @q

" Insert marker tag
" NOTE: <C-_> is the same as <C-/>
inoremap <C-_><C-m> <++>

" Jump to next marker tag in file
" NOTE: <C-_> is the same as <C-/>
nnoremap <C-_><C-_> /<++><Enter>"_cf>
inoremap <C-_><C-_> <Esc>/<++><Enter>"_cf>

" Zoom with new tab page
nnoremap <C-w><C-m> <cmd>tab split<Enter>
nnoremap <C-w>m <cmd>tab split<Enter>

" Tab navigation
nnoremap <C-n> <cmd>tabnext<Enter>
nnoremap <C-p> <cmd>tabprev<Enter>

" Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Telescope finders
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<Enter>
nnoremap <leader>f/ <cmd>lua require('telescope.builtin').live_grep()<Enter>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<Enter>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<Enter>

" Toggle Nvim-Tree
nnoremap <leader>tt <cmd>lua require('nvim-tree.api').tree.toggle()<Enter>
