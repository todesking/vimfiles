" filetype | '-' => pattern
let s:word_patterns = {'-': '\v\.?[a-zA-Z0-9_#]+'}

function! textobj#methodcall#select_a() abort " {{{
	let [a, i] = s:get(&filetype)
	if empty(a)
		return 0
	endif

	let [start, end] = a
	return ['v', start, end]
endfunction " }}}

function! textobj#methodcall#select_i() abort " {{{
	let [a, i] = s:get(&filetype)
	if empty(i)
		return 0
	endif

	let [start, end] = i
	return ['v', start, end]
endfunction " }}}

function! textobj#methodcall#register_word_pattern(filetype, pattern) abort " {{{
	let s:word_patterns[a:filetype] = a:pattern
endfunction " }}}

function! textobj#methodcall#operator_surround_blocks(base, key) abort " {{{
	let defs = deepcopy(a:base)
	for ft in keys(s:word_patterns)
		let wp = s:word_patterns[ft]
		let def = {'block': [wp . '\v[[(]\V', '\v[)\]]\V'], 'motionwise': ['char'], 'keys': a:key}
		if has_key(defs, ft)
			call add(defs[ft], def)
		else
			let defs[ft] = [def]
		endif
	endfor
	return defs
endfunction " }}}

function! textobj#methodcall#word_pattern(filetype) abort " {{{
	return get(s:word_patterns, a:filetype, s:word_patterns['-'])
endfunction " }}}

function! s:get(ft) abort " {{{
	let o_cursor = getcurpos()

	let stopline = line('.')

	let word_pattern = textobj#methodcall#word_pattern(a:ft)

	let start_pattern = word_pattern . '\v[[(]'

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
		let [a, b] = ['\V(', '\V)']
	elseif brace ==# '['
		let [a, b] = ['\V[', '\V]']
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
