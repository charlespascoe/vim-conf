" CtrlP config
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
highlight CtrlPBufferHid ctermfg=123
highlight CtrlPBufferPath ctermfg=15

inoremap <silent> <C-@> <Esc>:CtrlPBuffer<CR>
nnoremap <silent> <C-@> <Esc>:CtrlPBuffer<CR>

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline#extensions#tabline#show_buffers = 0

" Ack
let g:ackprg = 'ag --vimgrep'

" delimitMate
let delimitMate_expand_cr = 1

" tsuquyomi
let g:tsuquyomi_single_quote_import = 1
