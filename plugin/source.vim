function! SourceThis() abort " {{{
	update
	let path = expand('%')
	let file = fnamemodify(path, ':t')
	let ext = fnamemodify(path, ':e')
	if fnamemodify(path, ':e') != 'vim' && fnamemodify(path, ':t') !~# '.*vimrc'
		if input("Really source " . file . " ?[y/n]") !~? '\vy(es)?'
			return
		endif
	endif
	execute 'source ' . path
endfunction " }}}
