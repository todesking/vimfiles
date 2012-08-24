" http://d.hatena.ne.jp/kyuumin/20110524
" Vim syntax file
" Language:	hiki
" Changes:	
" Last Change:	2011 May 24

if exists("b:current_syntax")
  finish
endif

" headword
syn region   hikiHeadWord1      start="^\!\{1}\!\@!"   end="$"
syn region   hikiHeadWord2      start="^\!\{2}\!\@!"   end="$"
syn region   hikiHeadWord3      start="^\!\{3}\!\@!"   end="$"
syn region   hikiHeadWord4      start="^\!\{4}\!\@!"   end="$"
syn region   hikiHeadWord5      start="^\!\{5}\!\@!"   end="$"
syn match    hikiHorizon        "^-\{4}-\@!$"

" items
syn region   hikiItems1      start="^\*\{1}\*\@!"   end="$"
syn region   hikiItems2      start="^\*\{2}\*\@!"   end="$"
syn region   hikiItems3      start="^\*\{3}\*\@!"   end="$"
syn region   hikiNumItems1      start="^#\{1}\*\@!"   end="$"
syn region   hikiNumItems2      start="^#\{2}\*\@!"   end="$"
syn region   hikiNumItems3      start="^#\{3}\*\@!"   end="$"

" stress
syn match   hikiStressO      "\'\{2}\'\@!.*\'\{2}\'\@!"
syn match   hikiStressY      "\'\{3}\'\@!.*\'\{3}\'\@!"

syn match    hikiQuotation        "\"\".*"
syn match    hikiComment        "//.*"
syn match    hikiPreformatted        "^[ (\t)].*"
syn region    hikiUnStress        start="==\s*" end="=="

highlight link hikiHeadWord1 hikiUlC
highlight link hikiHeadWord2 hikiUlLm
highlight link hikiHeadWord3 hikiUlG
highlight link hikiHeadWord4 hikiUlC
highlight link hikiHeadWord5 hikiUlLm
highlight link hikiItems1 hikiLg
highlight link hikiItems2 hikiLg
highlight link hikiItems3 hikiLg
highlight link hikiNumItems1 hikiLb
highlight link hikiNumItems2 hikiLb
highlight link hikiNumItems3 hikiLb
highlight link hikiHorizon hikiStress1

hi hikiUlC gui='underline' guifg='Cyan'
hi hikiUlLm gui='underline' guifg='LightMagenta'
hi hikiUlg gui='underline' guifg='Green'
hi hikiLg  guifg='LightGreen'
hi hikiLb  guifg='LightBlue'
hi hikiStressO gui='bold' guifg='Orange'
hi hikiStressY gui='bold' guifg='Yellow'
hi hikiQuotation guifg='Orange'
hi hikiPreformatted guifg='Yellow'
hi hikiComment gui='bold' guifg='White'
hi hikiUnStress guifg='DarkGray'

let b:current_syntax = "hiki"
