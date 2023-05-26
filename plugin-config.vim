" CtrlP config
let g:ctrlp_working_path_mode = 0 " Always work from current working directory
let g:ctrlp_use_caching = 1
let g:ctrlp_clear_cache_on_exit = 1
let g:ctrlp_map = '<leader>o'
let g:ctrlp_switch_buffer = ''
let g:ctrlp_custom_ignore = '\.pdf$'

highlight CtrlPBufferHid ctermfg=123
highlight CtrlPBufferPath ctermfg=15
highlight CtrlPPrtBase ctermfg=32

nmap <silent> <leader>b <Cmd>CtrlPBuffer<CR>

" Airline

let g:airline_theme='dracula'
let g:airline_skip_empty_sections = 1

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_tab_count = 0
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#obsession#enabled = 1
let g:airline#extensions#obsession#indicator_text = '§'
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
" Truncate branch names with slashes (e.g. 'foo/bar' -> 'f/bar')
let g:airline#extensions#branch#format = 2

fun s:CheckResize()
    if !exists('w:width')
        let w:width = winwidth(0)
    endif

    let l:width = winwidth(0)

    if l:width != w:width
        let w:width = l:width
        AirlineRefresh
    endif
endfun

au CursorHold * call <SID>CheckResize()

let g:airline#extensions#default#section_truncate_width = {
    \ 'c': 0,
    \ 'b': 79,
    \ 'x': 100,
    \ 'y': 80,
    \ 'z': 45,
    \ 'warning': 80,
    \ 'error': 80,
    \ }

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

let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''

call airline#parts#define_function('dictation', 'dictate#GetStatusText')

fun! AirlineFixFfenc(ffenc)
    if a:ffenc == ''
        return ''
    endif

    let l:ffenc = &fileencoding == '' ? &encoding.a:ffenc : a:ffenc

    if l:ffenc == g:airline#parts#ffenc#skip_expected_string
        return ''
    endif

    return l:ffenc
endfun

let g:airline_section_b = '%{airline#util#wrap(airline#extensions#branch#get_head(),0)}'
" TODO: raise this as an issue, and when it gets fixed, replace this line
let g:airline_section_y = '%{airline#util#prepend(AirlineFixFfenc(airline#parts#ffenc()),0)}%{airline#util#wrap(dictate#GetStatusText(),0)}'
let g:airline_section_z = '%#__accent_bold#%{airline#util#wrap(airline#extensions#obsession#get_status(),0)}%2l/%L:%02v%#__restore__#'

" bullets.vim
let g:bullets_enabled_file_types = ['markdown', 'text', 'asciidoctor']
let g:bullets_set_mappings = 1
let g:bullets_enable_in_empty_buffers = 0
let g:bullets_outline_levels = ['std-']
" Prevent bullets from breaking my dictation shortcut
let g:bullets_custom_mappings = [['imap', '<C-d>', '<Cmd>call dictate#Start()<CR>']]

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
            " Workaround for NERDTree bug
            exec "NERDTreeFind" bufname()
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
nmap <silent> <leader>u <Cmd>UndotreeToggle<CR>

" tsuquyomi
let g:tsuquyomi_single_quote_import = 1

" UtiliSnips
let g:UltiSnipsExpandTrigger = "<c-l>"
let g:UltiSnipsJumpForwardTrigger = "<c-l>"
let g:UltiSnipsSnippetsDir = $HOME."/.vim/snips/"
let g:UltiSnipsSnippetDirectories = ["snips"]
let g:UltiSnipsEditSplit = "vertical"

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
let g:html_font = 'JetBrains Mono'

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
let g:go_gopls_complete_unimported = 1
let g:go_gopls_deep_completion = 0
let g:go_rename_command = 'gopls'
let g:go_fmt_command='gopls'
let g:go_gopls_gofumpt=1

autocmd FileType go let b:go_fmt_options = {
        \ 'goimports': '-local ' .
            \ trim(system('{cd '. shellescape(expand('%:h')) .' && go list -m;}')),
    \ }


" vim-go-syntax

let g:go_highlight_dot = 'guifg=#FFA540 cterm=bold'
let g:go_highlight_comma = 'Operator'
let g:go_highlight_semicolon = 'Operator'
let g:go_highlight_function_parens = 'FunctionParens'
let g:go_highlight_slice_brackets = 'SpecialChar'
let g:go_highlight_map_brackets = 'SpecialChar'
let g:go_highlight_function_calls = 'FunctionCall'
let g:go_highlight_function_parameters = 0
let g:go_highlight_fields = 1
let g:go_highlight_struct_fields = 1
let g:go_highlight_builtins = 'FunctionBuiltin'

" vim-gitgutter
let g:gitgutter_set_sign_backgrounds = 0

map <leader>gN <Cmd>GitGutterPrevHunk<CR>zz
map <leader>gn <Cmd>GitGutterNextHunk<CR>zz
map <leader>ga <Cmd>GitGutterStageHunk<CR>
map <leader>gp <Cmd>GitGutterPreviewHunk<CR>

" jedi-vim
let g:jedi#popup_on_dot = 0
let g:jedi#case_insensitive_completion = 0

let g:jedi#goto_definitions_command = '<leader>tt'
let g:jedi#goto_command = "<leader>td"
let g:jedi#documentation_command = "<leader>tD"
let g:jedi#usages_command = "<leader>tr"
let g:jedi#rename_command_keep_name = '<leader>tR'
let g:jedi#rename_command = ""
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

let g:ale_virtualtext_cursor = 0
let g:ale_python_black_use_global = 1

let g:ale_fixers = {
    \    'python': ['black'],
    \    'go': ['gofmt', 'gofumpt', 'goimports', 'golines'],
    \    'javascript': ['eslint'],
    \}

let g:ale_hover_cursor = 0

" Disable linting in insert mode
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_insert_leave = 0
let g:ale_linters_ignore = {'go': ['golint']}

" It seems ALE breaks the location list - use quickfix instead
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1

nmap <leader>al <Plug>(ale_lint)
nmap <leader>at <Plug>(ale_toggle)
nmap <leader>aT <Plug>(ale_toggle_buffer)
nmap <leader>af <Plug>(ale_fix)
nmap <leader>ae <Plug>(ale_next_wrap)zz
nmap <leader>aE <Plug>(ale_previous_wrap)zz
nmap <leader>ar <Plug>(ale_reset)

" fzf-vim

nmap <leader>f <Cmd>Tags<CR>
nmap <leader>F <Cmd>BTags<CR>

" gutentags

let g:gutentags_ctags_exclude = ['.*/*', '*/.*', '*.patch', '*.css', '*.json', 'vendor', 'static']
let g:gutentags_define_advanced_commands = 1

" vim-markdown

let g:vim_markdown_new_list_item_indent = 2
let g:vim_markdown_conceal = 0

" tsuquyomi

let g:tsuquyomi_disable_quickfix = 1

" vim-chatgpt

let g:vim_chatgpt_system_prompt = "You are a professional assistant to a software developer. Do not provide explanations or examples unless you are asked to. Always provide answers using correct Markdown syntax."

" copilot.vim

imap <C-Left> <Plug>(copilot-next)
imap <C-Right> <Plug>(copilot-previous)
imap <C-Down> <Plug>(copilot-dismiss)
imap <script><silent><nowait><expr> <S-Tab> copilot#Accept()

" Disable default tab mapping
let g:copilot_no_tab_map = 1

let g:copilot_filetypes = {
        \'*': 0,
        \'bash': 1,
        \'cpp': 1,
        \'css': 1,
        \'dockerfile': 1,
        \'go': 1,
        \'html': 0,
        \'javascript': 1,
        \'json': 0,
        \'lua': 1,
        \'python': 1,
        \'sql': 1,
        \'swift': 1,
        \'typescript': 1,
        \'vim': 1,
        \'xml': 0,
        \'yaml': 0,
    \}
