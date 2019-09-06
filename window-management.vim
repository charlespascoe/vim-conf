if !exists("g:__zoomed")
    let g:__zoomed = 0
endif

fun <SID>ShouldZoom()
    let g:__zoomed = !g:__zoomed
    return g:__zoomed
endfun

nmap <silent> <expr> <C-w>z <SID>ShouldZoom() ? ":vertical resize 1000 \| resize 1000<CR>" : "<C-w>="
