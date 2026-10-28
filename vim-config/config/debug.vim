" Vimspector configuration is in memory; project .vimspector.json remains usable.
let g:vimspector_adapters = {
        \ 'local-lldb': {'command': ['lldb-dap']},
        \ 'local-delve': {'command': ['dlv','dap','--listen=127.0.0.1:${unusedLocalPort}'], 'port': '${unusedLocalPort}'} }
if !executable('lldb-dap') && executable('xcrun')
        let s:lldb = trim(system('xcrun -f lldb-dap'))
        if v:shell_error == 0 && executable(s:lldb) | let g:vimspector_adapters['local-lldb'].command = [s:lldb] | endif
endif
function! VimConfigDebugReady() abort
        if !has('python3')
                echoerr 'Vimspector needs Vim +python3. Install a full Vim build (brew install vim). Java jdb still works.'
                return 0
        endif
        if !exists(':VimspectorReset') | echoerr 'Install Vimspector with :PlugInstall, then restart Vim.' | return 0 | endif
        return 1
endfunction
function! VimConfigDebugLaunch(program, cwd, input) abort
        if !VimConfigDebugReady() | return | endif
        let l:launch = {'request':'launch','program':a:program,'cwd':a:cwd,'stopOnEntry':v:false,'args':[]}
        if !empty(a:input)
                let l:launch.stdio = [a:input]
                let l:launch.preRunCommands = ['settings set target.input-path ' . shellescape(a:input)]
        endif
        let g:vimspector_configurations = {'Launch': {'adapter':'local-lldb','configuration':l:launch}}
        call vimspector#LaunchWithSettings({'configuration':'Launch'})
endfunction
function! VimConfigDebugStart() abort
        if !VimConfigDebugReady() | return | endif
        if &filetype ==# 'go'
                call VimConfigDebugGo()
        elseif &filetype ==# 'cpp' || &filetype ==# 'c'
                call VimConfigDebugLaunch(input('Path to executable: ', expand('%:p:r'), 'file'), getcwd(), vimconfig#input())
        else
                call vimspector#Launch()
        endif
endfunction
function! VimConfigDebugGo() abort
        if !VimConfigDebugReady() | return | endif
        let l:dir = expand('%:p:h')
        let g:vimspector_configurations = {}
        for [l:name,l:program,l:mode] in [['Go file',expand('%:p'),'debug'],['Go package',l:dir,'debug'],['Go test file',l:dir,'test'],['Go test package',l:dir,'test']]
                let g:vimspector_configurations[l:name] = {'adapter':'local-delve','configuration':{'request':'launch','mode':l:mode,'program':l:program,'cwd':l:dir}}
        endfor
        call vimspector#LaunchWithSettings({'configuration':'Go file'})
endfunction
function! VimConfigDebugBuild() abort
        if !VimConfigDebugReady() | return | endif
        let l:tasks = filter(VimConfigTaskSpecs(), 'v:val.name ==# "C/C++ build (debug)"')
        if empty(l:tasks) | echoerr 'Build and debug needs a C/C++ source buffer.' | return | endif
        call VimConfigTaskStart(l:tasks[0], function('VimConfigDebugLaunch', [expand('%:p:r'),getcwd(),vimconfig#input()]))
endfunction
function! VimConfigDebugContinue() abort
        if !VimConfigDebugReady() | return | endif
        if exists('g:vimspector_session_windows') && !empty(g:vimspector_session_windows)
                call vimspector#Continue()
        else
                call VimConfigDebugStart()
        endif
endfunction
function! VimConfigDebugUI() abort
        if !VimConfigDebugReady() | return | endif
        let l:tab = get(get(g:, 'vimspector_session_windows', {}), 'tabpage', 0)
        if l:tab > 0 && l:tab <= tabpagenr('$')
                if tabpagenr() == l:tab | tabprevious | else | execute 'tabnext ' . l:tab | endif
        else
                echom 'Start a debug session first.'
        endif
endfunction
function! VimConfigJdb(single) abort
        update
        let l:maven = a:single ? '' : vimconfig#root(['mvnw','pom.xml'])
        let l:gradle = a:single ? '' : vimconfig#root(['gradlew','build.gradle','build.gradle.kts','settings.gradle','settings.gradle.kts'])
        if !empty(l:maven) || !empty(l:gradle)
                let l:root = !empty(l:maven) ? l:maven : l:gradle
                if !empty(l:maven)
                        let l:tool = vimconfig#wrapper(l:root,'mvnw','mvnDebug')
                        let l:launch = (l:tool =~# 'mvnw$' ? "MAVEN_OPTS='-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=8000' " : '') . vimconfig#shell([l:tool,'compile','exec:java'])
                        let l:port = '8000'
                else
                        let l:launch = vimconfig#shell([vimconfig#wrapper(l:root,'gradlew','gradle'),'run','--debug-jvm'])
                        let l:port = '5005'
                endif
                call VimConfigTerminalOpen(['sh','-c',l:launch], l:root, 'Java suspended JVM')
                let l:wait = 'n=0; until nc -z 127.0.0.1 ' . l:port . '; do n=$((n+1)); [ "$n" -ge 100 ] && exit 1; sleep 0.3; done; exec jdb -attach ' . l:port . ' -sourcepath ' . shellescape(l:root . '/src/main/java')
                call VimConfigTerminalOpen(['sh','-c',l:wait], l:root, 'jdb')
        elseif &filetype ==# 'java'
                let l:out = g:vim_config_state . '/java-out'
                let l:cmd = 'mkdir -p ' . shellescape(l:out) . ' && ' . vimconfig#shell(['javac','-g','-d',l:out,expand('%:p')]) . ' && ' . vimconfig#shell(['jdb','-classpath',l:out,vimconfig#java_class()])
                call VimConfigTerminalOpen(['sh','-c',l:cmd], getcwd(), 'jdb')
        else
                echoerr 'Open a Java source file or Maven/Gradle project.'
        endif
endfunction
nnoremap <F5> :call VimConfigDebugContinue()<CR>
nnoremap <F10> :if VimConfigDebugReady() <Bar> call vimspector#StepOver() <Bar> endif<CR>
nnoremap <F11> :if VimConfigDebugReady() <Bar> call vimspector#StepInto() <Bar> endif<CR>
nnoremap <F12> :if VimConfigDebugReady() <Bar> call vimspector#StepOut() <Bar> endif<CR>
nnoremap <leader>db :if VimConfigDebugReady() <Bar> call vimspector#ToggleBreakpoint() <Bar> endif<CR>
nnoremap <leader>dB :if VimConfigDebugReady() <Bar> call vimspector#ToggleBreakpoint({'condition':input('Breakpoint condition: ')}) <Bar> endif<CR>
nnoremap <leader>dc :call VimConfigDebugBuild()<CR>
nnoremap <leader>dg :call VimConfigDebugGo()<CR>
nnoremap <leader>dj :call VimConfigJdb(0)<CR>
nnoremap <leader>dJ :call VimConfigJdb(1)<CR>
nnoremap <leader>dr :VimspectorShowOutput Console<CR>
nnoremap <leader>dl :if VimConfigDebugReady() <Bar> call vimspector#Restart() <Bar> endif<CR>
nnoremap <leader>dq :if VimConfigDebugReady() <Bar> call vimspector#Reset() <Bar> endif<CR>
nnoremap <leader>du :call VimConfigDebugUI()<CR>
