set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif

let colors_name = "custom"

" hi Normal guibg=#1D1B23
hi Normal guifg=#F8F8F2 guibg=#292730
" hi ColorColumn guibg=#1c1c1c
" hi ColorColumn guibg=#28122E
" hi ColorColumn ctermbg=235 guibg=#252733
hi ColorColumn ctermbg=235 guibg=#262431
hi CursorLine ctermfg=235 guibg=#262626 cterm=none
hi CursorLineNr ctermfg=238 guifg=#444444
hi Directory ctermfg=33 guifg=#0087ff
hi ErrorMsg cterm=bold ctermfg=253 ctermbg=124 gui=bold guifg=#dadada guibg=#af0000
hi FoldColumn ctermfg=178 ctermbg=234 guifg=#d7af00 guibg=#1c1c1c
hi Folded ctermfg=178 ctermbg=234 cterm=bold guifg=#d7af00 guibg=#1c1c1c gui=bold
hi IncSearch cterm=reverse gui=reverse
" hi LineNr ctermfg=244 guifg=#808080
hi LineNr guifg=#8C4A9E
hi ModeMsg cterm=bold gui=bold
hi MoreMsg ctermfg=34 guifg=#00af00
" Same as Comment
hi NonText cterm=bold ctermfg=39 gui=bold guifg=#00afff
hi Pmenu ctermfg=255 ctermbg=17 guifg=#eeeeee guibg=#00005f
hi PmenuSel ctermfg=255 ctermbg=21 guifg=#eeeeee guibg=#0000ff
hi Question ctermfg=34 guifg=#00af00
hi Search ctermfg=16 ctermbg=220 guifg=#000000 guibg=#ffd700
hi SpecialKey ctermfg=237 guifg=#3a3a3a
hi StatusLine cterm=bold,reverse gui=bold,reverse
hi StatusLineNC cterm=reverse gui=reverse
hi Title cterm=bold,underline ctermfg=42 gui=bold,underline guifg=#00d787
hi TOhtmlProgress ctermbg=28 guibg=#008700
hi VertSplit cterm=none ctermbg=none ctermfg=255 gui=none guifg=#eeeeee
hi Visual cterm=reverse ctermbg=16 gui=reverse guibg=#000000
hi VisualNOS cterm=bold,underline,underline gui=bold,underline,underline
hi WarningMsg ctermfg=16 ctermbg=214 guifg=#000000 guibg=#ffaf00
hi WildMenu ctermfg=16 ctermbg=220 guifg=#000000 guibg=#ffd700
hi MatchParen cterm=bold ctermbg=240 gui=bold guibg=#585858

" ALTERNATE VARIATION
let alternate = 0

if alternate
    hi Normal guifg=#F8F8F2 guibg=#282A36
    hi ColorColumn ctermbg=235 guibg=#21222C
    hi LineNr guifg=#6272A4
endif

hi clear SignColumn

" Colors for syntax highlighting

hi Comment ctermfg=39 ctermbg=236 cterm=italic guifg=#00afff guibg=#303030

hi Constant ctermfg=196 guifg=#FF2D2D

" hi Identifier cterm=none ctermfg=36 guifg=#00CF9F
" hi Identifier cterm=none ctermfg=36 guifg=#00CF9F
hi Identifier cterm=none guifg=#9DFFAE
" hi Function cterm=italic ctermfg=50 guifg=#14D2D2
" hi Function ctermfg=50 guifg=#14D2D2
" hi Function cterm=bold ctermfg=50 guifg=#00EBEB
" hi Function ctermfg=50 guifg=#00EBEB
hi Function ctermfg=50 guifg=#68FFFF

" Non-standard
hi FunctionParens guifg=#B79523


hi Statement ctermfg=220 guifg=#ffd700
hi Operator ctermfg=208 guifg=#FF7700

" hi PreProc ctermfg=135 guifg=#af5fff
hi PreProc ctermfg=135 guifg=#C23BFF

" hi Type ctermfg=46 guifg=#2DFF2D
hi Type ctermfg=46 guifg=#2DFF2D
hi StorageClass ctermfg=34 guifg=#00af00

" hi Special ctermfg=75
" hi Special ctermfg=39 guifg=#00afff
hi Special ctermfg=39 guifg=#31BEFF
hi SpecialChar ctermfg=39 guifg=#179BFF
hi Delimiter ctermfg=37 guifg=#63A5A5

hi Underlined cterm=underline,bold ctermfg=81 guifg=#5fd7ff

hi Error ctermfg=253 ctermbg=124 guifg=#dadada guibg=#af0000

hi Todo ctermfg=16 ctermbg=220 guifg=#000000 guibg=#ffd700

" Non-standard
" hi Brackets ctermfg=37
hi link Brackets Delimiter
hi link Braces Brackets
hi link FunctionBraces Braces
" hi Parens ctermfg=111 guifg=#87ffff
hi link Parens Delimiter

" hi FunctionCall ctermfg=123 guifg=#87ffff
" hi FunctionCall ctermfg=123 cterm=italic guifg=#78FBFF
" hi FunctionCall ctermfg=123 guifg=#78FBFF
hi link FunctionCall Function

hi link FunctionParens Operator
hi link Noise Operator

" Spelling
hi SpellBad   cterm=none ctermfg=255 ctermbg=88 guifg=#eeeeee guibg=#870000
hi SpellCap   cterm=none ctermfg=255 ctermbg=12 guifg=#eeeeee guibg=#ffff87
hi SpellLocal cterm=none ctermfg=255 ctermbg=33 guifg=#eeeeee guibg=#0087ff
hi SpellRare  cterm=none ctermfg=255 ctermbg=13 guifg=#eeeeee guibg=#bb54c6

" Diffs (e.g. Git)
hi DiffAdd    ctermfg=40  ctermbg=none guifg=#00d700
hi DiffChange ctermfg=220 ctermbg=none guifg=#ffd700
hi DiffDelete ctermfg=160 ctermbg=none guifg=#d70000
hi DiffText   ctermfg=220 ctermbg=58   guifg=#ffd700 guibg=#5f5f00 cterm=none
