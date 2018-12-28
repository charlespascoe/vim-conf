setlocal spell
setlocal wrap


imap <expr> <buffer> <Tab> ShouldIndentBullet() ? '<Esc>>>^i<Right><Right>' : '<Tab>'
imap <expr> <buffer> <S-Tab> ShouldIndentBullet() ? '<Esc><<^i<Right><Right>' : '<Tab>'

fun! ShouldIndentBullet()
   return strpart(getline('.'), col('.') - 3, 1) == '-'
endfun
