" CoC supplies completion, snippets, diagnostics and the language clients.
" Keep native insertion usable before plugin installation.
inoremap <silent><expr> <Tab> exists('*coc#pum#visible') && coc#pum#visible() ? coc#pum#confirm() : exists('*coc#expandableOrJumpable') && coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" : "\<Tab>"
inoremap <silent><expr> <S-Tab> exists('*coc#pum#visible') && coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <CR> exists('*coc#pum#visible') && coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>" . (exists('*AutoPairsReturn') ? "\<C-r>=AutoPairsReturn()\<CR>" : '')
inoremap <silent><expr> <C-Space> exists('*coc#pum#visible') && coc#pum#visible() ? coc#pum#cancel() : exists('*coc#refresh') ? coc#refresh() : ''
inoremap <silent><expr> <C-@> exists('*coc#pum#visible') && coc#pum#visible() ? coc#pum#cancel() : exists('*coc#refresh') ? coc#refresh() : ''
inoremap <silent><expr> <C-e> exists('*coc#pum#visible') && coc#pum#visible() ? coc#pum#cancel() : "\<C-e>"
inoremap <silent><expr> <C-n> exists('*coc#pum#visible') && coc#pum#visible() ? coc#pum#next(1) : "\<C-n>"
inoremap <silent><expr> <C-p> exists('*coc#pum#visible') && coc#pum#visible() ? coc#pum#prev(1) : "\<C-p>"
let g:coc_snippet_next = '<tab>'
let g:coc_snippet_prev = '<s-tab>'
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gD <Plug>(coc-declaration)
nmap <silent> grr <Plug>(coc-references)
nmap <silent> grn <Plug>(coc-rename)
nmap <silent> gra <Plug>(coc-codeaction-cursor)
nmap <silent> gri <Plug>(coc-implementation)
nmap <silent> <leader>rn <Plug>(coc-rename)
nmap <silent> <leader>ca <Plug>(coc-codeaction-cursor)
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)
nnoremap <silent> K :call CocActionAsync('doHover')<CR>
nnoremap <silent> <leader>ld :call CocActionAsync('diagnosticInfo')<CR>
nnoremap <silent> gO :CocList outline<CR>
