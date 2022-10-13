fun! UpdateLine()
    if !exists('t:dump_go_winid') || len(getwininfo(t:dump_go_winid)) == 0
        return
    end

    let l:match = matchlist(getline('.'), '^\s\+\([^:]\+\.go\):\(\d\+\)')

    " echom fnamemodify(bufname(winbufnr(t:dump_go_winid)), ':t')
    " echom l:match

    " if len(l:match) > 0
    "     echom l:match[1] == fnamemodify(bufname(t:dump_go_winid), ':t')
    "     echom l:match[1]
    "     echom fnamemodify(bufname(winbufnr(t:dump_go_winid)), ':t')
    " end

    if len(l:match) > 0 && l:match[1] == fnamemodify(bufname(winbufnr(t:dump_go_winid)), ':t')
        " call win_execute(t:dump_go_winid, 'match Highlight /\%'..l:match[2]..'l/')

        echom "CURSOR" l:match[2]
        let l:line = l:match[2]
        let l:height = winheight(t:dump_go_winid)
        let l:topline = min([l:line - (l:height/2), 1])
        call win_execute(t:dump_go_winid, 'call winrestview('..string({'lnum': l:line, 'col': 1, 'topline': l:topline})..')')
    end
endfun

au CursorMoved <buffer> call UpdateLine()

au BufEnter <buffer> set cursorline | match none
au BufLeave <buffer> set nocursorline
