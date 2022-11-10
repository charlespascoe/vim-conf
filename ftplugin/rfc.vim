fun! TagFunc(pattern, flags, info)
    if a:pattern =~ '^\d\+$'
        return [{'name': 'Page '.a:pattern, 'filename': a:info['buf_ffname'], 'cmd': '/\[Page '.a:pattern.'\]'}]
    elseif a:pattern =~ '\[\w\+\]'
        let ref = matchlist(a:pattern, '\[\(\w\+\)\]')
        return [{'name': 'Reference '.a:pattern, 'filename': a:info['buf_ffname'], 'cmd': '$?^\s\+\zs\['.ref[1].'\]\s'}]
    elseif a:pattern =~ '^\%(\d\+\.\)\+$'
        return [{'name': 'Section '.a:pattern, 'filename': a:info['buf_ffname'], 'cmd': '1/^'.escape(a:pattern, '.').'\s'}]
    endif

    return []
endfun

setlocal iskeyword+=.,[,]
setlocal tagfunc=TagFunc
