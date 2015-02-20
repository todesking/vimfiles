if has('gui')
	let g:molokai_original=1
	if hostname() =~# 'MacBook-Pro'
		set guifont=Sauce\ Code\ Powerline:h12
	else
		set guifont=Sauce\ Code\ Powerline:h14,Source\ Code\ Pro:h14,Osaka-Mono:h16
	endif
	set noballooneval
	set guioptions=erL
	set colorcolumn=120

	colorscheme github
	augroup gvimrc-colorscheme
		" highlight VertSplit guifg=#ffff00
		" highlight PmenuSel guibg=#444444 guifg=#D8D8D2
		" highlight CursorLine gui=bold guibg=NONE guifg=NONE
		highlight ColorColumn guibg=#F3F3FF
	augroup END
	MenuLang en_US.UTF-8
	set lines=49
	set columns=177
endif
