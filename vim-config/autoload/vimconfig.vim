function! vimconfig#root(markers) abort
        let l:dir = empty(expand('%:p')) ? getcwd() : expand('%:p:h')
        while 1
                for l:m in a:markers
                        if filereadable(l:dir . '/' . l:m) || isdirectory(l:dir . '/' . l:m) | return l:dir | endif
                endfor
                let l:parent = fnamemodify(l:dir, ':h')
                if l:parent ==# l:dir | return '' | endif
                let l:dir = l:parent
        endwhile
endfunction
function! vimconfig#wrapper(root, wrapper, fallback) abort
        return filereadable(a:root . '/' . a:wrapper) ? a:root . '/' . a:wrapper : a:fallback
endfunction
function! vimconfig#input() abort
        for l:p in [expand('%:p:h') . '/input.txt', getcwd() . '/input.txt']
                if filereadable(l:p) | return l:p | endif
        endfor
        return ''
endfunction
function! vimconfig#shell(argv) abort
        return join(map(copy(a:argv), 'shellescape(v:val)'), ' ')
endfunction
function! vimconfig#java_class() abort
        for l:line in getline(1, min([line('$'), 100]))
                let l:p = matchstr(l:line, '^\s*package\s\+\zs[[:alnum:]_.]\+\ze\s*;')
                if !empty(l:p) | return l:p . '.' . expand('%:t:r') | endif
        endfor
        return expand('%:t:r')
endfunction
