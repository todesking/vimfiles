function! textobj#methodcall#select_a() abort " {{{
	let [a, i] = s:get()
	if empty(a)
		return 0
	endif

	let [start, end] = a
	return ['v', start, end]
endfunction " }}}

function! textobj#methodcall#select_i() abort " {{{
	let [a, i] = s:get()
	if empty(i)
		return 0
	endif

	let [start, end] = i
	return ['v', start, end]
endfunction " }}}

function! s:get() abort " {{{
	let o_cursor = getcurpos()

	let stopline = line('.')

	let start_pattern = '\v[a-zA-Z_]+[[(]'

	let start = searchpos(start_pattern, 'bc', stopline)
	if start == [0, 0]
		call setpos('.', o_cursor)
		return [[], []]
	endif

	let brace_start = searchpos(start_pattern, 'ce', line('.'))
	if brace_start == [0, 0]
		echoerr 'textobj#methodcall#select_a: assertion failed: brace start not found'
		call setpos('.', o_cursor)
		return [[], []]
	endif

	let brace = getline(brace_start[0])[brace_start[1] - 1]
	if brace ==# '('
		let [a, b] = ['(', ')']
	elseif brace ==# '['
		let [a, b] = ['[', ']']
	else
		throw 'assertion error: unknown brace: ' . brace
	endif

	let end = searchpairpos(a, '', b, '', '', stopline)
	if end == [0, 0]
		call setpos('.', o_cursor)
		return [[], []]
	endif

	call setpos('.', o_cursor)
	let bn = bufnr('%')

	let a_start = [bn] + start + [0]
	let a_end = [bn] + end + [0]
	let i_start = [bn] + [brace_start[0], brace_start[1] + 1] + [0]
	let i_end = [bn] + [end[0], end[1] - 1] + [0]

	let pos_a = [a_start, a_end]
	if i_start == end
		let pos_i = []
	else
		let pos_i = [i_start, i_end]
	endif
	return [pos_a, pos_i]
endfunction " }}}
