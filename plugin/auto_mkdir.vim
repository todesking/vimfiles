" 保存時にディレクトリ作成 {{{
" http://vim-users.jp/2011/02/hack202/
augroup vimrc-auto-mkdir  " {{{
	autocmd!
	autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
	function! s:auto_mkdir(dir, force)  " {{{
		if a:dir =~ '^scp://'
			return
		endif
		if !isdirectory(a:dir) && (a:force ||
		\    input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
			call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
		endif
	endfunction  " }}}
augroup END  " }}}
" }}}

