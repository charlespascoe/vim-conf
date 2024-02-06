syn region asciidoctorCode start=/\m\%(^\|[[:punct:][:space:]]\@<=\)`\ze[^` ].\{-}\S/ end=/`\%([[:punct:][:space:]]\@=\|$\)/

syntax match asciidoctorTodo /TODO:/ contained containedin=asciidoctorComment
hi link asciidoctorTodo Todo

syntax match asciidoctorImportant /IMPORTANT:/ contained containedin=asciidoctorAdmonition
hi link asciidoctorImportant ErrorMsg

syntax match asciidoctorWarning /WARNING:/ contained containedin=asciidoctorAdmonition
hi link asciidoctorWarning WarningMsg

syntax match asciidoctorCaution /CAUTION:/ contained containedin=asciidoctorAdmonition
hi link asciidoctorCaution CautionMsg

syntax match asciidoctorNote /NOTE:/ contained containedin=asciidoctorAdmonition
hi link asciidoctorNote Underlined

syntax match asciidoctorTip /TIP:/ contained containedin=asciidoctorAdmonition
hi link asciidoctorTip Identifier
