filetype on
syntax on

" Hybrid line numbers
set number
set relativenumber
set cursorline
set showmatch
set tw=72 fo=cqt wm=0

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


" Tab complete if text exists on the line
"
" directly from :help complete
function! CleverTab()
   if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
      return "\<Tab>"
   else
      return "\<C-N>"
   endif
endfunction

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

" Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

" vsnip
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

call plug#end()

lua require('plugins/lsp-keybinds')
lua require('plugins/telescope')
lua require('plugins/nvim-cmp')

" Initialize trouble
lua require("plugins/trouble")
lua require("plugins/nvim-web-devicons")

" Telescope
nnoremap ff <cmd>Telescope find_files<cr>
nnoremap fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

inoremap <Tab> <C-R>=CleverTab()<CR>
nnoremap <C-a> <cmd>TroubleToggle<cr>
autocmd FileType python setlocal textwidth=79 formatoptions+=t

"lua << EOF
"vim.lsp.set_log_level("debug")
"EOF
