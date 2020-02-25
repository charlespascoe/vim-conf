setlocal spell
setlocal wrap
setlocal textwidth=80

imap <expr> <buffer> <Tab> ShouldIndentBullet() ? '<Esc>>>^i<Right><Right>' : '<Tab>'
imap <expr> <buffer> <S-Tab> ShouldIndentBullet() ? '<Esc><<^i<Right><Right>' : '<Tab>'

let g:markdown_fenced_languages = ['js=javascript', 'jsx=javascript']
let g:markdown_minlines = 200

fun! ShouldIndentBullet()
    return strpart(getline('.'), col('.') - 3, 1) == '-'
endfun

" Convert selected text to a link
vmap <buffer> <leader>fl c[<C-r>"](<C-r>")<Left><Esc><Space>fLi)

fun! FormatLinkSlug(type)
    if a:type ==# 'char'
	exec 'normal!' "`[v`]c\<C-r>='#'.join(split(tolower(@\"), '[^a-z0-9]\\+'), '-')\<Enter>"
    else
        echom "FormatLinkSlug: Unhandled type ".a:type
    endif
endfun

nnoremap <buffer> <leader>fL :set operatorfunc=FormatLinkSlug<CR>g@
