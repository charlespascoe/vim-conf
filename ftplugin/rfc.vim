fun! TagFunc(pattern, flags, info)
    if a:pattern =~ '^\d\+$'
        return [{'name': 'Page '.a:pattern, 'filename': a:info['buf_ffname'], 'cmd': '/\[Page '.a:pattern.'\]'}]
    elseif a:pattern =~ '\[RFC\d\+\]'
        let ref = matchlist(a:pattern, '\[RFC\(\d\+\)\]')
        let file = trim(system('rfcget '.ref[1]))
        return [{'name': 'RFC '.ref[1], 'filename': file, 'cmd': '1'}]
    elseif a:pattern =~ '\[\w\+\]'
        let ref = matchlist(a:pattern, '\[\(\w\+\)\]')
        return [{'name': 'Reference '.a:pattern, 'filename': a:info['buf_ffname'], 'cmd': '$?^\s\+\zs\['.ref[1].'\]\s'}]
    elseif a:pattern =~ '^\%(\d\+\.\)\+\d*$'
        return [{'name': 'Section '.a:pattern, 'filename': a:info['buf_ffname'], 'cmd': '1/^'.escape(a:pattern, '.').'\s'}]
    elseif synIDattr(synID(line('.'), col('.'), 1), 'name') == 'abnfRuleName'
        let pat = substitute(a:pattern, '^\d\+', '', '')
        return [{'name': 'ABNF Rule '.a:pattern, 'filename': a:info['buf_ffname'], 'cmd': '/^\s\*\zs'.escape(pat, '.').'\s\*='}]
    endif

    return []
endfun

setlocal spelllang=en
setlocal spellfile^=~/rfcs/.en.utf-8.add
setlocal iskeyword+=.,[,]
setlocal tagfunc=TagFunc
