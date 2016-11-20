let s:manager_neobundle = {} " {{{
function! s:manager_neobundle.begin() abort " {{{
	call neobundle#begin(expand('~/.vim/bundle/'))
endfunction " }}}
function! s:manager_neobundle.end() abort " {{{
	call neobundle#end()
endfunction " }}}
function! s:manager_neobundle.bundle(name, args) abort " {{{
	let url = 'https://github.com/' . a:name . '.git'
	call call('neobundle#bundle', [url] + a:args)
endfunction " }}}
function! s:manager_neobundle.enabled(name) abort " {{{
	return neobundle#is_installed(split(a:name, '/')[-1])
endfunction " }}}
" }}}

function! todespm#engine#neobundle#get() abort " {{{
	return s:manager_neobundle
endfunction " }}}
