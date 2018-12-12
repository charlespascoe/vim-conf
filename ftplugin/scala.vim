" Type analysis commands
nmap <buffer> <leader>td <Esc>:EnDeclaration<CR>
nmap <buffer> <leader>tD <Esc><C-w>v<C-w><C-w>:EnDeclaration<CR>
nmap <buffer> <leader>tI <Esc>:EnSuggestImport<CR>
nmap <buffer> <leader>tO <Esc>:EnOrganiseImports<CR>
nmap <buffer> <leader>tR <Esc>:EnRename<CR>
nmap <buffer> <leader>tt <Esc>:EnType<CR>
nmap <buffer> <leader>tc <Esc>:call EnsimeTypeCheck()<CR>


" Create file command
if !exists('*NewScalaFileFunc')
    EnToggleFullType

    fun! NewScalaFileFunc(type, fqn)
        let l:project_root = FindProjectRoot(getcwd(), '.git')

        if l:project_root == ""
            echo "Can't find project root"
        end

        let l:components = split(a:fqn, '\.')
        let l:package = l:components[:len(l:components) - 2]
        let l:filename = l:components[len(l:components) - 1]
        let l:package_dir = l:project_root.'/src/'.a:type.'/scala/'.join(l:package, '/')

        call mkdir(l:package_dir, 'p')

        let l:filepath = l:package_dir.'/'.l:filename.'.scala'

        execute 'edit' l:filepath
        call append(0, 'package '.join(l:package, '.'))
    endf
end

command! -nargs=1 NewScalaFile :call NewScalaFileFunc('main', <f-args>)
command! -nargs=1 NewScalaTestFile :call NewScalaFileFunc('test', <f-args>)

" Ensime Type Checking improvements
if !exists('g:ensime_type_check_progress')
    let g:ensime_type_check_progress = ""
    call airline#parts#define_accent('ensime_typecheck', 'yellow')
    call airline#parts#define_function('ensime_typecheck', 'EnsimeTypeCheckProgress')
    let g:airline_section_y = airline#section#create_right(['ensime_typecheck'])

    fun! EnsimeTypeCheck()
        let g:ensime_type_check_progress = "Checking..."
        call airline#update_statusline()
        EnTypeCheck
    endfun

    fun! EnsimeTypeCheckComplete()
        let g:ensime_type_check_progress = ""
        call airline#update_statusline()
        " Syntastic errors window
        Errors
    endfun

    fun! EnsimeTypeCheckProgress()
        return g:ensime_type_check_progress
    endfun
endif
