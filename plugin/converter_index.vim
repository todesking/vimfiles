if !exists(':Unite')
	finish
endif

let s:converter = {
			\ 'name': 'converter_index',
			\ 'description': 'add converter__index to candidate',
			\ }
function! s:converter.filter(candidates, context)
	let i = 0
	for c in a:candidates
		let c.converter__index = i
		let i += 1
	endfor
	return a:candidates
endfunction
call unite#define_filter(s:converter)
unlet s:converter
