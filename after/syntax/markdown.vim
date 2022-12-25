hi link mkdHeading Title

syn region markdownConceal start=/||/ end=/||/ contains=@mkdNonListItem,@Spell containedin=mkdNonListItemBlock
hi link markdownConceal Visual
