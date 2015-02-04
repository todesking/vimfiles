if !exists('g:textobj#methodcall#select_a')
	let g:textobj#methodcall#select_a = 'ac'
endif
if !exists('g:textobj#methodcall#select_i')
	let g:textobj#methodcall#select_i = 'ic'
endif


call textobj#user#plugin('methodcall', {
\   'methodcall': {
\     'select-a': g:textobj#methodcall#select_a,
\     'select-i': g:textobj#methodcall#select_i,
\     'select-a-function': 'textobj#methodcall#select_a',
\     'select-i-function': 'textobj#methodcall#select_i',
\   },
\})
