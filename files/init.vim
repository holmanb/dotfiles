" Bootstrap plugins
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

filetype on
syntax on

set relativenumber
set cursorline
set showmatch

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
inoremap <Tab> <C-R>=CleverTab()<CR>

" Plugins
call plug#begin('~/.config/nvim/plugged/')
	Plug 'neovim/nvim-lspconfig'
	Plug 'junegunn/fzf'
	Plug 'jiangmiao/auto-pairs'
	Plug 'glepnir/lspsaga.nvim'

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

	" vsnip
	Plug 'hrsh7th/cmp-vsnip'
	Plug 'hrsh7th/vim-vsnip'

call plug#end()

" Init plugins
lua require('lsp-keybinds')
lua require('nvim-cmp')

" Initialize trouble
lua require("plugins/trouble")
lua require("plugins/nvim-web-devicons")
