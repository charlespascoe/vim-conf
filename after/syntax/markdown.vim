hi link mkdHeading Title

" syn region markdownConceal start=/||/ end=/||/ contains=@mkdNonListItem,@Spell containedin=mkdNonListItemBlock
syn region markdownConceal start=/||/ end=/||/ contains=@mkdNonListItem,@Spell containedin=mkdNonListItemBlock
hi link markdownConceal Visual

" Adds space after hashes so that only the header text itself is underlined
syn region markdownH1 matchgroup=markdownH1Delimiter start="##\@!\s\+"      end="#*\s*$" keepend oneline contains=@markdownInline,markdownAutomaticLink contained
syn region markdownH2 matchgroup=markdownH2Delimiter start="###\@!\s\+"     end="#*\s*$" keepend oneline contains=@markdownInline,markdownAutomaticLink contained
syn region markdownH3 matchgroup=markdownH3Delimiter start="####\@!\s\+"    end="#*\s*$" keepend oneline contains=@markdownInline,markdownAutomaticLink contained
syn region markdownH4 matchgroup=markdownH4Delimiter start="#####\@!\s\+"   end="#*\s*$" keepend oneline contains=@markdownInline,markdownAutomaticLink contained
syn region markdownH5 matchgroup=markdownH5Delimiter start="######\@!\s\+"  end="#*\s*$" keepend oneline contains=@markdownInline,markdownAutomaticLink contained
syn region markdownH6 matchgroup=markdownH6Delimiter start="#######\@!\s\+" end="#*\s*$" keepend oneline contains=@markdownInline,markdownAutomaticLink contained

hi markdownBold cterm=bold ctermfg=51 guifg=#74fffb
hi link markdownCode Constant
hi link markdownCodeDelimiter Constant

" I have no idea why they decided to use two spaces for a line break, but it
" interferes with my dictation plugin
syn clear mkdLineBreak
