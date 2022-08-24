filetype on
syntax on

" Hybrid line numbers
set number
set relativenumber
set cursorline
set showmatch
set tw=72 fo=cqt wm=0
set foldmethod=indent
set nofoldenable
set tabstop=4
set shiftwidth=4

" jump to the last position when reopening a file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Highlight Trailing Whitespace
"
" Track which buffers have been created, and set the highlighting only once.
autocmd VimEnter * autocmd WinEnter * let w:created=1
autocmd VimEnter * let w:created=1

" Trailing whitespace
highlight WhitespaceEOL ctermbg=red ctermfg=white guibg=#592929
call matchadd('WhitespaceEOL', '\s\+$')

" treesitter uppercase variable names are same color as strings, lets do white
hi pythonTSConstant ctermfg=white


" Tabs after any character
call matchadd('WhitespaceEOL', '[^\t]\+\t\ze')

" Tab before spaces
call matchadd('WhitespaceEOL', '\t \+\ze')

" Highlight Past Column 80
"
" Change the background color past column 80
highlight ColorColumn ctermbg=239 guibg=#39393b
execute "set colorcolumn=" . join(range(80,80), ',')

" Popup menu color
" highlight Pmenu ctermbg=gray guibg=gray
highlight Pmenu ctermbg=DarkGrey guibg=DarkGrey

" Plugins
call plug#begin('~/.config/nvim/plugged/')

"Pretty diagnostics
Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/trouble.nvim'
Plug 'folke/lsp-colors.nvim'

" completion
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'jose-elias-alvarez/null-ls.nvim'

" Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

" Highlight
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'

" Git
Plug 'tpope/vim-fugitive'

" vsnip
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

" status line
Plug 'nvim-lualine/lualine.nvim'

" blank lines
Plug 'lukas-reineke/indent-blankline.nvim'

" Rust
Plug 'simrat39/rust-tools.nvim'
Plug 'mfussenegger/nvim-dap'

call plug#end()

set completeopt=menu,menuone,noselect

lua require('plugins/lsp-keybinds')
lua require('plugins/telescope')
lua require('plugins/nvim-cmp')

" Initialize trouble
lua require("plugins/trouble")
lua require("plugins/nvim-web-devicons")

" Telescope
nnoremap ff <cmd>Telescope find_files<cr>
nnoremap fg <cmd>Telescope live_grep<cr>
nnoremap fd <cmd>Telescope grep_string<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

"Fugitive
nnoremap gh <cmd>0Gclog<cr>

" Trouble
nnoremap tt <cmd>Trouble<cr>
nnoremap tc <cmd>TroubleClose<cr>

" Misc
nnoremap <C-a> <cmd>TroubleToggle<cr>
autocmd FileType python setlocal textwidth=79 formatoptions+=t

" Fold keymaps
" za - unfold cursor 1 level
" zr - unfold all 1 level
" zR - unfold all
" zM - fold all
nnoremap <S-f> zj  " jump forward to next fold
nnoremap <S-b> zk  " jump back to last fold

" Window Resize
" =============
" alt + [hjkl] - change window size
" <C-w> T      - open current window in a different tab
" g-t          - switch between tabs
"
" TODO:
" - combine background tab into foreground
" - rotate horizontal to vertical
" - anything else needed to get tmux parity with former workflow?
"
noremap <M-j> :resize +5<CR>
noremap <M-k> :resize -5<CR>
noremap <M-h> :vertical:resize -5<CR>
noremap <M-l> :vertical:resize +5<CR>

"lua << EOF
"vim.lsp.set_log_level("debug")
"EOF
