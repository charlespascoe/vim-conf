let s:completions = {
    \ "key_code": [
        \ "caps_lock",
        \ "left_control",
        \ "left_shift",
        \ "left_option",
        \ "left_command",
        \ "right_control",
        \ "right_shift",
        \ "right_option",
        \ "right_command",
        \ "fn",
        \ "return_or_enter",
        \ "escape",
        \ "delete_or_backspace",
        \ "delete_forward",
        \ "tab",
        \ "spacebar",
        \ "hyphen",
        \ "equal_sign",
        \ "open_bracket",
        \ "close_bracket",
        \ "backslash",
        \ "non_us_pound",
        \ "semicolon",
        \ "quote",
        \ "grave_accent_and_tilde",
        \ "comma",
        \ "period",
        \ "slash",
        \ "non_us_backslash",
        \ "up_arrow",
        \ "down_arrow",
        \ "left_arrow",
        \ "right_arrow",
        \ "page_up",
        \ "page_down",
        \ "home",
        \ "end",
        \ "a",
        \ "b",
        \ "c",
        \ "d",
        \ "e",
        \ "f",
        \ "g",
        \ "h",
        \ "i",
        \ "j",
        \ "k",
        \ "l",
        \ "m",
        \ "n",
        \ "o",
        \ "p",
        \ "q",
        \ "r",
        \ "s",
        \ "t",
        \ "u",
        \ "v",
        \ "w",
        \ "x",
        \ "y",
        \ "z",
        \ "'1'",
        \ "'2'",
        \ "'3'",
        \ "'4'",
        \ "'5'",
        \ "'6'",
        \ "'7'",
        \ "'8'",
        \ "'9'",
        \ "'0'",
        \ "f1",
        \ "f2",
        \ "f3",
        \ "f4",
        \ "f5",
        \ "f6",
        \ "f7",
        \ "f8",
        \ "f9",
        \ "f10",
        \ "f11",
        \ "f12",
        \ "f13",
        \ "f14",
        \ "f15",
        \ "f16",
        \ "f17",
        \ "f18",
        \ "f19",
        \ "f20",
        \ "f21",
        \ "f22",
        \ "f23",
        \ "f24",
        \ "display_brightness_decrement",
        \ "display_brightness_increment",
        \ "mission_control",
        \ "launchpad",
        \ "dashboard",
        \ "illumination_decrement",
        \ "illumination_increment",
        \ "rewind",
        \ "play_or_pause",
        \ "fastforward",
        \ "mute",
        \ "volume_decrement",
        \ "volume_increment",
        \ "eject",
        \ "apple_display_brightness_decrement",
        \ "apple_display_brightness_increment",
        \ "apple_top_case_display_brightness_decrement",
        \ "apple_top_case_display_brightness_increment",
        \ "keypad_num_lock",
        \ "keypad_slash",
        \ "keypad_asterisk",
        \ "keypad_hyphen",
        \ "keypad_plus",
        \ "keypad_enter",
        \ "keypad_1",
        \ "keypad_2",
        \ "keypad_3",
        \ "keypad_4",
        \ "keypad_5",
        \ "keypad_6",
        \ "keypad_7",
        \ "keypad_8",
        \ "keypad_9",
        \ "keypad_0",
        \ "keypad_period",
        \ "keypad_equal_sign",
        \ "keypad_comma",
        \ "vk_none",
        \ "print_screen",
        \ "scroll_lock",
        \ "pause",
        \ "insert",
        \ "application",
        \ "help",
        \ "power",
        \ "execute",
        \ "menu",
        \ "select",
        \ "stop",
        \ "again",
        \ "undo",
        \ "cut",
        \ "copy",
        \ "paste",
        \ "find",
        \ "keypad_equal_sign_as400",
        \ "locking_caps_lock",
        \ "locking_num_lock",
        \ "locking_scroll_lock",
        \ "alternate_erase",
        \ "sys_req_or_attention",
        \ "cancel",
        \ "clear",
        \ "prior",
        \ "return",
        \ "separator",
        \ "out",
        \ "oper",
        \ "clear_or_again",
        \ "cr_sel_or_props",
        \ "ex_sel",
        \ "left_alt",
        \ "left_gui",
        \ "right_alt",
        \ "right_gui",
        \ "vk_consumer_brightness_down",
        \ "vk_consumer_brightness_up",
        \ "vk_mission_control",
        \ "vk_launchpad",
        \ "vk_dashboard",
        \ "vk_consumer_illumination_down",
        \ "vk_consumer_illumination_up",
        \ "vk_consumer_previous",
        \ "vk_consumer_play",
        \ "vk_consumer_next",
        \ "volume_down",
        \ "volume_up",
    \],
    \"modifiers": [
        \ "command",
        \ "control",
        \ "option",
        \ "shift",
        \ "caps_lock",
        \ "left_command",
        \ "left_control",
        \ "left_option",
        \ "left_shift",
        \ "right_command",
        \ "right_control",
        \ "right_option",
        \ "right_shift",
        \ "fn",
        \ "left_alt",
        \ "left_gui",
        \ "right_alt",
        \ "right_gui",
        \ "any",
    \],
    \"conditions": [
        \ "frontmost_application_if",
        \ "frontmost_application_unless",
    \]
\}

" \ "device_if",
" \ "device_unless",
" \ "device_exists_if",
" \ "device_exists_unless",
" \ "keyboard_type_if",
" \ "keyboard_type_unless",
" \ "input_source_if",
" \ "input_source_unless",
" \ "variable_if",
" \ "variable_unless",
" \ "event_changed_if",
" \ "event_changed_unless",

let s:titles = {
    \'modifiers': 'Modifiers',
    \'key_code': 'Keycodes',
    \'conditions': 'Conditions',
\}

let s:after_text = {
    \'conditions': "\<C-l>",
\}

let s:filter_str = ''
let s:filter_items = []

fun! s:Filter(id, key, full_items)
    if a:key =~? '^[a-z0-9_]$'
        let s:filter_str .= tolower(a:key)
    elseif a:key == "\<BS>"
        let s:filter_str = s:filter_str[:-2]
    else
        call popup_filter_menu(a:id, a:key)
        return v:true
    endif

    let s:filter_items = copy(a:full_items)
    call filter(s:filter_items, {idx, item -> stridx(item, s:filter_str) >= 0})
    " TODO: Fuzzy matching based on edit distance

    if len(s:filter_items) == 0
        call add(s:filter_items, '')
    endif

    call popup_settext(a:id, s:filter_items)
    call popup_setoptions(a:id, #{title: PopupTitle(s:key)})

    return v:true
endfun

fun! PopupTitle(key)
    let title = ' '
    if has_key(s:titles, a:key)
        let title .= s:titles[a:key]
    else
        let title .= a:key
    endif

    if s:filter_str == ''
        let title .= ' '
    else
        let title .= ': '.s:filter_str.' '
    endif

    return title
endfun

fun! Callback(id, idx)
    if a:idx > 0
        call feedkeys(s:filter_items[a:idx-1].get(s:after_text, s:key, ''))
    endif
endfun

fun! InsertKeycode()
    let s:filter_str = ''
    let s:filter_items = s:completions['key_code']
    call popup_menu(s:filter_items, #{
        \filter: {id, key -> <SID>Filter(id, key, s:completions['key_code'])},
        \callback: "Callback",
        \title: ' Keycodes ',
        \maxheight: 20,
        \maxwidth: 32,
        \minwidth: 32,
    \})
endfun

fun! InsertText(key)
    let s:key = a:key
    let s:filter_str = ''
    let s:filter_items = s:completions[a:key]

    call popup_menu(s:filter_items, #{
        \filter: {id, key -> <SID>Filter(id, key, s:completions[a:key])},
        \callback: "Callback",
        \title: PopupTitle(a:key),
        \maxheight: 20,
        \maxwidth: 32,
        \minwidth: 32,
    \})
endfun

fun! s:Complete()
    let l = trim(getline('.')[:col('.')-1])
    let m = matchstr(l, '^\%(- \)\?\zs[a-z_]\+\ze:')

    if has_key(s:completions, m)
        call InsertText(m)
        return "\<Ignore>"
    endif

    return "\<C-p>"
endfun


imap <buffer> <expr> <C-z> <SID>Complete()

let b:autocomplete_on_whitespace = 1
