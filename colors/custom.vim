set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif

let colors_name = "custom"

hi ColorColumn ctermbg=234
hi CursorLine cterm=none
hi CursorLineNr ctermfg=238
hi Directory ctermfg=33
hi ErrorMsg cterm=bold ctermfg=253 ctermbg=124
hi FoldColumn ctermbg=236 ctermfg=248
hi Folded ctermbg=236 ctermfg=248
hi IncSearch cterm=reverse
hi LineNr ctermfg=244
hi ModeMsg cterm=bold
hi MoreMsg ctermfg=34
hi NonText cterm=bold ctermfg=26
hi Pmenu ctermfg=255 ctermbg=17
hi PmenuSel ctermfg=255 ctermbg=21
hi Question ctermfg=34
hi Search ctermfg=16 ctermbg=220
hi SpecialKey ctermfg=237
hi StatusLine cterm=bold,reverse
hi StatusLineNC cterm=reverse
hi Title cterm=bold,underline ctermfg=135
hi TOhtmlProgress ctermbg=28
hi VertSplit cterm=none ctermbg=none ctermfg=255
hi Visual cterm=reverse ctermbg=16
hi VisualNOS cterm=bold,underline,underline
hi WarningMsg ctermfg=16 ctermbg=214
hi WildMenu ctermfg=16 ctermbg=220
hi MatchParen cterm=bold ctermbg=240

hi clear SignColumn

" Colors for syntax highlighting

hi Comment ctermfg=32 ctermbg=235

" hi Identifier cterm=none ctermfg=43
hi Identifier cterm=none ctermfg=36

hi Constant ctermfg=196

" hi PreProc ctermfg=99
hi PreProc ctermfg=135

hi Statement ctermfg=220
" hi Operator ctermfg=208
hi Operator ctermfg=202

hi Type ctermfg=47
hi StorageClass ctermfg=34

hi Error ctermfg=253 ctermbg=124
" hi Special ctermfg=75
hi Special ctermfg=33 cterm=bold
hi Todo ctermfg=16 ctermbg=220

" Non-standard
hi FunctionCall ctermfg=123
hi link FunctionParens Operator

hi Parens ctermfg=39
hi Brackets ctermfg=43
hi link Braces Brackets
hi link Noise Operator


" Spelling
hi SpellBad cterm=none ctermfg=255 ctermbg=88
hi SpellCap cterm=none ctermfg=255 ctermbg=12
hi SpellLocal cterm=none ctermfg=255 ctermbg=33
hi SpellRare cterm=none ctermfg=255 ctermbg=13

" Diffs (e.g. Git)
hi DiffAdd ctermfg=40 ctermbg=none
hi DiffChange ctermfg=220 ctermbg=none
hi DiffDelete ctermfg=160 ctermbg=none
hi DiffText ctermbg=58 ctermfg=220 cterm=none
