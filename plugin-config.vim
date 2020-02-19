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
highlight CtrlPPrtBase ctermfg=32

inoremap <silent> <C-@> <Esc>:CtrlPBuffer<CR>
nnoremap <silent> <C-@> <Esc>:CtrlPBuffer<CR>

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#obsession#enabled = 1
let g:airline#extensions#obsession#indicator_text = '∞'

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline_section_b = '%{airline#util#wrap(airline#extensions#branch#get_head(),0)}'
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.maxlinenr = ''

" delimitMate
let delimitMate_expand_cr = 1

" NERDTree
nmap <silent> <C-n> :NERDTreeToggle \| NERDTreeRefreshRoot<CR>
let NERDTreeWinSize = 48

" tsuquyomi
let g:tsuquyomi_single_quote_import = 1

" UtiliSnips
let g:UltiSnipsExpandTrigger = "<c-y>"
let g:UltiSnipsJumpForwardTrigger = "<c-y>"
let g:UltiSnipsSnippetsDir = "~/.vim/snips/"
let g:UltiSnipsSnippetDirectories = ["snips"]
nmap <leader>ue <Esc>:UltiSnipsEdit<CR>

" Vim's netrw
let g:netrw_ftp_cmd="ftp -p"   " passive mode by default

" Smooth Scroll
noremap <silent> <C-u> :call smooth_scroll#up(&scroll, 8, 1)<CR>
noremap <silent> <C-d> :call smooth_scroll#down(&scroll, 8, 1)<CR>
noremap <silent> <C-b> :call smooth_scroll#up(&scroll*2, 8, 1)<CR>
noremap <silent> <C-f> :call smooth_scroll#down(&scroll*2, 8, 1)<CR>

" vim-sort-motion
let g:sort_motion_flags = "i"

" vim-go
let g:go_highlight_array_whitespace_error = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_chan_whitespace_error = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_functions = 1
let g:go_highlight_interfaces = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_space_tab_error = 1
let g:go_highlight_string_spellcheck = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1
let g:go_highlight_variable_assignments = 1
let g:go_highlight_variable_declarations = 1
