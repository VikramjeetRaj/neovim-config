set background=dark
if !empty(globpath(&runtimepath, 'colors/catppuccin_mocha.vim'))
        colorscheme catppuccin_mocha
endif
set statusline=%f\ %m%r%=%y\ %{&fileencoding}\ %l:%c\ %p%%
let g:which_key_map = {'f': {'name': '+find'}, 's': {'name': '+splits'}, 'h': {'name': '+git'}, 'd': {'name': '+debug'}, 'o': {'name': '+tasks'}, 't': {'name': '+terminal'}}
if exists('*which_key#register') || !empty(globpath(&runtimepath, 'autoload/which_key.vim'))
        call which_key#register(mapleader, 'g:which_key_map')
        nnoremap <silent> <leader> :<C-u>WhichKey g:mapleader<CR>
endif
function! VimConfigDashboard() abort
        if argc() || line('$') != 1 || !empty(getline(1)) || &buftype !=# '' || !empty(expand('%')) | return | endif
        enew
        setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted
        call setline(1, ['','        V I M','','        e  New file','        f  File explorer','        r  Recent files','        q  Quit','','        Same keys. Vim underneath.'])
        setlocal nomodifiable nomodified nonumber nocursorline
        nnoremap <silent><buffer> e :enew<CR>
        nnoremap <silent><buffer> f :NERDTreeToggle<CR>
        nnoremap <silent><buffer> r :History<CR>
        nnoremap <silent><buffer> q :qa<CR>
endfunction
augroup VimConfigUI
        autocmd!
        autocmd VimEnter * if !get(g:, 'vim_config_no_dashboard', 0) | call VimConfigDashboard() | endif
augroup END
command! VimConfigHealth call VimConfigHealth()
function! VimConfigHealth() abort
        echo 'Vim config: ' . g:vim_config_root
        for l:feature in ['terminal','job','channel','timers','popupwin','textprop','clipboard','python3']
                echo printf('%-14s %s', '+' . l:feature, has(l:feature) ? 'OK' : 'missing')
        endfor
        for l:tool in ['git','curl','node','rg','fzf','g++','cc','go','java','javac','jdb','nc','dlv','lldb-dap','clang-format','goimports','gofmt','stylua']
                echo printf('%-14s %s', l:tool, executable(l:tool) ? exepath(l:tool) : 'not on PATH')
        endfor
        echo 'CoC: ' . (exists(':CocInfo') ? 'installed (:CocInfo for server state)' : 'run bootstrap and :PlugInstall')
        echo 'Vimspector: ' . (exists(':VimspectorReset') ? 'installed' : 'needs +python3 and :PlugInstall')
endfunction
