setlocal commentstring=#%s
syntax match subComment /^#.*/
hi link subComment Comment

syntax match subPattern /^\/\%([^\/]\|\\.\)\+\// contains=subEscape,subPatternDiv,subGroup,subRepeat,subSpecialChar,subFlags,subCharset nextgroup=subReplacement
hi link subPattern Constant

syntax match subReplacement /\%([^\/]\|\\.\)*\// contained contains=subPatternDiv,subGroupRef,subEscape nextgroup=subEndFlags

syntax match subGroupRef /\\\d\+\|\${\d\+}/ contained
hi link subGroupRef SpecialChar

syntax match subEscape /\\[tn\\]/ contained
hi link subEscape SpecialChar

syntax match subEscape /\\./ contained
hi link subEscape SpecialChar

syntax match subPatternDiv "/" contained
hi link subPatternDiv Special

syntax match subRepeat /[*+?]/ contained
hi link subRepeat Operator

syntax match subSpecialChar /[\^$]/ contained
hi link subSpecialChar SpecialChar

syntax match subGroup /(?:\|[(|)]/ contained
hi link subGroup Delimiter

syntax match subCharset /\c\\[dswhv]\|\[\%([^\]]\|\\\]\)\+\]/ contained
hi link subCharset Identifier

syntax match subEndFlags /[imsUB]\+/ contained
syntax match subFlags /(?[imsU]\+)/ contained
hi link subEndFlags Special
hi link subFlags Special
