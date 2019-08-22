syntax match leadingWhitespace /^\s\+/ contained
syntax match noteBullet /^\(\s\{4\}\)*-/
syntax match taskBullet /^\(\s\{4\}\)*\*/ contained
syntax match processedTaskBullet /^\(\s\{4\}\)*\./ contained

syntax region task start=/^\(\s\{4\}\)*\*\s\+/hs=e+1 end=/^\s*$\|^\(\s\{4\}\)*[-*.]/me=s-1 contains=taskBullet,leadingWhitespace
syntax region processedTask start=/^\(\s\{4\}\)*\.\s\+/hs=e+1 end=/^\s*$\|^\(\s\{4\}\)*[-*.]/me=s-1 contains=processedTaskBullet,leadingWhitespace

highlight leadingWhitespace cterm=none

highlight noteBullet ctermfg=220 cterm=bold

"highlight taskBullet ctermfg=46 cterm=bold
highlight taskBullet ctermfg=196 cterm=bold
highlight task ctermfg=208

highlight processedTask ctermfg=243 cterm=italic
highlight processedTaskBullet ctermfg=25 cterm=bold
