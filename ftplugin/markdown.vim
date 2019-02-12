setlocal spell
setlocal wrap


imap <expr> <buffer> <Tab> ShouldIndentBullet() ? '<Esc>>>^i<Right><Right>' : '<Tab>'
imap <expr> <buffer> <S-Tab> ShouldIndentBullet() ? '<Esc><<^i<Right><Right>' : '<Tab>'

" Convert selected text to a link
vmap <buffer> l c[<C-r>"]()<Left>

fun! ShouldIndentBullet()
   return strpart(getline('.'), col('.') - 3, 1) == '-'
endfun
