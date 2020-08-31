set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif

let colors_name = "custom"

hi SpecialKey ctermfg=4
hi NonText cterm=bold ctermfg=4
hi Directory ctermfg=4
hi ErrorMsg cterm=bold ctermfg=7 ctermbg=1
hi IncSearch cterm=reverse
hi Search ctermbg=3
hi MoreMsg ctermfg=2
hi ModeMsg cterm=bold
hi LineNr ctermfg=3
hi Question ctermfg=2
hi StatusLine cterm=bold,reverse
hi StatusLineNC cterm=reverse
hi VertSplit cterm=reverse
hi Title ctermfg=5
hi Visual cterm=reverse ctermbg=black
hi VisualNOS cterm=bold,underline,underline
hi WarningMsg ctermfg=1
hi WildMenu ctermfg=0 ctermbg=3
hi Folded ctermbg=236 ctermfg=248
hi FoldColumn ctermbg=236 ctermfg=248
hi Pmenu ctermfg=15 ctermbg=17
hi PmenuSel ctermfg=11 ctermbg=21
hi CursorLine cterm=none
hi Title cterm=bold ctermfg=99
hi VertSplit cterm=none ctermbg=none ctermfg=255

" Colors for syntax highlighting
hi Comment ctermfg=32 ctermbg=235
hi Constant ctermfg=196
hi Special ctermfg=75
hi Identifier cterm=none ctermfg=43
hi Statement ctermfg=220
hi PreProc ctermfg=99
hi StorageClass ctermfg=34
hi Type ctermfg=48
hi Ignore cterm=bold ctermfg=7
hi Error cterm=bold ctermfg=7 ctermbg=1
hi Todo ctermfg=0 ctermbg=3
hi SpellBad cterm=none ctermfg=15 ctermbg=88
hi SpellCap cterm=none ctermfg=15 ctermbg=12
hi SpellRare cterm=none ctermfg=15 ctermbg=13
hi SpellLocal cterm=none ctermfg=15 ctermbg=33

hi ColorColumn ctermbg=234

" Diffs (e.g. Git)
hi DiffAdd ctermfg=2 ctermbg=none
hi DiffChange ctermfg=3 ctermbg=none
hi DiffDelete ctermfg=1 ctermbg=none
hi DiffText cterm=bold ctermbg=1
