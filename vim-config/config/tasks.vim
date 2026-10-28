" Async task jobs populate quickfix; task context is captured before opening it.
let s:running = 0
let s:job = v:null
let s:lines = []
function! VimConfigTaskSpecs() abort
        let l:f = expand('%:p')
        let l:dir = expand('%:p:h')
        let l:out = expand('%:p:r')
        let l:tasks = []
        if &filetype ==# 'cpp' || &filetype ==# 'c'
                let l:cc = &filetype ==# 'cpp' ? ['g++', '-std=c++23'] : ['cc', '-std=c17']
                let l:build = vimconfig#shell(l:cc + ['-g', '-O0', '-Wall', l:f, '-o', l:out])
                let l:input = vimconfig#input()
                let l:run = shellescape(l:out) . (empty(l:input) ? '' : ' < ' . shellescape(l:input))
                let l:notice = empty(l:input) ? '[no input.txt found; running with no stdin]' : '[stdin: ' . l:input . ']'
                let l:tasks += [{'name':'C/C++ build & run','cmd':l:build . ' && printf "\n%s\n" ' . shellescape(l:notice) . ' && ' . l:run,'cwd':getcwd()}, {'name':'C/C++ build (debug)','cmd':l:build,'cwd':getcwd()}]
        elseif &filetype ==# 'go'
                let l:root = vimconfig#root(['go.mod','.git'])
                if empty(l:root) | let l:root = getcwd() | endif
                let l:tasks += [{'name':'Go run (file)','cmd':vimconfig#shell(['go','run',l:f]),'cwd':getcwd()}, {'name':'Go run (package)','cmd':'go run .','cwd':l:dir}, {'name':'Go test (package)','cmd':'go test -v ./...','cwd':l:root}, {'name':'Go build','cmd':'go build ./...','cwd':l:root}]
        elseif &filetype ==# 'java'
                let l:out = g:vim_config_state . '/java-out'
                let l:cmd = 'mkdir -p ' . shellescape(l:out) . ' && ' . vimconfig#shell(['javac','-d',l:out,l:f]) . ' && ' . vimconfig#shell(['java','-cp',l:out,vimconfig#java_class()])
                let l:tasks += [{'name':'Java run (single file)','cmd':vimconfig#shell(['java',l:f]),'cwd':getcwd()}, {'name':'Java compile & run','cmd':l:cmd,'cwd':getcwd()}]
        endif
        for [l:markers,l:wrapper,l:fallback,l:specs] in [
                \ [['gradlew','build.gradle','build.gradle.kts','settings.gradle','settings.gradle.kts'],'gradlew','gradle',[['Gradle build',['build']],['Gradle run',['run']],['Gradle test',['test']]]],
                \ [['mvnw','pom.xml'],'mvnw','mvn',[['Maven package',['package']],['Maven test',['test']],['Maven run (exec:java)',['compile','exec:java']]]]]
                let l:root = vimconfig#root(l:markers)
                if !empty(l:root)
                        for l:spec in l:specs
                                call add(l:tasks, {'name':l:spec[0], 'cmd':vimconfig#shell([vimconfig#wrapper(l:root,l:wrapper,l:fallback)] + l:spec[1]), 'cwd':l:root})
                        endfor
                endif
        endfor
        return l:tasks
endfunction
function! s:Output(channel, message) abort
        call add(s:lines, a:message)
endfunction
function! s:Done(task, callback, channel) abort
        let l:status = job_info(s:job).exitval
        let s:running = 0
        call setqflist([], 'r', {'title': a:task.name . ' (exit ' . l:status . ')', 'lines': ["Entering directory '" . a:task.cwd . "'"] + s:lines + ["Leaving directory '" . a:task.cwd . "'"], 'efm': "%-DEntering directory '%f',%-XLeaving directory '%f'," . &errorformat})
        call setqflist([], 'r', {'items':filter(getqflist(), {_, item -> item.text !~# "^\\%(Entering\\|Leaving\\) directory '"}), 'title': a:task.name . ' (exit ' . l:status . ')'})
        echom a:task.name . ': exit ' . l:status
        if l:status == 0 && !empty(a:callback) | call call(a:callback, []) | endif
endfunction
function! VimConfigTaskStart(task, callback) abort
        if s:running | echoerr 'A task is running. Use :VimTaskStop first.' | return | endif
        update
        let s:lines = []
        let s:running = 1
        let s:job = job_start(['sh','-c',a:task.cmd], {'cwd':a:task.cwd, 'out_mode':'nl', 'err_io':'out', 'out_cb':function('s:Output'), 'close_cb':function('s:Done',[a:task,a:callback])})
        if job_status(s:job) ==# 'fail' | let s:running = 0 | echoerr 'Could not start task.' | return | endif
        call setqflist([], 'r', {'title': a:task.name, 'items': []})
        botright copen
endfunction
function! VimConfigTaskRun() abort
        let l:tasks = VimConfigTaskSpecs()
        if empty(l:tasks) | echom 'No tasks for this buffer/project.' | return | endif
        let l:n = inputlist(['Run task:'] + map(copy(l:tasks), 'printf("%d. %s", v:key+1, v:val.name)'))
        if l:n > 0 && l:n <= len(l:tasks) | call VimConfigTaskStart(l:tasks[l:n-1], '') | endif
endfunction
function! VimConfigTaskStop() abort
        if s:running | call job_stop(s:job) | endif
endfunction
function! VimConfigQuickfixToggle() abort
        if get(getqflist({'winid':0}), 'winid', 0) | cclose | else | botright copen | endif
endfunction
command! VimTaskRun call VimConfigTaskRun()
command! VimTaskStop call VimConfigTaskStop()
nnoremap <leader>or :VimTaskRun<CR>
nnoremap <leader>ot :call VimConfigQuickfixToggle()<CR>
