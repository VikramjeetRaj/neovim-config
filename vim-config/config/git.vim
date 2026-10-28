nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)
nmap <leader>hs <Plug>(GitGutterStageHunk)
nmap <leader>hr <Plug>(GitGutterUndoHunk)
nmap <leader>hp <Plug>(GitGutterPreviewHunk)
nnoremap <leader>hb :execute 'Git blame -L ' . line('.') . ',+1'<CR>
nnoremap <leader>hd :Gdiffsplit<CR>
function! VimConfigBlameToggle() abort
        let b:vim_config_blame = !get(b:, 'vim_config_blame', 0)
        if !b:vim_config_blame | echo '' | endif
endfunction
function! VimConfigBlameLine() abort
        if !get(b:, 'vim_config_blame', 0) || &buftype !=# '' || empty(expand('%')) | return | endif
        let l:out = system('git -C ' . shellescape(expand('%:p:h')) . ' blame -L ' . line('.') . ',+1 -- ' . shellescape(expand('%:t')))
        if !v:shell_error | echo trim(l:out) | endif
endfunction
nnoremap <leader>hB :call VimConfigBlameToggle()<CR>
augroup VimConfigBlame
        autocmd!
        autocmd CursorHold * call VimConfigBlameLine()
augroup END
