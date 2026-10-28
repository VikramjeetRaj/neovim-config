let g:vim_config_no_plugins = 1
let g:vim_config_no_dashboard = 1
let g:vim_config_state = $VIM_CONFIG_TEST_STATE
execute 'source ' . fnameescape($VIM_CONFIG_TEST_ROOT . '/vimrc')
call assert_equal(8, &shiftwidth)
call assert_equal(1500, &timeoutlen)
call assert_equal('', &mouse)
call assert_equal('syntax', &foldmethod)
call assert_equal(99, &foldlevel)
for s:key in ['L','H','<leader>x','<leader>e','<leader>ff','<leader>fg','<leader>fs','<leader>fd','<leader>fw','gd','gD','grr','grn','gra','gri','gO','K','[d',']d',']h','[h','<leader>hs','<leader>hr','<leader>hp','<leader>hb','<leader>hB','<leader>hd','<leader>or','<leader>ot','<leader>dc','<leader>db','<leader>dB','<leader>dr','<leader>dl','<leader>dq','<leader>du','<leader>dg','<leader>dj','<leader>dJ','<F5>','<F10>','<F11>','<F12>','<C-\>','<leader>t1','<leader>t4','<leader>tf','<leader>ta','<leader>ts']
        call assert_false(empty(maparg(s:key, 'n')), 'Missing shortcut: ' . s:key)
endfor
call mkdir(g:vim_config_state . '/project/src', 'p')
call writefile(['module smoke'], g:vim_config_state . '/project/go.mod')
execute 'edit ' . fnameescape(g:vim_config_state . '/project/src/main.go')
setfiletype go
call assert_equal(0, &expandtab)
call assert_equal(8, &shiftwidth)
call assert_equal(g:vim_config_state . '/project', vimconfig#root(['go.mod']))
call assert_equal(4,len(VimConfigTaskSpecs()))
execute 'edit ' . fnameescape(g:vim_config_state . '/project/src/main.cpp')
setfiletype cpp
call assert_equal(1,&expandtab)
call setline(1, ['int main() { return 0; }'])
call VimConfigAutosave()
call assert_true(filereadable(expand('%:p')))
call writefile(['42'], expand('%:p:h') . '/input.txt')
call assert_equal(expand('%:p:h') . '/input.txt', vimconfig#input())
call assert_equal(2,len(VimConfigTaskSpecs()))
call assert_match('input.txt',VimConfigTaskSpecs()[0].cmd)
call assert_equal("'a' 'b c' 'x'\\''y'", vimconfig#shell(['a','b c',"x'y"]))
let s:source = expand('%:p')
" Async success/failure and quickfix parsing; no compilers or downloads required.
call VimConfigTaskStart({'name':'smoke success','cmd':'printf "main.cpp:1:1: error: sample\\n"','cwd':expand('%:p:h')}, '')
let s:deadline = reltime()
while reltimefloat(reltime(s:deadline)) < 2 && get(getqflist({'title':0}), 'title', '') !~# 'exit '
        sleep 10m
endwhile
call assert_match('exit 0',getqflist({'title':0}).title)
call assert_equal(1,len(getqflist()))
call assert_equal(resolve(s:source),resolve(fnamemodify(bufname(getqflist()[0].bufnr), ':p')))
call VimConfigTaskStart({'name':'smoke failure','cmd':'exit 7','cwd':getcwd()}, '')
let s:deadline = reltime()
while reltimefloat(reltime(s:deadline)) < 2 && get(getqflist({'title':0}), 'title', '') !~# 'exit '
        sleep 10m
endwhile
call assert_match('exit 7',getqflist({'title':0}).title)

" Native terminals retain their job/buffer when hidden and reopen the same shell.
cclose
call VimConfigTerminal(1)
let s:term = bufnr('%')
call assert_equal('terminal', &buftype)
call VimConfigTerminal(1)
call assert_true(bufexists(s:term))
call assert_equal(-1,bufwinid(s:term))
call VimConfigTerminal(1)
call assert_equal(s:term,bufnr('%'))
call job_stop(term_getjob(s:term))
sleep 30m
" Formatter success and failure preserve cursor and avoid replacing text on error.
call mkdir(g:vim_config_state . '/bin','p')
call writefile(['#!/bin/sh','cat >/dev/null','printf "formatted\n"'],g:vim_config_state . '/bin/stylua')
call setfperm(g:vim_config_state . '/bin/stylua','rwx------')
let s:path = $PATH
let $PATH = g:vim_config_state . '/bin:' . $PATH
enew
setfiletype lua
call setline(1,['original','second'])
call VimConfigFormat()
call assert_equal(['formatted'],getline(1,'$'))
call writefile(['#!/bin/sh','cat >/dev/null','printf "bad"','exit 1'],g:vim_config_state . '/bin/stylua')
call setline(1,['keep me'])
call VimConfigFormat()
call assert_equal(['keep me'],getline(1,'$'))
let $PATH = s:path
" Exercise the actual VimEnter hook, which -S smoke startup otherwise skips.
enew!
let g:vim_config_no_dashboard = 0
doautocmd <nomodeline> VimEnter
call assert_equal('nofile', &buftype)
call assert_match('V I M', getline(2))
call assert_equal(0, &modifiable)
let g:vim_config_no_dashboard = 1
doautocmd <nomodeline> VimEnter
if !empty(v:errors)
        call writefile(v:errors, g:vim_config_state . '/validation-errors')
        cquit
endif
qa!
