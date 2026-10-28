let s:terms = {}
let s:current = 1
function! VimConfigTerminalOpen(argv, cwd, name) abort
        if !has('terminal') | echoerr 'Vim needs +terminal.' | return -1 | endif
        botright new
        execute 'resize ' . max([5, float2nr(&lines * 0.3)])
        return term_start(a:argv, {'curwin': 1, 'cwd': a:cwd, 'term_name': a:name, 'term_finish': 'close'})
endfunction
function! VimConfigTerminal(id) abort
        let s:current = a:id
        let l:b = get(s:terms, a:id, -1)
        if bufexists(l:b) && term_getstatus(l:b) =~# 'running'
                let l:w = bufwinid(l:b)
                if l:w != -1
                        call win_execute(l:w, 'hide')
                        return
                endif
                botright new
                execute 'resize ' . max([5, float2nr(&lines * 0.3)])
                execute 'buffer ' . l:b
                if term_getstatus(l:b) =~# 'normal'
                        call feedkeys('i', 'n')
                endif
        else
                let s:terms[a:id] = VimConfigTerminalOpen([&shell], getcwd(), a:id == 1 ? 'Local' : 'Local (' . a:id . ')')
                call setbufvar(s:terms[a:id], '&bufhidden', 'hide')
        endif
endfunction
function! VimConfigTerminalToggle() abort
        call VimConfigTerminal(s:current)
endfunction
function! VimConfigTerminalAll() abort
        let l:visible = filter(values(copy(s:terms)), 'bufwinid(v:val) != -1')
        if !empty(l:visible)
                for l:b in l:visible | call win_execute(bufwinid(l:b), 'hide') | endfor
        else
                for l:id in sort(keys(s:terms)) | call VimConfigTerminal(str2nr(l:id)) | endfor
                if empty(s:terms) | call VimConfigTerminal(1) | endif
        endif
endfunction
function! VimConfigTerminalSelect() abort
        let l:n = inputlist(['Terminal session:','1. Local','2. Local (2)','3. Local (3)','4. Local (4)'])
        if l:n >= 1 && l:n <= 4 | call VimConfigTerminal(l:n) | endif
endfunction
nnoremap <silent> <C-\> :call VimConfigTerminalToggle()<CR>
nnoremap <silent> <A-F12> :call VimConfigTerminalToggle()<CR>
tnoremap <silent> <C-\> <C-w>:call VimConfigTerminalToggle()<CR>
tnoremap <silent> <A-F12> <C-w>:call VimConfigTerminalToggle()<CR>
tnoremap <Esc><Esc> <C-w>N
tnoremap <C-h> <C-w>h
tnoremap <C-j> <C-w>j
tnoremap <C-k> <C-w>k
tnoremap <C-l> <C-w>l
for s:i in range(1, 4)
        execute 'nnoremap <silent> <leader>t' . s:i . ' :call VimConfigTerminal(' . s:i . ')<CR>'
endfor
unlet s:i
" Vim has no interactive floating terminal; keep the same key for a docked shell.
nnoremap <leader>tf :call VimConfigTerminalToggle()<CR>
nnoremap <leader>ta :call VimConfigTerminalAll()<CR>
nnoremap <leader>ts :call VimConfigTerminalSelect()<CR>
