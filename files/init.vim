" TODO:
" discover:
" - combine background tab into foreground
" - rotate horizontal to vertical
" - anything else needed to get tmux parity with former workflow?
" - how to jump from one error/warning to the next:so $VIMRUNTIME/syntax/hitest.vim
" - system man page contents with telescope (keybind: fm)
" - work on diffviewopen configuration (make highlighting less horrendus)

filetype on
syntax on

" Hybrid line numbers
set number
"set relativenumber
set cursorline
set showmatch
set tw=72 fo=cqt wm=0
set foldmethod=indent
set nofoldenable
set tabstop=4
set shiftwidth=4
set fillchars+=diff:╱
set mouse=
autocmd FileType setlocal json expandtab autoindent


" jump to the last position when reopening a file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Highlight Trailing Whitespace
"
" Track which buffers have been created, and set the highlighting only once.
autocmd VimEnter * autocmd WinEnter * let w:created=1
autocmd VimEnter * let w:created=1


" Trailing whitespace
match errorMsg /\s\+$/

" Tab after character
match errorMsg /[^\t]\+\t\ze/

" Tab before spaces
match errorMsg /\t \+\ze/

" to see the different color groups run:
"
"    :so $VIMRUNTIME/syntax/hitest.vim
"
" treesitter uppercase variable names are same color as strings, lets do white
hi pythonTSConstant ctermfg=white

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
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
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

" diffview
" Plug 'sindrets/diffview.nvim'

" debugger
Plug 'mfussenegger/nvim-dap'
Plug 'mfussenegger/nvim-dap-python'

" range runner
Plug 'holmanb/range-runner.nvim'

" LSP Package manager
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'

call plug#end()


function Schema() range
  let tmp_file = '/tmp/nvim-schema-tmp.txt'
  let path = 'PYTHONPATH=/home/holmanb/cloud-init-a/ '
  let bin = '/home/holmanb/cloud-init/cloudinit/cmd/main.py '
  let subpcmd = 'schema -c '
  let cmd = path.bin.subpcmd.tmp_file
  echo system('echo '.shellescape(join(getline(a:firstline, a:lastline), "\n")).'> '.tmp_file.';'.cmd)
endfunction
com -range=% -nargs=0 Schema :<line1>,<line2>call Schema()

function Lxc_python() range
  let tmp_file = '/tmp/nvim-lxc-tmp.txt'
  let container = 'me'
  let lxc_shell = 'lxc exec '.container.' -- '
  let lxc_file = 'lxc.py'
  let lxc_cmd = 'python3 '.lxc_file
  let cmd = 'lxc file push '.tmp_file.' '.container.'/root/'.lxc_file.'; '.lxc_shell.lxc_cmd
  let body = shellescape(join(getline(a:firstline, a:lastline), "\n"))
  let full_cmd = 'echo '.body.'> '.tmp_file.';'.cmd
  echo 'Transfering:'
  echo '==========='
  echo body
  echo ''
  echo 'Running:'
  echo '========'
  echo cmd
  echo 'Output:'
  echo '======='
  echo system(full_cmd)
endfunction
com -range=% -nargs=0 Lxcpython :<line1>,<line2>call Lxc_python()

set completeopt=menu,menuone,noselect

lua require('plugins/lsp-keybinds')
lua require('plugins/telescope')
lua require('plugins/nvim-cmp')

" Initialize trouble
lua require("plugins/trouble")
lua require("plugins/nvim-web-devicons")

" Mason package LSP manager
lua require("mason").setup()
lua require("mason-lspconfig").setup{ automatic_installation = true, }


" DAP - debug adapter protocol
" https://github.com/mfussenegger/nvim-dap-python/pull/66
lua << EOF
  local dap = require('dap-python')
  dap.setup("~/.virtualenvs/debugpy/bin/python")
  dap.test_runner = 'mypytest'
  dap.test_runners.mypytest = function(...)
    local module, args = dap.test_runners.pytest(...)
    -- many verbs
    table.insert(args, '-v')
    table.insert(args, '-v')
    return module, args
  end
EOF

nnoremap dm :lua require('dap-python').test_method()<cr>
nnoremap dn :lua require('dap-python').test_class()<cr>

" Telescope
" =========
" file names
nnoremap ff <cmd>Telescope find_files<cr>
" entered string
nnoremap fg <cmd>Telescope live_grep<cr>
" string under cursor
nnoremap fd <cmd>Telescope grep_string<cr>
" vim help
nnoremap fh <cmd>Telescope help_tags<cr>
" manpage names
nnoremap fm <cmd>Telescope man_pages<cr>

"Fugitive
nnoremap gh <cmd>0Gclog<cr>

" Trouble
nnoremap tt <cmd>Trouble<cr>
nnoremap tc <cmd>TroubleClose<cr>

" Misc
nnoremap <C-a> <cmd>TroubleToggle<cr>
autocmd FileType python setlocal textwidth=79 formatoptions+=t

" Terminal mode
tnoremap jk <C-\><C-n>

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
noremap <M-j> :resize +5<CR>
noremap <M-k> :resize -5<CR>
noremap <M-h> :vertical:resize -5<CR>
noremap <M-l> :vertical:resize +5<CR>


"lua << EOF
"vim.lsp.set_log_level("debug")
"EOF
