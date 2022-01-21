func! s:ShowTemplates()
    call UltiSnips#SnippetsInCurrentScope(1)

    let templates = []
    let names = []

    for [key, info] in items(g:current_ulti_dict_info)
        if stridx(info.location, '_templates') >= 0
            call add(templates, {'name': info.description, 'key': key})
            call add(names, info.description)
        end
    endfor

    call sort(names)

    func! s:PickTemplate(id, cmd) closure
        if a:cmd == -1
            return
        end

        " NOTE: cmd is 1-indexed
        let name = names[a:cmd-1]

        for template in templates
            if template.name == name
                call feedkeys(template.key . "\<C-l>")
                return
            end
        endfor
    endfunc

    call popup_menu(names, #{callback: function('s:PickTemplate')})
endfunc

imap <silent> <C-t> <C-o>:call <SID>ShowTemplates()<CR>
