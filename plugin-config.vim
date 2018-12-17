" CtrlP config
if executable("ag")
    set grepprg=ag\ --nogroup\ --nocolor

    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
    let g:ctrlp_use_caching = 0

    " Ack
    let g:ackprg = 'ag --vimgrep'
endif

highlight CtrlPBufferHid ctermfg=123
highlight CtrlPBufferPath ctermfg=15

inoremap <silent> <C-@> <Esc>:CtrlPBuffer<CR>
nnoremap <silent> <C-@> <Esc>:CtrlPBuffer<CR>

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline#extensions#tabline#show_buffers = 0


" delimitMate
let delimitMate_expand_cr = 1

" tsuquyomi
let g:tsuquyomi_single_quote_import = 1

" UtiliSnips
let g:UltiSnipsExpandTrigger = "<c-y>"
let g:UltiSnipsJumpForwardTrigger = "<Enter>"
let g:UltiSnipsSnippetsDir = "~/.vim/snips/"
let g:UltiSnipsSnippetDirectories = ["snips"]
nmap <leader>ue <Esc>:UltiSnipsEdit<CR>

" Vim's netrw
let g:netrw_ftp_cmd="ftp -p"   " passive mode by default

" Smooth Scroll
noremap <silent> <C-u> :call smooth_scroll#up(&scroll, 5, 1)<CR>
noremap <silent> <C-d> :call smooth_scroll#down(&scroll, 5, 1)<CR>
noremap <silent> <C-b> :call smooth_scroll#up(&scroll*2, 5, 1)<CR>
noremap <silent> <C-f> :call smooth_scroll#down(&scroll*2, 5, 1)<CR>
