"setlocal completeopt+=menu,preview
setlocal completeopt=longest,menuone
inoremap <expr> <Tab> pumvisible() ? '<CR>' : '<Tab>'
inoremap <expr> <Space> pumvisible() ? '<CR>' : '<Space>'
inoremap <expr> <C-z> pumvisible() ? '<C-n>' : '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
highlight TypeScriptDefinitionDescription ctermfg=46
inoremap <buffer> <C-t> : <C-u>echohl TypeScriptDefinitionDescription <bar> echo tsuquyomi#hint() <bar> echohl None<CR>
nnoremap <buffer> <C-t> : <C-u>echohl TypeScriptDefinitionDescription <bar> echo tsuquyomi#hint() <bar> echohl None<CR>
inoremap <buffer> <C-e> <Esc>:TsuRenameSymbol<CR>
nnoremap <buffer> <C-e> <Esc>:TsuRenameSymbol<CR>
nnoremap <buffer> <C-S-d> <Esc>:TsuDefinition<CR>
