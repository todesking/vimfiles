augroup vimrc-full-screen-help " {{{
	autocmd!
	autocmd BufEnter * call Vimrc_full_screen_help()
	autocmd FileType * call Vimrc_full_screen_help()
	function! Vimrc_full_screen_help()
		if  &ft =~# '^\(help\|ref-.*\)$' && winnr() == 1 && winnr('$') == 2 && bufname(winbufnr(2)) == ''
			execute "normal! \<C-W>o"
		endif
	endfunction
augroup END " }}}

