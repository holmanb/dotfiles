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
if  has("autocmd")
	au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Highlight Trailing Whitespace
"
" Track which buffers have been created, and set the highlighting only once.
autocmd VimEnter * autocmd WinEnter * let w:created=1
autocmd VimEnter * let w:created=1
highlight WhitespaceEOL ctermbg=red ctermfg=white guibg=#592929
autocmd WinEnter *
  \ if !exists('w:created') | call matchadd('WhitespaceEOL', '\s\+$') | endif
call matchadd('WhitespaceEOL', '\s\+$')

" Highlight Past Column 80
"
" Change the background color past column 80 to indicate you've typed too
" much.
highlight ColorColumn ctermbg=239 guibg=#39393b
execute "set colorcolumn=" . join(range(80,80), ',')


" Plugins
call plug#begin('~/.config/nvim/plugged/')
	Plug 'neovim/nvim-lspconfig'
	Plug 'hrsh7th/nvim-compe'
	Plug 'neomake/neomake'
	Plug 'jiangmiao/auto-pairs'
	Plug 'glepnir/lspsaga.nvim'
	Plug 'lifepillar/vim-solarized8'
call plug#end()


highlight link CompeDocumentation NormalFloat

let g:compe = {}
let g:compe.enabled = v:true
let g:compe.autocomplete = v:true
let g:compe.debug = v:false
let g:compe.min_length = 1
let g:compe.preselect = 'enable'
let g:compe.throttle_time = 80
let g:compe.source_timeout = 200
let g:compe.incomplete_delay = 400
let g:compe.max_abbr_width = 100
let g:compe.max_kind_width = 100
let g:compe.max_menu_width = 100
let g:compe.documentation = v:true

let g:compe.source = {}
let g:compe.source.path = v:true
let g:compe.source.buffer = v:true
let g:compe.source.calc = v:true
let g:compe.source.nvim_lsp = v:true
let g:compe.source.nvim_lua = v:true
let g:compe.source.vsnip = v:true
let g:compe.source.ultisnips = v:true


" When writing a buffer (no delay).
call neomake#configure#automake('w')
" When writing a buffer (no delay), and on normal mode changes (after 750ms).
call neomake#configure#automake('nw', 750)
" When reading a buffer (after 1s), and when writing (no delay).
call neomake#configure#automake('rw', 1000)
" Full config: when writing or reading a buffer, and on changes in insert and
" normal mode (after 500ms; no delay when writing).
call neomake#configure#automake('nrwi', 500)
let g:neomake_python_enabled_makers = ['pylint']


" Initialize LSP
lua require('lsp-keybinds')
"
"inoremap <silent><expr> <C-Space> compe#complete()
"inoremap <silent><expr> <CR>      compe#confirm('<CR>')
"inoremap <silent><expr> <C-e>     compe#close('<C-e>')
"inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
"inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })
