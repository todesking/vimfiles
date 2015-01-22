let s:def = {'name': 'filetype'}

function! s:def.scope_identifier() abort " {{{
	return &filetype
endfunction " }}}

call metascope#register(s:def)

unlet s:def

