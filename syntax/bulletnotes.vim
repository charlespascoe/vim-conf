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
syntax region Task start=/^\(\s\{4\}\)*\*\s\+/hs=e+1 end=/^\s*$\|^\(\s\{4\}\)*[-*.]/me=s-1 contains=TaskBullet,LeadingWhitespace,@Metatext,@TextStyle

highlight TaskBullet ctermfg=196 cterm=bold
highlight Task ctermfg=214

" Processed Task Bullets

syntax match ProcessedTaskBullet /^\(\s\{4\}\)*\./ contained
syntax region ProcessedTask start=/^\(\s\{4\}\)*\.\s\+/hs=e+1 end=/^\s*$\|^\(\s\{4\}\)*[-*.]/me=s-1 contains=ProcessedTaskBullet,LeadingWhitespace,@Metatext,@TextStyle

highlight ProcessedTask ctermfg=243 cterm=italic
highlight ProcessedTaskBullet ctermfg=25 cterm=bold

" Metatext (annotations to text that add meaning, e.g. tags)
syntax match Tag /#[a-zA-Z0-9_\-]\+/ contains=@NoSpell
syntax match Pointer /&[a-zA-Z0-9_\-.:]\+\(\/[a-zA-Z0-9_\-.:]\+\)*/ contains=@NoSpell,DateTimeStamp
syntax match RefPointer /&ref\/\?[a-zA-Z0-9_\-.:]*\(\/[a-zA-Z0-9_\-.:]\+\)*/ contains=@NoSpell,DateTimeStamp
syntax cluster Metatext contains=Tag,Pointer,RefPointer

highlight Tag ctermfg=226 cterm=bold
highlight Pointer ctermfg=39
highlight RefPointer ctermfg=40

" Timestamps

syntax match DateComponent /\d\d/ contained
syntax match Date /\d\d\.\d\d\.\d\d/ contained contains=DateComponent
syntax match TimeComponent /\d\d/ contained
syntax match Time /\d\d:\d\d/ contained contains=TimeComponent
syntax match DateTimeStamp /\d\d\.\d\d\.\d\d-\d\d:\d\d/ contained contains=Date,Time

highlight DateComponent ctermfg=49
highlight Date ctermfg=220
highlight TimeComponent ctermfg=40
highlight Time ctermfg=220
highlight DateTimeStamp ctermfg=220

" Text Styles

syntax region Highlight start='`' end='`'
syntax cluster TextStyle contains=Highlight,Important

highlight Highlight ctermfg=50 cterm=bold
