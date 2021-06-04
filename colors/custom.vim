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
hi SpecialKey ctermfg=236
hi StatusLine cterm=bold,reverse
hi StatusLineNC cterm=reverse
hi Title cterm=bold,underline ctermfg=135
hi TOhtmlProgress ctermbg=28
hi VertSplit cterm=none ctermbg=none ctermfg=255
hi Visual cterm=reverse ctermbg=16
hi VisualNOS cterm=bold,underline,underline
hi WarningMsg ctermfg=16 ctermbg=214
hi WildMenu ctermfg=16 ctermbg=220

hi clear SignColumn

" Colors for syntax highlighting

hi Comment ctermfg=32 ctermbg=235
hi Constant ctermfg=196
hi Error ctermfg=253 ctermbg=124
hi Identifier cterm=none ctermfg=43
hi PreProc ctermfg=99
hi Special ctermfg=75
hi SpellBad cterm=none ctermfg=255 ctermbg=88
hi SpellCap cterm=none ctermfg=255 ctermbg=12
hi SpellLocal cterm=none ctermfg=255 ctermbg=33
hi SpellRare cterm=none ctermfg=255 ctermbg=13
hi Statement ctermfg=220
hi StorageClass ctermfg=34
hi Todo ctermfg=16 ctermbg=220
hi Type ctermfg=48

" Diffs (e.g. Git)
hi DiffAdd ctermfg=40 ctermbg=none
hi DiffChange ctermfg=220 ctermbg=none
hi DiffDelete ctermfg=160 ctermbg=none
hi DiffText ctermbg=58 ctermfg=220 cterm=none
