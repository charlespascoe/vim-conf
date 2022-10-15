au FileType asm,c,crack,cs,d,go,java,javascript,julia,ocaml,ruby,rust let b:ragel_supported = 1

" This is a bit of a hack, but it ensures that the Ragel syntax is loaded after
" the primary syntax. Ideally Vim should load them in the order provided.
au BufNewFile,BufRead *.rl exec "doau BufRead "..fnameescape(expand("<afile>:r"))..' | let &filetype = b:ragel_supported ? &filetype..".ragel" : "ragel"'
au BufNewFile,BufRead *.rl.[a-z]\+ exec "doau BufRead "..fnameescape(expand("<afile>:r:r")..'.'..expand("<afile>:e"))..' | if b:ragel_supported | let &filetype .= ".ragel" | endif'
