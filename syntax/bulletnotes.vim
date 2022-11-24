" Settings
"setlocal conceallevel=3

syn spell toplevel

" Title

syntax region NoteTitle matchgroup=TitleEnd start='^## \+' end=' \+##$' oneline concealends contains=Tag
syntax region Subtitle matchgroup=SubtitleEnd start='^:: \+' end=' \+::$' oneline concealends contains=Tag
syntax region ContactTitle matchgroup=ContactTitleEnd start='^@@ \+' end=' \+@@$' oneline concealends

" hi link NoteTitle Title
hi NoteTitle cterm=bold,underline ctermfg=135
hi Subtitle cterm=underline ctermfg=140
hi ContactTitle cterm=underline ctermfg=51

hi link TitleEnd NoteTitle
hi link SubtitleEnd Subtitle
hi link ContactTitleEnd ContactTitle

" Leading Whitespace (for consistent multi-line highlighting)

syntax match LeadingWhitespace /^\s\+/ contained

highlight LeadingWhitespace cterm=none

" Note Bullets

syntax match NoteBullet /^\(\s\{4\}\)*-/

highlight NoteBullet ctermfg=220 cterm=bold

" Task Bullets

syntax match TaskBullet /^\(\s\{4\}\)*\*/ contained
syntax region Task start=/^\(\s\{4\}\)*\*\s\+/hs=e+1 end=/^\s*$\|^\(\s\{4\}\)*[-*+?<>#]/me=s-1 contains=TaskBullet,LeadingWhitespace,@Metatext

highlight TaskBullet ctermfg=70 cterm=bold
highlight Task ctermfg=84

" Processed Tasks

syntax match ProcessedTaskBullet /^\(\s\{4\}\)*+/ contained
syntax region ProcessedTask start=/^\(\s\{4\}\)*+\s\+/hs=e+1 end=/^\s*$\|^\(\s\{4\}\)*[-*+?<>#]/me=s-1 contains=ProcessedTaskBullet,LeadingWhitespace,@Metatext

"highlight ProcessedTaskBullet ctermfg=25 cterm=bold
highlight ProcessedTaskBullet ctermfg=70 cterm=bold
highlight ProcessedTask ctermfg=243

" Question Bullets

syntax match QuestionBullet /^\(\s\{4\}\)*?/ contained
syntax region Question start=/^\(\s\{4\}\)*?\s\+/hs=e+1 end=/^\s*$\|^\(\s\{4\}\)*[-*+?<>#]/me=s-1 contains=QuestionBullet,LeadingWhitespace,@Metatext

highlight QuestionBullet ctermfg=196 cterm=bold
highlight Question ctermfg=214

" Answered Question Bullets

syntax match AnsweredQuestionBullet /^\(\s\{4\}\)*</ contained
syntax region AnsweredQuestion start=/^\(\s\{4\}\)*<\s\+/hs=e+1 end=/^\s*$\|^\(\s\{4\}\)*[-*+?<>#]/me=s-1 contains=AnsweredQuestionBullet,LeadingWhitespace,@Metatext

"highlight AnsweredQuestionBullet ctermfg=25 cterm=bold
highlight AnsweredQuestionBullet ctermfg=196 cterm=bold
highlight AnsweredQuestion cterm=bold,italic

" Answer Bullets
syntax match AnswerBullet /^\(\s\{4\}\)*>/ contained
syntax region Answer start=/^\(\s\{4\}\)*>\s\+/hs=e+1 end=/^\s*$\|^\(\s\{4\}\)*[-*+?<>#]/me=s-1 contains=AnswerBullet,LeadingWhitespace,@Metatext

highlight AnswerBullet ctermfg=70 cterm=bold
highlight Answer cterm=bold

" Comment Bullets
syntax match CommentBullet /^\(\s\{4\}\)*#/ contained
syntax region CommentItem start=/^\(\s\{4\}\)*#\s\+/hs=e+1 end=/^\s*$\|^\(\s\{4\}\)*[-*+?<>#]/me=s-1 contains=CommentBullet,LeadingWhitespace,@Metatext

highlight CommentBullet ctermfg=39 cterm=bold
highlight CommentItem ctermfg=117 ctermbg=235 cterm=italic

" Metatext (annotations to text that add meaning, e.g. tags)

let pointerRegexp = bulletnotes#BuildPointerRegexp()

syntax match Tag /#[a-zA-Z0-9_\-]\+/ contains=@NoSpell

exec 'syntax match Link /'.pointerRegexp.'/ contains=@NoSpell,LinkEnds'
syntax match LinkEnds /\[[\[:]\?\|[:\]]\?\]/ contained conceal
" syntax match Pointer /&[a-zA-Z0-9_\-.]\+\(\/[a-zA-Z0-9_\-.]\+\)*/ contains=@NoSpell,PointerMarker
" syntax match PointerMarker /&/ contained
" syntax match AnchorPointer /&:[a-zA-Z0-9]\+/ contains=@NoSpell,AnchorPointerMarker
" syntax match AnchorPointerMarker /&:/ contained
" syntax match Link /\(^\|\s\)\[[^\]]\+\]\(\s\|$\)/ contains=@NoSpell,LinkEnds keepend
" syntax match LinkEnds /\(\[\|\]\)/ contained
syntax match Contact /@[a-zA-Z\-._]\+/ contains=@NoSpell,ContactMarker
syntax match Anchor /:[a-zA-Z0-9]\+:/ contains=@NoSpell,AnchorMarker
syntax match AnchorMarker /:/ contained
syntax match ContactMarker /@/ contained conceal

syntax region Monospace matchgroup=MonospaceEnd start='\\\@1<!{' skip='\\.' end='}' keepend concealends contains=@NoSpell,Escaped
syntax region HighlightedMonospace matchgroup=HighlightedMonospaceEnd start='\\\@1<!{{' skip='\\.' end='}}' keepend concealends contains=@NoSpell,Escaped
syntax region Highlight matchgroup=HighlightMark start='`' skip='\\.' end='`' concealends contains=@Metatext,Escape keepend
" syntax cluster Metatext contains=Anchor,AnchorPointer,Contact,Link,Monospace,Pointer,Tag
syntax cluster Metatext contains=Anchor,Contact,Highlight,HighlightedMonospace,Link,Monospace,Tag

" A hack to hide escape sequences
syntax region Escaped matchgroup=Special start='\\' end='.\zs' keepend concealends contained contains=NONE transparent

" Nested Syntax Highlighting

let main_syntax = 'bulletnotes'
let b:current_syntax = 'bulletnotes'

syntax include @go syntax/go.vim
syntax cluster go add=@NoSpell
syntax region GoCode matchgroup=MonospaceEnd start='^{{{go$' end='^}}}$' keepend contains=@go

syntax include @js syntax/javascript.vim
syntax cluster js add=@NoSpell
syntax region JsCode matchgroup=MonospaceEnd start='^{{{js$' end='^}}}$' keepend contains=@js

sign define Foobar linehl=CodeBlock

hi CodeBlock ctermbg=234

" Highlighting Definitions

highlight Tag ctermfg=226 cterm=bold
" highlight Pointer ctermfg=40
" highlight link PointerMarker Pointer
" highlight Link ctermfg=42
highlight Link ctermfg=40
highlight LinkEnds ctermfg=23
" highlight link LinkEnds Link
highlight Contact cterm=bold ctermfg=39
highlight link ContactMarker Contact
highlight link Monospace constant
highlight MonospaceEnd ctermfg=88
highlight HighlightedMonospaceEnd ctermfg=124 cterm=bold
" highlight link HighlightedMonospace Monospace
highlight HighlightedMonospace cterm=bold,underline ctermfg=196

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

highlight Highlight ctermfg=51 cterm=bold
highlight HighlightMark ctermfg=33
