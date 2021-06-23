" CtrlP config
let g:ctrlp_working_path_mode = 0 " Always work from current working directory
let g:ctrlp_use_caching = 1
let g:ctrlp_clear_cache_on_exit = 1
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
let g:ctrlp_map = '<leader>o'

highlight CtrlPBufferHid ctermfg=123
highlight CtrlPBufferPath ctermfg=15
highlight CtrlPPrtBase ctermfg=32

nmap <silent> <leader>f <Esc>:CtrlPBuffer<CR>

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

" Bulletnotes

let g:bulletnotes_omnicomplete_trailing_brackets = 0

" delimitMate
let delimitMate_expand_cr = 1

" NERDTree
nmap <silent> <leader>n :NERDTreeToggle \| NERDTreeRefreshRoot<CR>
let NERDTreeShowLineNumbers = 1
let NERDTreeWinSize = 48

" Undotree
nmap <silent> <leader>ut <Esc>:UndotreeToggle<CR>

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

" Vim's TOhtml

let g:html_pre_wrap = 1 " Ensures the content can wrap

" vim-sort-motion
let g:sort_motion_flags = "i"

" vim-go
let g:go_addtags_transform = 'camelcase'
let g:go_def_mapping_enabled = 0
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
let g:go_highlight_trailing_whitespace_error = 0
let g:go_highlight_types = 1
let g:go_highlight_variable_assignments = 1
let g:go_highlight_variable_declarations = 1

" vim-gitgutter
let g:gitgutter_set_sign_backgrounds = 0

" Formatting interfers with jumps and folds; just do it manually
let g:go_fmt_autosave = 0

let g:go_gopls_matcher = 'caseSensitive'
let g:go_gopls_complete_unimported = v:false
let g:go_gopls_deep_completion = v:false
let g:go_rename_command = 'gopls'

" indentLine
let g:indentLine_fileType = ['yaml', 'javascript', 'typescript']
let g:indentLine_showFirstIndentLevel = 1
let g:indentLine_char = '│'
let g:indentLine_first_char = '│'
let g:indentLine_color_term = 236
