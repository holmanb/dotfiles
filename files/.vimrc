filetype on
set relativenumber
set ts=4 sts=4 sw=4 expandtab autoindent fileformat=unix
set cursorline
set showmatch
set completeopt=menuone,noselect
colo default " looks nice with white background
let g:netrw_banner=0
syntax on

" Language Specific Behavior
autocmd FileType python setlocal encoding=utf-8 
let python_highlight_all=1
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab autoindent fileformat=unix
autocmd BufNewFile,BufRead,BufFilePre, *.md,*.markdown,*.mdown,*.mkd,*.mdwn,*.md set filetype=markdown

" jump to the last position when reopening a file
if  has("autocmd")
	 au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" this is the column that lsp warnings reside in (left of numbers)
hi SignColumn ctermbg=NONE ctermfg=NONE cterm=NONE

" ew
hi DiffDelete ctermbg=NONE ctermfg=NONE cterm=NONE

hi Pmenu ctermbg=NONE ctermfg=white cterm=NONE
hi PmenuSbar ctermbg=NONE ctermfg=white cterm=NONE
hi PmenuSel ctermbg=NONE ctermfg=white cterm=NONE
hi PmenuThumb ctermbg=NONE ctermfg=white cterm=NONE
hi link NormalFloat Normal
hi link Popup Normal
hi FloatBorder cterm=NONE ctermfg=white ctermbg=NONE
