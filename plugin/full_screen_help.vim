augroup vimrc-full-screen-help " {{{
	autocmd!
	autocmd BufEnter * call Vimrc_full_screen_help()
	autocmd FileType * call Vimrc_full_screen_help()
	function! Vimrc_full_screen_help() abort
		if  &ft =~# '^\(help\|ref-.*\)$' && winnr() == 1 && winnr('$') == 2 && bufname(winbufnr(2)) == ''
			try
				" This will throw E788, cause unknown
				execute "normal \<C-W>o"
			catch
			endtry
		endif
	endfunction
augroup END " }}}

