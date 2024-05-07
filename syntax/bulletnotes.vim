" Settings
"setlocal conceallevel=3

syn spell toplevel

setlocal iskeyword+=:

" Title

syntax region bnNoteTitle matchgroup=bnTitleEnd start='^## \+' end=' \+##$' oneline concealends contains=@bnMetatext
syntax region bnSubtitle matchgroup=bnSubtitleEnd start='^:: \+' end=' \+::$' oneline concealends contains=@bnMetatext
syntax region bnContactTitle matchgroup=bnContactTitleEnd start='^@@ \+' end=' \+@@$' oneline concealends

" hi bnNoteTitle cterm=bold,underline ctermfg=135
hi bnSubtitle cterm=underline ctermfg=140
hi bnContactTitle cterm=underline ctermfg=51

" Leading Whitespace (for consistent multi-line highlighting)

syntax match bnLeadingWhitespace /^\s\+/ contained

highlight bnLeadingWhitespace cterm=none

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
            \char: '<',
            \bhl: 'DiffDelete',
            \hl: 'cterm=bold,italic',
        \},
        \Answer: #{
            \char: '>',
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
    exec 'syntax region bn'..name..' matchgroup=bn'..name..'Bullet start=/\V\^'..indent..opts.char..'\s\+/ end=/\V\^\s\*\$\|\^'..indent..bulletset..'/me=s-1 contains=bn'..name..'Bullet,bnLeadingWhitespace,@bnMetatext,@Spell'
    call s:highlight('bn'..name..'Bullet', get(opts, 'bhl', ''))
    call s:highlight('bn'..name, get(opts, 'hl', ''))
endfor

let pointerRegexp = bulletnotes#BuildPointerRegexp()

syntax match bnTag /#[a-zA-Z0-9_\-]\+/ contains=@NoSpell

" TODO: Replace this with a series of bnLink patterns (helps with next group etc.)
exec 'syntax match bnLink /'.pointerRegexp.'/ contains=@NoSpell,bnLinkEnds nextgroup=bnLinkText'
syntax match bnLinkEnds /\[[\[:]\?\|[:\]]\?\]/ contained conceal
" TODO: Replace this with a bnLink range whose start pattern is the entire HTTP
" link pattern then '(', then make ends concealed?
syntax region bnLinkText start='(' end=')' contained concealends
hi link bnLinkText bnLink
syntax match bnContact /@[a-zA-Z\-._]\+/ contains=@NoSpell,bnContactMarker
syntax match bnAnchor /:[a-zA-Z0-9]\+:/ contains=@NoSpell
syntax match bnContactMarker /@/ contained conceal

syntax region bnMonospace matchgroup=bnMonospaceEnd start='\\\@1<!{' skip='\\.' end='}' keepend concealends contains=@NoSpell,bnEscaped
syntax region bnHighlightedMonospace matchgroup=bnHighlightedMonospaceEnd start='\\\@1<!{{' skip='\\.' end='}}' keepend concealends contains=@NoSpell,bnEscaped
syntax region bnHighlight matchgroup=bnHighlightMark start='`' skip='\\.' end='`' concealends contains=@bnMetatext,bnEscaped,@Spell keepend
syntax cluster bnMetatext contains=bnAnchor,bnContact,bnHighlight,bnHighlightedMonospace,bnLink,bnMonospace,bnTag

" A hack to hide escape sequences
syntax region bnEscaped matchgroup=SpecialChar start='\\' end='.\zs' keepend concealends contained contains=NONE transparent

" Nested Syntax Highlighting

let main_syntax = 'bulletnotes'
let b:current_syntax = 'bulletnotes'

syntax region bnCode matchgroup=bnMonospaceEnd start='^{{{$' end='^}}}$' keepend
hi link bnCode bnMonospace

syntax include @go syntax/go.vim
syntax cluster go add=@NoSpell
syntax region bnGoCode matchgroup=bnMonospaceEnd start='^{{{go$' end='^}}}$' keepend contains=@go

syntax include @js syntax/javascript.vim
syntax cluster js add=@NoSpell
syntax region bnJsCode matchgroup=bnMonospaceEnd start='^{{{js$' end='^}}}$' keepend contains=@js

" Highlighting Definitions

hi link bnNoteTitle               Title
hi link bnTitleEnd                bnNoteTitle
hi link bnSubtitleEnd             bnSubtitle
hi link bnContactTitleEnd         bnContactTitle
hi link bnTag                     Function
hi link bnLink                    Tag
hi link bnLinkEnds                bnLink
hi link bnContact                 PreProc
hi link bnContactMarker           bnContact
hi link bnMonospace               String
hi link bnMonospaceEnd            String
hi link bnHighlightedMonospaceEnd String
hi link bnHighlightedMonospace    String
hi link bnAnchor                  Conceal

hi bnHighlight cterm=bold guifg=#E3CB4C guibg=#3D3400
hi link bnHighlightMark bnHighlight
