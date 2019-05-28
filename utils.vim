fun! FindProjectRoot(dir, indicator)
    if isdirectory(a:dir."/".a:indicator) || filereadable(a:dir."/".a:indicator)
        return a:dir
    el
        if a:dir == "/"
            return ""
        el
            return FindProjectRoot(fnamemodify(a:dir, ":h"), a:indicator)
        end
    end
endf

" Auto-Paste Mode

let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

function! XTermPasteBegin()
    set pastetoggle=<Esc>[201~
    set paste
    return ""
endfunction


function! ShowHead()
    let l = line('.')
    Gvsplit HEAD:%
    execute l
    normal zz
endfunction

command! -nargs=1 -complete=help Help tab help <args>

command! ShowHead call ShowHead()

" Syntax highlighting debugging
map <leader>S <Esc>:echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Trim trailing whitespace
command! Trim %s/\s\+$//e

" Jump to mark
nmap <Leader>j `

" TeX Filetype detection
au BufNewFile,BufRead *.tex set filetype=tex

" Jump back to mark centres on cursor
noremap <expr> ` printf('`%czz', getchar())


noremap <leader>R <Esc>:s/<C-r><C-w>//g<Left><Left>

noremap <leader>i `iO

" Comma-separated line spread

fun! CommaSpread(type)
    if a:type ==# 'char'
        " Put the contents of the object on its own line and add trailing comma
        " (NOTE: Relies on plugin to move closing parens/braces to new line)
        exec 'normal' "`[v`]c\<Enter>,\<Esc>P"
        let startLine = line('.')
        " Put each item on its own line
        s/\s*,\s*/,\r/g
        " Delete the extra blank line caused by the trailing comma
        exec 'normal' 'dd'
        let endLine = line('.')

        " Fix indentation of new lines
        let lines = 1 + (endLine - startLine)
        exec startLine
        exec 'normal' '='.lines.'='
    else
        echom "CommaSpread: Unhandled type ".a:type
    endif
endfun

nnoremap gS :set operatorfunc=CommaSpread<CR>g@
