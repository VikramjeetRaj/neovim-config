" Deliberate first-time bootstrap: run scripts/bootstrap.sh, then :PlugInstall.
" No downloads or package-manager commands are run during editor startup.
let s:plug = g:vim_config_data . '/autoload/plug.vim'
let g:coc_config_home = g:vim_config_root
let g:coc_global_extensions = ['coc-clangd', 'coc-go', 'coc-java', 'coc-lua', 'coc-snippets']
let g:gitgutter_map_keys = 0
let g:AutoPairsMapCR = 0
let g:NERDTreeMapOpenSplit = 'i'
let g:airline_powerline_fonts = 0
let g:airline_theme = 'catppuccin_mocha'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:indentLine_char = '│'
let g:indentLine_setConceal = 0
let g:vimspector_enable_mappings = ''
if get(g:, 'vim_config_no_plugins', 0) || !filereadable(s:plug)
        finish
endif
execute 'source ' . fnameescape(s:plug)
call plug#begin(g:vim_config_data . '/plugged')
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'honza/vim-snippets'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'Yggdroot/indentLine'
Plug 'liuchengxu/vim-which-key'
if has('python3')
        Plug 'puremourning/vimspector'
endif
call plug#end()
