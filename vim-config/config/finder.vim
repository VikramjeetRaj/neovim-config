let g:fzf_layout = { 'down': '~40%' }
function! VimConfigLiveGrep() abort
        if !executable('rg')
                echoerr 'Install ripgrep (rg) for project search.'
                return
        endif
        let l:rg = 'rg --column --line-number --no-heading --color=always --smart-case -- '
        call fzf#vim#grep(l:rg . shellescape('') . ' .', 1,
                \ fzf#vim#with_preview({'options': ['--disabled', '--phony', '--query', '', '--bind', 'change:reload:' . l:rg . '{q} . || true']}), 0)
endfunction
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fg :call VimConfigLiveGrep()<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fr :History<CR>
nnoremap <leader>fh :Helptags<CR>
nnoremap <leader>fs :CocList outline<CR>
nnoremap <leader>fd :CocList diagnostics<CR>
nnoremap <leader>fw :execute 'Rg ' . shellescape(expand('<cword>'))<CR>
