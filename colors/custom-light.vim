set background=light
hi clear
if exists("syntax_on")
  syntax reset
endif

let colors_name = "custom-light"

hi Normal ctermfg=Black ctermbg=White

" Groups used in the 'highlight' and 'guicursor' options default value.
hi ErrorMsg term=standout ctermbg=DarkRed ctermfg=White
hi IncSearch term=reverse cterm=reverse
hi ModeMsg term=bold cterm=bold
hi StatusLine term=reverse,bold cterm=reverse,bold
hi StatusLineNC term=reverse cterm=reverse
hi VertSplit term=reverse cterm=reverse
hi Visual term=reverse ctermbg=grey
hi VisualNOS term=underline,bold cterm=underline,bold
hi DiffText term=reverse cterm=bold ctermbg=Red
hi Directory term=bold ctermfg=DarkBlue
hi LineNr term=underline ctermfg=Brown
hi MoreMsg term=bold ctermfg=DarkGreen
hi NonText term=bold ctermfg=Blue
hi Question term=standout ctermfg=DarkGreen
hi Search term=reverse ctermbg=Yellow ctermfg=NONE
hi SpecialKey term=bold ctermfg=DarkBlue
hi Title term=bold ctermfg=DarkMagenta
hi WarningMsg term=standout ctermfg=DarkRed
hi WildMenu term=standout ctermbg=Yellow ctermfg=Black
hi Folded term=standout ctermbg=Grey ctermfg=DarkBlue
hi FoldColumn term=standout ctermbg=Grey ctermfg=DarkBlue
hi DiffAdd term=bold ctermbg=LightBlue
hi DiffChange term=bold ctermbg=LightMagenta
hi DiffDelete term=bold ctermfg=Blue ctermbg=LightCyan
hi CursorLine term=underline cterm=underline
hi CursorColumn term=reverse ctermbg=grey
hi ColorColumn ctermbg=255

hi Identifier ctermfg=21
hi Comment cterm=italic ctermfg=4
hi Type ctermfg=28

" Colors for syntax highlighting
hi Constant term=underline ctermfg=196
hi Special term=bold ctermfg=31
hi Statement ctermfg=136
hi Ignore ctermfg=LightGrey
hi LineNr ctermfg=244
hi CursorLineNr ctermfg=238
hi Noise ctermfg=32
