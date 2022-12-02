set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif

" TODO: Tidy
" TODO: Set guibg=NONE as necessary

let colors_name = "custom2"

hi Search cterm=bold guibg=#E2CC54 guifg=#342E09

" hi Normal guibg=#25172A
" hi ColorColumn guibg=#290E33

hi Normal guibg=#241927
hi ColorColumn guibg=#28122E
" hi LineNr guifg=#842DA4
hi LineNr guifg=#8C4A9E

" hi Constant guifg=#FF6363
" hi Constant guifg=#FF3030
hi Constant guifg=#FF3030
" hi String guifg=#FF3030

" hi Identifier guifg=#00FF2D
" hi Identifier guifg=#6AFF84
hi Identifier guifg=#9DFFAE
" hi Function guifg=#FFE100
" hi Function guifg=#FFEA4B
hi Function guifg=#FFEC58
hi! link FunctionCall Function

" hi Statement cterm=bold guifg=#FF42C0
" hi Statement cterm=bold guifg=#FF64E2
hi Statement cterm=none guifg=#E873D2
" hi Operator ctermfg=208 guifg=#FF8626
hi Operator ctermfg=208 guifg=#FFA540

hi NonText cterm=bold ctermfg=39 gui=bold guifg=#00afff

hi PreProc guifg=#377DDB

" hi Type cterm=italic,bold guifg=#00E9FF
hi! link StorageClass Statement
" hi Type cterm=italic

" hi Special guifg=#A063FF
" hi Special guifg=#914BFF
hi Special guifg=#9D5EFF
hi SpecialChar ctermfg=39 guifg=#179BFF

hi Delimiter ctermfg=37 guifg=#63A5A5

hi Underlined cterm=underline,bold ctermfg=81 guifg=#5fd7ff


hi SpecialKey guifg=#3A3E51


" Non-standard
hi FunctionParens guifg=#B79523

hi Error cterm=bold guifg=#FFFFFF guibg=#DE4141
" hi Todo guifg=#111111 guibg=#ffd700
" hi Todo cterm=bold,italic guifg=#111111 guibg=#E3CB4C
hi Todo cterm=bold,italic guifg=#3D3400 guibg=#E3CB4C
" hi Todo cterm=bold,italic guifg=#471451 guibg=#E149FF


" ALTERNATE VARIATION
let alternate = 1

if alternate
    hi Visual cterm=none guibg=#44475A
    hi CursorLine guibg=#44475A
    hi Normal guifg=#F8F8F2 guibg=#282A36
    " hi ColorColumn ctermbg=235 guibg=#21222C
    hi ColorColumn ctermbg=235 guibg=#252733
    hi LineNr guifg=#6272A4
    " hi Operator guifg=#FFAF6F
    " hi Type guifg=#FFEC58
    " hi Function guifg=#00E9FF



    " hi Type cterm=italic ctermfg=117 gui=italic guifg=#8BE9FD
    " hi Type cterm=italic ctermfg=117 gui=italic guifg=#9DFFAE
    hi Type ctermfg=117 guifg=#6FFF88
    " hi Special guifg=#27D6FB
    " hi Special ctermfg=39 guifg=#31BEFF
    " hi Special ctermfg=39 guifg=#9D91FF
    " hi Special ctermfg=39 guifg=#A35DFD
    " hi Special cterm=bold ctermfg=39 guifg=#9087FD
    " hi Special ctermfg=39 guifg=#9087FD
    " hi Special ctermfg=39 guifg=#9F98FD
    " hi Special cterm=bold,italic ctermfg=39 guifg=#9F98FD
    hi Special cterm=bold ctermfg=39 guifg=#B18BFF
    " hi Special ctermfg=39 guifg=#2FA5FF
    hi SpecialChar ctermfg=39 guifg=#2FA5FF

    hi Tag cterm=bold,underdashed guifg=#5fd7ff

    hi Function cterm=none guifg=#FFF180

    hi Identifier cterm=none guifg=#8BE9FD
    " hi Identifier ctermfg=117 guifg=#A1EDFD
    " hi PreProc cterm=italic ctermfg=135 guifg=#9087FD
    " hi PreProc cterm=italic guibg=#2F2938 guifg=#A076C2
    hi PreProc guifg=#9087FD
    " hi Comment ctermfg=61 guifg=#6272A4
    " hi Comment ctermfg=61 guibg=#2B1F50 guifg=#9173E3
    hi Comment ctermfg=61 guibg=#3E3853 guifg=#A381FF
    " hi Constant guifg=#FF6C6C
    hi Constant guifg=#FF5C5C
    " hi Constant guifg=#FF4E4E
    " hi String guifg=#FF6C6C
endif


hi Conceal guifg=#BCBEC6 guibg=#40424B
hi Directory cterm=bold guifg=#BD93F9

" " TODO: Maybe link to similar classes?
hi DiffAdd guifg=#6FFF88 guibg=NONE
" hi DiffChange guifg=#FFA540
hi DiffChange guifg=#FFB86C guibg=NONE
hi DiffDelete guifg=#FF5C5C guibg=NONE

hi! link ErrorMsg Error

hi VertSplit cterm=none guifg=#6272A4

" hi Folded guifg=#6272A4 guibg=#21222C
hi Folded guifg=#8B97BC guibg=#21222C
hi FoldColumn guifg=#8B97BC guibg=#21222C

" hi MatchParen cterm=bold,underline guibg=#585858
hi MatchParen cterm=bold,underline guibg=#424D71


" hi Pmenu guifg=#cccccc guibg=#21222C
hi Pmenu guifg=#cccccc guibg=#261D30
hi PmenuSel guifg=#ffffff guibg=#44475A

" hi PmenuSbar       guibg=#21222C
" hi PmenuSbar       guibg=#2C2D3B
hi PmenuSbar       guibg=#3B2D4A
" hi PmenuThumb      guibg=#44475A
" hi PmenuThumb      guibg=#787D99
hi PmenuThumb      guibg=#AB97C0

" hi SpellBad cterm=undercurl guifg=#FF5555 guisp=#FF5555 guibg=#3D0000
" hi SpellCap cterm=undercurl guifg=#8BE9FD guisp=#8BE9FD guibg=#024958
" hi SpellRare cterm=undercurl guifg=#8BE9FD guisp=#8BE9FD guibg=#024958
" hi SpellLocal cterm=undercurl guifg=#FFB86C guisp=#FFB86C guibg=#5C2F00

hi SpellBad cterm=undercurl guisp=#FF5555 guibg=#3D0000
hi SpellCap cterm=undercurl guisp=#8BE9FD ctermbg=NONE guibg=NONE
hi SpellRare cterm=undercurl guisp=#8BE9FD ctermbg=NONE guibg=NONE
hi SpellLocal cterm=undercurl guisp=#FFB86C ctermbg=NONE guibg=NONE

hi WarningMsg guifg=#FFB86C guibg=#5C2F00


hi StatusLine     cterm=bold guibg=#424450
hi StatusLineNC   guibg=#343746
hi StatusLineTerm cterm=bold guibg=#424450
hi StatusLineTermNC guibg=#343746
hi TabLine        guifg=#6272A4 guibg=#21222C


hi TabLineFill     guifg=#ffffff guibg=#21222C

hi! link TabLineSel     Normal

hi Title         cterm=bold,underdouble guifg=#FF79C6


hi SignColumn     guifg=#6272A4 guibg=#282A36

hi! link Question Type
hi! link MoreMsg Type

hi EndOfBuffer  guifg=#424450
