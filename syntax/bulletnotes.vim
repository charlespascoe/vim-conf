" Settings
"setlocal conceallevel=3

syn spell toplevel

setlocal iskeyword+=:

" Title

syntax region bnNoteTitle matchgroup=TitleEnd start='^## \+' end=' \+##$' oneline concealends contains=Tag
syntax region Subtitle matchgroup=SubtitleEnd start='^:: \+' end=' \+::$' oneline concealends contains=Tag
syntax region ContactTitle matchgroup=ContactTitleEnd start='^@@ \+' end=' \+@@$' oneline concealends

hi link bnNoteTitle Title
" hi bnNoteTitle cterm=bold,underline ctermfg=135
hi Subtitle cterm=underline ctermfg=140
hi ContactTitle cterm=underline ctermfg=51

hi link TitleEnd bnNoteTitle
hi link SubtitleEnd Subtitle
hi link ContactTitleEnd ContactTitle

" Leading Whitespace (for consistent multi-line highlighting)

syntax match LeadingWhitespace /^\s\+/ contained

highlight LeadingWhitespace cterm=none

if !exists('g:bulletnote_bullets')
    let g:bulletnote_bullets = #{
        \Note: #{
            \char: '-',
            \bhl: 'ctermfg=220 cterm=bold',
        \},
        \Task: #{
            \char: '*',
            \bhl: 'DiffAdd',
            \hl: 'Type',
        \},
        \ProcessedTask: #{
            \char: '+',
            \bhl: 'DiffAdd',
            \hl: 'ctermfg=243 cterm=italic,strikethrough',
        \},
        \Question: #{
            \char: '?',
            \bhl: 'DiffDelete',
            \hl: 'DiffChange',
        \},
        \AnsweredQuestion: #{
            \char: '>',
            \bhl: 'DiffDelete',
            \hl: 'cterm=bold,italic',
        \},
        \Answer: #{
            \char: '<',
            \bhl: 'ctermfg=70 cterm=bold',
            \hl: 'cterm=bold',
        \},
        \Comment: #{
            \char: '#',
            \bhl: 'Special',
            \hl: 'Comment',
        \},
    \}
endif

let bulletset = '\['

for opts in values(g:bulletnote_bullets)
    if opts.char == '-'
        let bulletset .= '\'
    endif
    let bulletset .= opts.char
endfor

let bulletset .= ']'

let indent = '\(\s\{4\}\)\*'

fun s:highlight(name, hl)
    if a:hl =~ '^\w\+$'
        exec 'hi link '..a:name..' '..a:hl
    elseif a:hl != ''
        exec 'hi '..a:name..' '..a:hl
    endif
endfun

for [name, opts] in items(g:bulletnote_bullets)
    exec 'syntax region bn'..name..' matchgroup=bn'..name..'Bullet start=/\V\^'..indent..opts.char..'\s\+/ end=/\V\^\s\*\$\|\^'..indent..bulletset..'/me=s-1 contains=bn'..name..'Bullet,LeadingWhitespace,@bnMetatext,@Spell'
    call s:highlight('bn'..name..'Bullet', get(opts, 'bhl', ''))
    call s:highlight('bn'..name, get(opts, 'hl', ''))
endfor

" bnMetatext (annotations to text that add meaning, e.g. tags)

let pointerRegexp = bulletnotes#BuildPointerRegexp()

syntax match bnTag /#[a-zA-Z0-9_\-]\+/ contains=@NoSpell

exec 'syntax match bnLink /'.pointerRegexp.'/ contains=@NoSpell,bnLinkEnds'
syntax match bnLinkEnds /\[[\[:]\?\|[:\]]\?\]/ contained conceal
syntax match bnContact /@[a-zA-Z\-._]\+/ contains=@NoSpell,bnContactMarker
syntax match bnAnchor /:[a-zA-Z0-9]\+:/ contains=@NoSpell
syntax match bnContactMarker /@/ contained conceal

syntax region Monospace matchgroup=MonospaceEnd start='\\\@1<!{' skip='\\.' end='}' keepend concealends contains=@NoSpell,bnEscaped
syntax region HighlightedMonospace matchgroup=HighlightedMonospaceEnd start='\\\@1<!{{' skip='\\.' end='}}' keepend concealends contains=@NoSpell,bnEscaped
syntax region bnHighlight matchgroup=bnHighlightMark start='`' skip='\\.' end='`' concealends contains=@bnMetatext,bnEscaped keepend
syntax cluster bnMetatext contains=bnAnchor,bnContact,bnHighlight,HighlightedMonospace,bnLink,Monospace,bnTag

" A hack to hide escape sequences
syntax region bnEscaped matchgroup=SpecialChar start='\\' end='.\zs' keepend concealends contained contains=NONE transparent

" Nested Syntax Highlighting

let main_syntax = 'bulletnotes'
let b:current_syntax = 'bulletnotes'

syntax include @go syntax/go.vim
syntax cluster go add=@NoSpell
syntax region bnGoCode matchgroup=MonospaceEnd start='^{{{go$' end='^}}}$' keepend contains=@go

syntax include @js syntax/javascript.vim
syntax cluster js add=@NoSpell
syntax region bnJsCode matchgroup=MonospaceEnd start='^{{{js$' end='^}}}$' keepend contains=@js

" Highlighting Definitions

" highlight Tag ctermfg=226 cterm=bold
" highlight Pointer ctermfg=40
" highlight link PointerMarker Pointer
hi link bnTag Function
hi link bnLink Tag
hi link bnLinkEnds bnLink
" hi bnContact cterm=bold ctermfg=39
hi link bnContact PreProc
hi link bnContactMarker bnContact
hi link Monospace String
" highlight MonospaceEnd ctermfg=88
hi link MonospaceEnd String
hi link HighlightedMonospaceEnd String
hi link HighlightedMonospace String

" highlight bnAnchor ctermfg=0 ctermbg=24
highlight link bnAnchor Conceal
highlight link bnAnchorMarker bnAnchor
highlight link AnchorPointer Pointer
highlight link AnchorPointerMarker AnchorPointer

" Contact Fields
" syntax match bnFieldName /[A-Za-z]\+:/ contained
" syntax match bnField /^- \(Email\|Name\|Role\): .*/ contains=NoteBullet,bnFieldName,@NoSpell

" hi bnFieldName ctermfg=39
" hi link bnField Special

" Text Styles

" highlight bnHighlight ctermfg=51 cterm=bold
" highlight bnHighlightMark ctermfg=33

hi link bnHighlight Todo
hi link bnHighlightMark bnHighlight
