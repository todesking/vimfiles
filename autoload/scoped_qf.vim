let s:prefix = 'scoped_qf_'
let s:data_key = s:prefix . 'data'

function! scoped_qf#update() abort " {{{
	let scope = metascope#scope(g:scoped_qf_scope_type)
	if !scope.exists(s:data_key)
		return
	endif
	call s:set(scope.get(s:data_key))
endfunction " }}}

function! scoped_qf#set(data) abort " {{{
	let scope = metascope#scope(g:scoped_qf_scope_type)
	call scope.set(s:data_key, a:data)

	call s:set(a:data)
endfunction " }}}

function! s:set(data) abort " {{{
	call setqflist(a:data)
	call s:set_syntastic(a:data)
endfunction " }}}

" Syntastic {{{
function! s:set_syntastic(data) abort " {{{
	if !exists('g:SyntasticLocList')
		return
	endif
	if g:SyntasticLoclist.current().getRaw() == a:data
		return
	endif
	let notifier = g:SyntasticNotifiers.Instance()
	call notifier.reset(g:SyntasticLoclist.current())
	call b:syntastic_loclist.destroy()

	let loclist = g:SyntasticLoclist.New(a:data)
	call loclist.deploy()
	call s:syntastic_notifier_try_refresh(notifier, loclist)
endfunction " }}}

function! s:syntastic_notifier_try_refresh(notifier, loclist) abort " {{{
	try
		call a:notifier.refresh(a:loclist)
	catch /^Vim\%((\a\+)\)\=:E523/
	endtry
endfunction " }}}
" }}}
