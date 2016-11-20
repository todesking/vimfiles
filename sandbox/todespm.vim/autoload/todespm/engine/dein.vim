let s:manager_dein = {} " {{{
function! s:manager_dein.begin(home) abort " {{{
	call dein#begin(a:home)
endfunction " }}}
function! s:manager_dein.end() abort " {{{
	call dein#end()
endfunction " }}}
function! s:manager_dein.bundle(name, args) abort " {{{
	call call('dein#add', [a:name] + a:args)
endfunction " }}}
function! s:manager_dein.enabled(name) abort " {{{
	return !dein#check_install([split(a:name, '/')[-1]])
endfunction " }}}
" }}}

function! todespm#engine#dein#get() abort " {{{
	return s:manager_dein
endfunction " }}}
