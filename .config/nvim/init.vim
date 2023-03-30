" Neovim Configuration "

" Enable plugins with packer
lua require('plugins')

" Add language servers
lua require('language_servers')

" Treesitter configuration
lua require('treesitter')

" Enable custom tabline
lua require('tabline').setup()

" Neomake configuration
let g:neomake_javascript_enabled_makers = ['standard']
let g:neomake_javascript_standard_args = []
call neomake#configure#automake('w')

" Setup Catppuccin color scheme
set termguicolors
colorscheme catppuccin-macchiato

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
inoremap <C-j><C-m> <++>

" Jump to next marker tag in file
nnoremap <C-j><C-j> /<++><Enter>"_cf>
inoremap <C-j><C-j> <Esc>/<++><Enter>"_cf>

" Zoom with new tab page
nnoremap <C-w><C-m> <cmd>tab split<Enter>
nnoremap <C-w>m <cmd>tab split<Enter>

" Tab navigation
nnoremap <C-n> <cmd>tabnext<Enter>
nnoremap <C-p> <cmd>tabprev<Enter>

" Telescope finders
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<Enter>
nnoremap <leader>f/ <cmd>lua require('telescope.builtin').live_grep()<Enter>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<Enter>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<Enter>
