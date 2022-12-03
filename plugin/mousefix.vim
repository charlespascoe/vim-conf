" This plugin prevents the first mouse click to focus Vim from moving the
" cursor, plus it fixes an odd scroll jump issue caused by this approach.

let s:mouse_settings = ''

fun s:FocusChanged(focused)
    if !a:focused
        " Disable mouse settings
        let s:mouse_settings = &mouse
        set mouse=

        " This prevents the first mouse click from moving the cursor. 'scrolloff' has to
        " be set to zero because this causes the window to scroll up when focused.
        map <ScrollWheelUp> <Nop>
        " set scrolloff=0
        " set scrolljump=0
    else
        let &mouse = s:mouse_settings

        " This has to be delayed to skip an initial 'scroll' event that seems
        " to occur
        call timer_start(100, funcref('s:EnableScroll'))
    endif
endfun

fun s:EnableScroll(...)
    silent! unmap <ScrollWheelUp>
endfun

au FocusLost   * call <SID>FocusChanged(0)
au FocusGained * call <SID>FocusChanged(1)
