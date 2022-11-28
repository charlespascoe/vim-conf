" CtrlP config
let g:ctrlp_working_path_mode = 0 " Always work from current working directory
let g:ctrlp_use_caching = 1
let g:ctrlp_clear_cache_on_exit = 1
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
let g:ctrlp_map = '<leader>o'
let g:ctrlp_switch_buffer = ''

highlight CtrlPBufferHid ctermfg=123
highlight CtrlPBufferPath ctermfg=15
highlight CtrlPPrtBase ctermfg=32

nmap <silent> <leader>b <Cmd>CtrlPBuffer<CR>

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_tab_count = 0
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#obsession#enabled = 1
let g:airline#extensions#obsession#indicator_text = '∞'

let g:airline_theme_patch_func = 'AirlineThemePatch'

function! AirlineThemePatch(palette)
    for colors in values(a:palette.inactive)
        let colors[2] = 250
    endfor

    let a:palette.normal.airline_c[3] = 235
endfunction

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

" bullets.vim
let g:bullets_enabled_file_types = ['markdown', 'text', 'asciidoctor']
let g:bullets_set_mappings = 1
let g:bullets_enable_in_empty_buffers = 0
let g:bullets_outline_levels = ['std-']

" Bulletnotes

let g:bulletnotes_omnicomplete_trailing_brackets = 0

" delimitMate
let delimitMate_expand_cr = 1

" NERDTree

fun! s:ToggleNERDTree()
    if g:NERDTree.IsOpen()
        NERDTreeClose
    else
        if bufname() == ''
            NERDTreeFocus
        else
            NERDTreeFind
        end

        NERDTreeRefreshRoot
    endif
endfun

nmap <leader>N <Cmd>call <SID>ToggleNERDTree()<CR>
let NERDTreeShowLineNumbers = 1
let NERDTreeWinSize = 48
let NERDTreeChDirMode = 3 " Change tree root to match CWD of tab

" python-syntax
let g:python_highlight_all = 1
let g:python_highlight_space_errors = 0

" Undotree
nmap <silent> <leader>ut <Cmd>UndotreeToggle<CR>

" tsuquyomi
let g:tsuquyomi_single_quote_import = 1

" UtiliSnips
let g:UltiSnipsExpandTrigger = "<c-l>"
let g:UltiSnipsJumpForwardTrigger = "<c-l>"
let g:UltiSnipsSnippetsDir = $HOME."/.vim/snips/"
let g:UltiSnipsSnippetDirectories = ["snips"]
nmap <leader>ue <Cmd>UltiSnipsEdit<CR>

fun! VisualExpandSnippet(type = '')
    if a:type == ''
        set opfunc=VisualExpandSnippet
        return 'g@'
    endif

    if a:type == 'char'
        call feedkeys("`[v`]\<C-l>")
    elseif a:type == 'line'
        call feedkeys("'[V']\<C-l>")
    else
        echom "Unknown type: ".a:type
    endif
endfun

" Vim's netrw
let g:netrw_ftp_cmd="ftp -p"   " passive mode by default

" Vim's TOhtml

let g:html_pre_wrap = 1 " Ensures the content can wrap

" vim-exchange
let g:exchange_indent = 1

" vim-sort-motion
let g:sort_motion_flags = "i"

" vim-sleuth
let g:sleuth_markdown_heuristics = 0

" vim-go
let g:go_addtags_transform = 'camelcase'
let g:go_template_use_pkg = 1
let g:go_def_mapping_enabled = 0
let g:go_imports_autosave = 0
" Formatting interfers with jumps and folds; just do it manually
let g:go_fmt_autosave = 0
let g:go_gopls_matcher = 'caseSensitive'
let g:go_gopls_complete_unimported = 0
let g:go_gopls_deep_completion = 0
let g:go_rename_command = 'gopls'

" vim-go-syntax

let g:go_highlight_parens = 'Parens'
let g:go_highlight_dot = 'ctermfg=208 cterm=bold'
let g:go_highlight_function_parens = 'Operator'
let g:go_highlight_slice_brackets = 'SpecialChar'
let g:go_highlight_map_brackets = 'SpecialChar'
let g:go_highlight_function_calls = 'FunctionCall'
let g:go_highlight_function_parameters = 0
let g:go_highlight_fields = 1

" vim-gitgutter
let g:gitgutter_set_sign_backgrounds = 0

map <leader>gn <Esc>:GitGutterNextHunk<CR>


" jedi-vim
let g:jedi#popup_on_dot = 0
let g:jedi#case_insensitive_completion = 0

let g:jedi#goto_definitions_command = '<leader>tt'
let g:jedi#goto_command = "<leader>td"
let g:jedi#documentation_command = "<leader>tD"
let g:jedi#usages_command = "<leader>tr"
let g:jedi#rename_command = "<leader>tR"
let g:jedi#completions_command = ""


" Vim's JSON syntax
let g:vim_json_conceal = 0

" Line spread plugin

let g:line_spread_append_last = 1


" vim-easy-align

nmap ga <Plug>(EasyAlign)
nmap gA <Plug>(LiveEasyAlign)


" vim-duplicate

nmap <expr> gD duplicate#with("gc")
nmap <expr> gDD duplicate#with("gc", #{oneline: 1})
nmap <expr> yd duplicate#with("ys")
nmap <expr> ydd duplicate#with("ys", #{oneline: 1})

" vim-serenade

let g:serenade_autostart = 0

" indent-marker
let g:indent_marker_ignore_filetypes = ['rfc', 'help']

" ale

let g:ale_python_black_use_global = 1

let g:ale_fixers = {'python': ['black']}

let g:ale_hover_cursor = 0

" Disable linting in insert mode
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_insert_leave = 0

let g:ale_pattern_options = {
            \ '.*\.go$': #{ale_enabled: 0},
            \}

" fzf-vim

nmap <leader>f <Cmd>Tags<CR>

" gutentags

let g:gutentags_ctags_exclude = ['.*/*', '*/.*', '*.patch', '*.css', '*.json', 'vendor']
