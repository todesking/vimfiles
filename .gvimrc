if has('gui')
	let g:molokai_original=1
	set guifont=Osaka-Mono:h17
	colorscheme molokai
	MenuLang en_US.UTF-8
	augroup gvimrc-auto-transparency
		autocmd!
		autocmd FocusGained * set transparency=5
		autocmd FocusLost * set transparency=50
	augroup END
endif
