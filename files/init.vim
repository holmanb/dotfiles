" Bootstrap plugins
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins
call plug#begin('~/.config/nvim/plugged/')
	Plug 'neovim/nvim-lspconfig'
	Plug 'hrsh7th/nvim-compe'
call plug#end()


" Initialize LSP
lua require('lspconfig').pyright.setup{}
lua require('lspconfig').clangd.setup{}
lua require('lspconfig').bashls.setup{}
lua require('lspconfig').vimls.setup{}
