" Title

syntax match NoteTitle /^::.*::/ contains=Tag

highlight link NoteTitle Title

" Leading Whitespace (for consistent multi-line highlighting)

syntax match LeadingWhitespace /^\s\+/ contained

highlight LeadingWhitespace cterm=none

" Important Words (defined in vimscript)
highlight Important cterm=bold

" Note Bullets

syntax match NoteBullet /^\(\s\{4\}\)*-/

highlight NoteBullet ctermfg=220 cterm=bold

" Task Bullets

syntax match TaskBullet /^\(\s\{4\}\)*\*/ contained
syntax region Task start=/^\(\s\{4\}\)*\*\s\+/hs=e+1 end=/^\s*$\|^\(\s\{4\}\)*[-*.]/me=s-1 contains=TaskBullet,LeadingWhitespace,@Metatext

highlight TaskBullet ctermfg=196 cterm=bold
highlight Task ctermfg=214

" Processed Task Bullets

syntax match ProcessedTaskBullet /^\(\s\{4\}\)*\./ contained
syntax region ProcessedTask start=/^\(\s\{4\}\)*\.\s\+/hs=e+1 end=/^\s*$\|^\(\s\{4\}\)*[-*.]/me=s-1 contains=ProcessedTaskBullet,LeadingWhitespace,@Metatext

highlight ProcessedTask ctermfg=243 cterm=italic
highlight ProcessedTaskBullet ctermfg=25 cterm=bold

" Metatext (annotations to text that add meaning, e.g. tags)

syntax match Tag /#[a-zA-Z0-9_\-]\+/
syntax match Reference /&[a-zA-Z0-9_\-.]\+\(\/[a-zA-Z0-9_\-.]\+\)*/
syntax match NotePointer /@[a-zA-Z0-9_\-.]\+\(\/[a-zA-Z0-9_\-.]\+\)*/
syntax cluster Metatext contains=Tag,Reference,NotePointer,Important

highlight Tag ctermfg=226 cterm=bold
highlight Reference ctermfg=40
highlight NotePointer ctermfg=51
