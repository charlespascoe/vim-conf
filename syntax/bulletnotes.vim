" Settings
"setlocal conceallevel=3

" Title

syntax match NoteTitle /^## .* ##/ contains=Tag,TitleEnd
syntax match Subtitle /^:: .* ::/ contains=Tag,SubtitleEnd
syntax match ContactTitle /^@@ .* @@/ contains=ContactTitleEnd

syntax match TitleEnd /\s*##\s*/ contained
syntax match SubtitleEnd /\s*::\s*/ contained
syntax match ContactTitleEnd /\s*@@\s*/ contained

hi link NoteTitle Title
highlight Subtitle cterm=underline ctermfg=140
highlight ContactTitle cterm=underline ctermfg=51

highlight link TitleEnd NoteTitle
highlight link SubtitleEnd Subtitle
highlight link ContactTitleEnd ContactTitle

" Leading Whitespace (for consistent multi-line highlighting)

syntax match LeadingWhitespace /^\s\+/ contained

highlight LeadingWhitespace cterm=none

" Note Bullets

syntax match NoteBullet /^\(\s\{4\}\)*-/

highlight NoteBullet ctermfg=220 cterm=bold

" Task Bullets

syntax match TaskBullet /^\(\s\{4\}\)*\*/ contained
syntax region Task start=/^\(\s\{4\}\)*\*\s\+/hs=e+1 end=/^\s*$\|^\(\s\{4\}\)*[-*+?<>#]/me=s-1 contains=TaskBullet,LeadingWhitespace,@Metatext,@TextStyle

highlight TaskBullet ctermfg=70 cterm=bold
highlight Task ctermfg=84

" Processed Tasks

syntax match ProcessedTaskBullet /^\(\s\{4\}\)*+/ contained
syntax region ProcessedTask start=/^\(\s\{4\}\)*+\s\+/hs=e+1 end=/^\s*$\|^\(\s\{4\}\)*[-*+?<>#]/me=s-1 contains=ProcessedTaskBullet,LeadingWhitespace,@Metatext,@TextStyle

"highlight ProcessedTaskBullet ctermfg=25 cterm=bold
highlight ProcessedTaskBullet ctermfg=70 cterm=bold
highlight ProcessedTask ctermfg=243

" Question Bullets

syntax match QuestionBullet /^\(\s\{4\}\)*?/ contained
syntax region Question start=/^\(\s\{4\}\)*?\s\+/hs=e+1 end=/^\s*$\|^\(\s\{4\}\)*[-*+?<>#]/me=s-1 contains=QuestionBullet,LeadingWhitespace,@Metatext,@TextStyle

highlight QuestionBullet ctermfg=196 cterm=bold
highlight Question ctermfg=214

" Answered Question Bullets

syntax match AnsweredQuestionBullet /^\(\s\{4\}\)*</ contained
syntax region AnsweredQuestion start=/^\(\s\{4\}\)*<\s\+/hs=e+1 end=/^\s*$\|^\(\s\{4\}\)*[-*+?<>#]/me=s-1 contains=AnsweredQuestionBullet,LeadingWhitespace,@Metatext,@TextStyle

"highlight AnsweredQuestionBullet ctermfg=25 cterm=bold
highlight AnsweredQuestionBullet ctermfg=196 cterm=bold
highlight AnsweredQuestion cterm=bold,italic

" Answer Bullets
syntax match AnswerBullet /^\(\s\{4\}\)*>/ contained
syntax region Answer start=/^\(\s\{4\}\)*>\s\+/hs=e+1 end=/^\s*$\|^\(\s\{4\}\)*[-*+?<>#]/me=s-1 contains=AnswerBullet,LeadingWhitespace,@Metatext,@TextStyle

highlight AnswerBullet ctermfg=70 cterm=bold
highlight Answer cterm=bold

" Comment Bullets
syntax match CommentBullet /^\(\s\{4\}\)*#/ contained
syntax region CommentItem start=/^\(\s\{4\}\)*#\s\+/hs=e+1 end=/^\s*$\|^\(\s\{4\}\)*[-*+?<>#]/me=s-1 contains=CommentBullet,LeadingWhitespace,@Metatext,@TextStyle

highlight CommentBullet ctermfg=39 cterm=bold
highlight CommentItem ctermfg=117 ctermbg=235 cterm=italic

" Metatext (annotations to text that add meaning, e.g. tags)

let pointerRegexp = bulletnotes#BuildPointerRegexp()

syntax match Tag /#[a-zA-Z0-9_\-]\+/ contains=@NoSpell

exec 'syntax match Link /'.pointerRegexp.'/ contains=@NoSpell'
" syntax match Pointer /&[a-zA-Z0-9_\-.]\+\(\/[a-zA-Z0-9_\-.]\+\)*/ contains=@NoSpell,PointerMarker
" syntax match PointerMarker /&/ contained
" syntax match AnchorPointer /&:[a-zA-Z0-9]\+/ contains=@NoSpell,AnchorPointerMarker
" syntax match AnchorPointerMarker /&:/ contained
" syntax match Link /\(^\|\s\)\[[^\]]\+\]\(\s\|$\)/ contains=@NoSpell,LinkEnds keepend
" syntax match LinkEnds /\(\[\|\]\)/ contained
syntax match Contact /@[a-zA-Z\-._]\+/ contains=ContactMarker
syntax match Anchor /:[a-zA-Z0-9]\+:/ contains=@NoSpell,AnchorMarker
syntax match AnchorMarker /:/ contained
syntax region Monospace start='{' skip='\\}' end='}' contains=@NoSpell
syntax region HighlightedMonospace start='{{' skip='\\}' end='}}' contains=@NoSpell
" syntax cluster Metatext contains=Tag,Pointer,Link,Contact,Anchor,AnchorPointer,Monospace
syntax cluster Metatext contains=Anchor,Tag,Link,Contact,Monospace,HighlightedMonospace
syntax match ContactMarker /@/ contained

highlight Tag ctermfg=226 cterm=bold
" highlight Pointer ctermfg=40
" highlight link PointerMarker Pointer
" highlight Link ctermfg=42
highlight Link ctermfg=40
" highlight link LinkEnds Link
highlight Contact cterm=bold ctermfg=39
highlight link ContactMarker Contact
highlight link Monospace constant
highlight link HighlightedMonospace Monospace
highlight HighlightedMonospace cterm=bold ctermfg=196

highlight Anchor ctermfg=0 ctermbg=24
highlight link AnchorMarker Anchor
highlight link AnchorPointer Pointer
highlight link AnchorPointerMarker AnchorPointer

" Contact Fields
syntax match FieldName /[A-Za-z]\+:/ contained
syntax match Field /^- \(Email\|Name\|Role\): .*/ contains=NoteBullet,FieldName,@NoSpell

highlight FieldName ctermfg=39
highlight link Field Link

" Text Styles

syntax region Highlight start='`' end='`' contains=HighlightMark keepend
syntax match HighlightMark /`/ contained
" Using a cluster makes it easier to add new styles in future (or add user-defined styles)
syntax cluster TextStyle contains=Highlight

highlight Highlight ctermfg=51 cterm=bold
highlight link HighlightMark Highlight
