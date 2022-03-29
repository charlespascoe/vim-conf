func serenade#Init()
    " TODO: Move to plugin (somehow - maybe relative to path of this script)
    let s:job = job_start('/opt/homebrew/bin/python3 /Users/charles/.vim-conf/serenade_client.py', {
    \    'out_io': 'pipe',
    \    'err_io': 'pipe',
    \    'in_io': 'pipe',
    \    'mode': 'nl',
    \    'callback': 'serenade#OnOutput',
    \    'err_cb': 'serenade#OnError',
    \    'exit_cb': 'serenade#OnExit',
    \    'stoponexit': 'term'
    \})
    py3 import serenade

    " Needed to allow the cursor to go past the last character (which Serenade
    " expects)
    set ve+=onemore
endfun

func serenade#OnOutput(job, msg)
    let g:__serenade_message = a:msg
    let res = py3eval('serenade.handle_message(vim.eval("g:__serenade_message"))')

    if res == ""
        return
    end

    let ch = job_getchannel(s:job)

    call ch_sendraw(ch, res)
endfun

func serenade#OnError(job, msg)
    echom "Msg: ".a:msg
endfun

func serenade#OnExit(job, code)
    echom "Code: ".a:code
endfun
