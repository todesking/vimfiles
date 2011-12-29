if has('gui')
	set guifont=Osaka-Mono:h18
	MenuLang en_US.UTF-8
	augroup gvimrc-auto-transparency
		autocmd!
		autocmd FocusGained * set transparency=5
		autocmd FocusLost * set transparency=30
	augroup END
endif
