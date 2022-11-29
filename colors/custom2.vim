source ~/.vim-conf/colors/custom.vim


" finish

" hi Normal guibg=#25172A
" hi ColorColumn guibg=#290E33

hi Normal guibg=#241927
hi ColorColumn guibg=#28122E
" hi LineNr guifg=#842DA4
hi LineNr guifg=#8C4A9E

" hi Constant guifg=#FF6363
" hi Constant guifg=#FF3030
hi Constant guifg=#FF3030

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
hi Operator ctermfg=208 guifg=#FF8626

hi PreProc guifg=#377DDB

" hi Type cterm=italic,bold guifg=#00E9FF
hi! link StorageClass Statement
" hi Type cterm=italic

" hi Special guifg=#A063FF
" hi Special guifg=#914BFF
hi Special guifg=#9D5EFF
hi SpecialChar ctermfg=39 guifg=#179BFF


hi SpecialKey guifg=#3A3E51





" ALTERNATE VARIATION
let alternate = 1

if alternate
    hi Visual guibg=#44475A
    hi CursorLine guibg=#44475A
    hi Normal guifg=#F8F8F2 guibg=#282A36
    " hi ColorColumn ctermbg=235 guibg=#21222C
    hi ColorColumn ctermbg=235 guibg=#252733
    hi LineNr guifg=#6272A4
    hi Operator guifg=#FFAF6F
    " hi Type guifg=#FFEC58
    " hi Function guifg=#00E9FF



    " hi Type cterm=italic ctermfg=117 gui=italic guifg=#8BE9FD
    " hi Type cterm=italic ctermfg=117 gui=italic guifg=#9DFFAE
    hi Type ctermfg=117 guifg=#6FFF88
    " hi Special guifg=#27D6FB
    " hi Special ctermfg=39 guifg=#31BEFF
    " hi Special ctermfg=39 guifg=#9D91FF
    " hi Special ctermfg=39 guifg=#A35DFD
    hi Special cterm=bold ctermfg=39 guifg=#9087FD
    hi Function cterm=none guifg=#FFF180

    hi Identifier ctermfg=117 guifg=#8BE9FD
    " hi PreProc cterm=italic ctermfg=135 guifg=#9087FD
    hi PreProc cterm=italic guibg=#2F2938 guifg=#A076C2
    " hi Comment ctermfg=61 guifg=#6272A4
    " hi Comment ctermfg=61 guibg=#2B1F50 guifg=#9173E3
    hi Comment ctermfg=61 guibg=#3E3853 guifg=#A381FF
    hi Constant guifg=#FF6C6C
endif
