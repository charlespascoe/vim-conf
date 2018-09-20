" CtrlP config
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
highlight CtrlPBufferHid ctermfg=123
highlight CtrlPBufferPath ctermfg=15

inoremap <silent> <C-@> <Esc>:CtrlPBuffer<CR>
nnoremap <silent> <C-@> <Esc>:CtrlPBuffer<CR>
