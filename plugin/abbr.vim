" Varioys abbreviations

" TODO: Make these only enabled where text is expected, likely based on filetype
" iabbr api API

fun s:SetupAbbrs(entered)
    if !a:entered
        cabclear
        return
    endif

    if getcmdtype() != ':'
        return
    endif


    cabbr ps PlugSync
    cabbr pu PlugUpdate

    cabbr m make
    cabbr ms messages
    cabbr tn tabnew

    cabbr ue UltiSnipsEdit

    cabbr <expr> eh 'e '..expand('%:h')..'/'

    cabbr <expr> ds trim(system("date +'%Y-%m-%d_%H%M'"))
endfun

" This prevents eh abbr from having a space when expanding
cmap <expr> <Space> (getcmdtype() == ':' && getcmdline() == 'eh') ? "\<C-]>" : "\<Space>"

au CmdlineEnter * call <SID>SetupAbbrs(1)
au CmdlineLeave * call <SID>SetupAbbrs(0)
