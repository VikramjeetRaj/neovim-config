" Set mapleader here before the keymaps load; default matches the Neovim setup.
let mapleader = get(g:, 'mapleader', '\')
set encoding=utf-8
filetype plugin indent on
syntax enable
set termguicolors timeoutlen=1500 mouse=
set number norelativenumber signcolumn=yes scrolloff=8 cursorline nowrap
set splitright splitbelow ignorecase smartcase hidden
set expandtab tabstop=8 shiftwidth=8 softtabstop=8 autoindent smartindent
set updatetime=1000 foldmethod=syntax foldlevel=99 foldlevelstart=99
set undofile laststatus=2 showtabline=2 completeopt=menuone,noinsert
if has('clipboard')
        set clipboard=unnamedplus
endif
if isdirectory(expand('~/.cargo/bin'))
        let $PATH = expand('~/.cargo/bin') . ':' . $PATH
endif
for s:dir in ['undo', 'swap', 'backup']
        call mkdir(g:vim_config_state . '/' . s:dir, 'p', 0700)
endfor
execute 'set undodir=' . fnameescape(g:vim_config_state . '/undo//')
execute 'set directory=' . fnameescape(g:vim_config_state . '/swap//')
execute 'set backupdir=' . fnameescape(g:vim_config_state . '/backup//')
unlet s:dir
