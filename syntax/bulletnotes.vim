" Settings
setlocal conceallevel=3

" Title

syntax match NoteTitle /^## .* ##/ contains=Tag,TitleEnd
syntax match Subtitle /^:: .* ::/ contains=Tag,SubtitleEnd
syntax match ContactTitle /^@@ .* @@/ contains=ContactTitleEnd

syntax match TitleEnd /\s*##\s*/ conceal contained
syntax match SubtitleEnd /\s*::\s*/ conceal contained
syntax match ContactTitleEnd /\s*@@\s*/ conceal contained

highlight NoteTitle cterm=bold,underline ctermfg=135
highlight Subtitle cterm=underline ctermfg=140
highlight ContactTitle cterm=underline ctermfg=51

highlight link TitleEnd NoteTitle
highlight link SubtitleEnd Subtitle
highlight link ContactTitleEnd ContactTitle

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
syntax region Task start=/^\(\s\{4\}\)*\*\s\+/hs=e+1 end=/^\s*$\|^\(\s\{4\}\)*[-*+?.]/me=s-1 contains=TaskBullet,LeadingWhitespace,@Metatext,@TextStyle

highlight TaskBullet ctermfg=70 cterm=bold
highlight Task ctermfg=84

" Processed Tasks

syntax match ProcessedTaskBullet /^\(\s\{4\}\)*+/ contained
syntax region ProcessedTask start=/^\(\s\{4\}\)*+\s\+/hs=e+1 end=/^\s*$\|^\(\s\{4\}\)*[-*+?.]/me=s-1 contains=ProcessedTaskBullet,LeadingWhitespace,@Metatext,@TextStyle

"highlight ProcessedTaskBullet ctermfg=25 cterm=bold
highlight ProcessedTaskBullet ctermfg=70 cterm=bold
highlight ProcessedTask ctermfg=243

" Question Bullets

syntax match QuestionBullet /^\(\s\{4\}\)*?/ contained
syntax region Question start=/^\(\s\{4\}\)*?\s\+/hs=e+1 end=/^\s*$\|^\(\s\{4\}\)*[-*+?.]/me=s-1 contains=QuestionBullet,LeadingWhitespace,@Metatext,@TextStyle

highlight QuestionBullet ctermfg=196 cterm=bold
highlight Question ctermfg=214

" Answered Question Bullets

syntax match AnsweredQuestionBullet /^\(\s\{4\}\)*\./ contained
syntax region AnsweredQuestion start=/^\(\s\{4\}\)*\.\s\+/hs=e+1 end=/^\s*$\|^\(\s\{4\}\)*[-*+?.]/me=s-1 contains=AnsweredQuestionBullet,LeadingWhitespace,@Metatext,@TextStyle

"highlight AnsweredQuestionBullet ctermfg=25 cterm=bold
highlight AnsweredQuestionBullet ctermfg=196 cterm=bold
highlight AnsweredQuestion ctermfg=243

" Metatext (annotations to text that add meaning, e.g. tags)

syntax match Tag /#[a-zA-Z0-9_\-]\+/ contains=@NoSpell
syntax match Pointer /&[a-zA-Z0-9_\-.:]\+\(\/[a-zA-Z0-9_\-.:]\+\)*/ contains=@NoSpell,PointerMarker
syntax match RefPointer /&ref\/\?[a-zA-Z0-9_\-.:]*\(\/[a-zA-Z0-9_\-.:]\+\)*/ contains=@NoSpell,RefPointerMarker
syntax match PointerMarker /&/ conceal contained
syntax match RefPointerMarker /&/ conceal contained
syntax match Link /\(^\|\s\)\[[^\]]\+\]\(\s\|$\)/ contains=@NoSpell,LinkEnds keepend
syntax match LinkEnds /\(\[\|\]\)/ conceal contained
syntax match Contact /@[a-zA-Z\-._]\+/
syntax cluster Metatext contains=Tag,Pointer,RefPointer,Link,Contact

highlight Tag ctermfg=226 cterm=bold
highlight Pointer ctermfg=39
highlight link PointerMarker Pointer
highlight RefPointer ctermfg=40
highlight link RefPointerMarker RefPointer
highlight Link ctermfg=37
highlight link LinkEnds Link
highlight Contact ctermfg=51

" Contact Fields
syntax match FieldName /[A-Za-z]\+:/ contained
syntax match Field /^- \(Email\|Name\|Role\): .*/ contains=NoteBullet,FieldName,@NoSpell

highlight FieldName ctermfg=39
highlight link Field Link

" Text Styles

syntax region Highlight start='`' end='`' contains=HighlightMark keepend
syntax match HighlightMark /`/ conceal contained
syntax cluster TextStyle contains=Highlight,Important

highlight Highlight ctermfg=50 cterm=bold
highlight link HighlightMark Highlight
