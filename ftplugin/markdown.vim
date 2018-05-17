setlocal spell
setlocal wrap
syntax region inlineCode start="`" end="`"
highlight def link inlineCode String

imap <expr> <Tab> ShouldIndentBullet() ? '<Esc>>>i<Right><Right>' : '<Tab>'
imap <expr> <S-Tab> ShouldIndentBullet() ? '<Esc><<i<Right><Right>' : '<Tab>'

fun! ShouldIndentBullet()
   return strpart(getline('.'), col('.') - 3, 1) == '-'
endfun
