set noexpandtab     " insert spaces when hitting TABs
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red match ExtraWhitespace /\s\+$\| \+\ze\t/
autocmd FileType python setlocal noexpandtab


