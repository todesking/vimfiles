let s:sorter_smart = {
			\ 'name': 'sorter_smart',
			\ 'description': 'smart sorter(depends on converter_index)',
			\ }
" SPEC
"  keyword is 'user'
"   more is better   : user/user.rb > user/aaa.rb
"   first is better  : user > active_user
"   file > directory : user.rb > user/active_user.rb (TODO)
"   alphabetical     : a_user.rb > b_user.rb
function! s:sorter_smart.filter(candidates, context)
	if len(a:candidates) > 1000
		return a:candidates
	endif

	let preserve_rough_order = a:context.source.name ==# 'file_mru'
	let use_path_context = a:context.source.name =~? '\v^file%(_mru|_rec)?$'

	if use_path_context && !preserve_rough_order && empty(a:context.input)
		for candidate in a:candidates
			let candidate.filter__sort_val = s:whole_sort_val(candidate.word)
		endfor
		return unite#util#sort_by(a:candidates, 'v:val.filter__sort_val')
	endif

	if(empty(a:context.input))
		return a:candidates
	endif

	let keywords = split(a:context.input, '\s\+')
	for candidate in a:candidates
		let prefix = preserve_rough_order ? printf('%05d_', candidate.converter__index / 5) : ''
		let candidate.filter__sort_val =
					\ s:filter_sort_val(prefix, candidate.word, keywords)
	endfor
	return unite#util#sort_by(a:candidates, 'v:val.filter__sort_val')
endfunction

function! s:whole_sort_val(text) abort " {{{
	let segments = split(a:text, '/')
	return join(map(segments[:-2], '''1_'' . v:val'), '/') . '/0_' . segments[-1]
endfunction " }}}

function! s:filter_sort_val(prefix, text, keywords)
	let sort_val = a:prefix
	let text_without_keywords = a:text
	for kw in a:keywords
		let sort_val .= printf('%05d_', 100 - s:matches(a:text, kw))
		let sort_val .= printf('%05d_', stridx(a:text, kw))
		let text_without_keywords =
					\ substitute(text_without_keywords, '\V' . escape(kw, '\'), '', 'g')
	endfor
	let sort_val .= text_without_keywords
	return sort_val
endfunction

function! s:matches(str, pat_str)
	let pat = '\V' . escape(a:pat_str, '\')
	let n = 0
	let i = match(a:str, pat, 0)
	while i != -1
		let n += 1
		let i = match(a:str, pat, i + strlen(a:pat_str))
	endwhile
	return n
endfunction
call unite#define_filter(s:sorter_smart)
unlet s:sorter_smart
