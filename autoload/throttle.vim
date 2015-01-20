function! throttle#can_enter(scope, name, sec) abort " {{{
	let prev = s:get_var(a:scope, 'throttle_' . a:name, [])
	if !empty(prev) && str2float(reltimestr(reltime(prev))) < a:sec
		return 0
	else
		return 1
	endif
endfunction " }}}

function! throttle#previous_data(scope, name) abort " {{{
	return s:get_var(a:scope, 'throttle_data_' . a:name)
endfunction " }}}

function! throttle#entered(scope, name, ...) abort " {{{
	if a:0 == 1
		call s:set_var(a:scope, 'throttle_data_' . a:name, a:1)
	endif
	call s:set_var(a:scope, 'throttle_' . a:name, reltime())
endfunction " }}}

function! s:get_var(scope, name, ...) abort " {{{
	let s = s:get_scope(a:scope)
	if a:0 == 0
		return get(s, a:name)
	else
		return get(s, a:name, a:1)
	endif
endfunction " }}}

function! s:set_var(scope, name, data) abort " {{{
	let s = s:get_scope(a:scope)
	let s[a:name] = a:data
endfunction " }}}

function! s:get_scope(scope) abort " {{{
	if a:scope ==# 'g'
		return g:
	elseif a:scope ==# 'b'
		return b:
	elseif a:scope ==# 'w'
		return w:
	else
		throw 'Unsupported scope: ' . a:scope
	endif
endfunction " }}}
