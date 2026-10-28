function! VimConfigAutosave() abort
        if &buftype ==# '' && &modifiable && !&readonly && !empty(expand('%')) && &modified
                silent! update
        endif
endfunction
augroup VimConfig
        autocmd!
        " Run after built-in ftplugins have applied their defaults.
        autocmd FileType * setlocal tabstop=8 shiftwidth=8 softtabstop=8 expandtab
        autocmd FileType go,make setlocal noexpandtab
        autocmd InsertLeave,TextChanged,BufLeave,FocusLost * call VimConfigAutosave()
        autocmd BufWritePre * call VimConfigFormat()
augroup END
