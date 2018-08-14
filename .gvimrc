if has('gui')
	let g:molokai_original=1
	set guifont=Source\ Code\ Pro\ for\ Powerline:h11
	set noballooneval
	set guioptions=erL
	set colorcolumn=120

	colorscheme github
	augroup gvimrc-colorscheme
		" highlight VertSplit guifg=#ffff00
		" highlight PmenuSel guibg=#444444 guifg=#D8D8D2
		" highlight CursorLine gui=bold guibg=NONE guifg=NONE
		highlight ColorColumn guibg=#F3F3FF
		highlight Error guibg=#FF6666
		highlight ErrorMsg gui=underline
	augroup END
	MenuLang en_US.UTF-8
	set lines=52
	set columns=180
endif
