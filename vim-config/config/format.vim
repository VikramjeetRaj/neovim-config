" Buffer filters are transactional: failed commands never replace the buffer.
function! VimConfigFormat() abort
        if &buftype !=# '' || !&modifiable || &readonly | return | endif
        let l:cmds = []
        if &filetype ==# 'c' || &filetype ==# 'cpp'
                let l:cmds = [['clang-format','--style={BasedOnStyle: LLVM, IndentWidth: 8, TabWidth: 8, UseTab: Never}']]
        elseif &filetype ==# 'go'
                let l:cmds = [['goimports'],['gofmt']]
        elseif &filetype ==# 'lua'
                let l:cmds = [['stylua','--indent-type','Spaces','--indent-width','8','-']]
        endif
        let l:old = getline(1, '$')
        let l:text = join(l:old, "\n") . "\n"
        let l:used = 0
        for l:argv in l:cmds
                if !executable(l:argv[0]) | continue | endif
                let l:output = system(vimconfig#shell(l:argv), l:text)
                if v:shell_error
                        echohl WarningMsg | echom 'Format failed: ' . l:argv[0] . '. Keeping buffer unchanged.' | echohl None
                        return
                endif
                let l:text = l:output
                let l:used = 1
        endfor
        if !l:used
                if exists('*CocAction') && get(g:, 'coc_service_initialized', 0)
                        try
                                if CocAction('hasProvider', 'format') | call CocAction('format') | endif
                        catch
                                echom 'LSP format unavailable: ' . v:exception
                        endtry
                endif
                return
        endif
        let l:new = split(l:text, "\n", 1)
        if !empty(l:new) && l:new[-1] ==# '' | call remove(l:new,-1) | endif
        if empty(l:new) | let l:new = [''] | endif
        if l:new ==# l:old | return | endif
        let l:view = winsaveview()
        try
                try | undojoin | catch /^Vim\%((\a\+)\)\=:E790/ | endtry
                call setline(1, l:new)
                if line('$') > len(l:new)
                        try | undojoin | catch /^Vim\%((\a\+)\)\=:E790/ | endtry
                        call deletebufline('%',len(l:new)+1,'$')
                endif
        finally
                call winrestview(l:view)
        endtry
endfunction
command! VimFormat call VimConfigFormat()
