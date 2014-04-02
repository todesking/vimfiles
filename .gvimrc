if has('gui')
	let g:molokai_original=1
	if hostname() =~ 'MacBook-Pro'
		set guifont=Sauce\ Code\ Powerline:h12
	else
		set guifont=Sauce\ Code\ Powerline:h14,Source\ Code\ Pro:h14,Osaka-Mono:h16
	endif
	set noballooneval
	set guioptions=erL

	colorscheme molokai
	highlight VertSplit guifg=#ffff00
	highlight PmenuSel guibg=#444444 guifg=#D8D8D2
	MenuLang en_US.UTF-8
	set lines=49
	set columns=177
endif
