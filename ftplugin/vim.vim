let b:did_ftplugin = 1

" Vim のユーザ定義コマンドを自動的にシンタックスハイライトする {{{
" http://emanon001.github.com/blog/2012/03/18/syntax-highlighting-of-user-defined-commands-in-vim/
augroup syntax-highlight-extension
	autocmd!
	autocmd Syntax vim call s:set_syntax_of_user_defined_commands()
augroup END

function! s:set_syntax_of_user_defined_commands()
	redir => _
	silent! command
	redir END

	let command_names = map(split(_, '\n')[1:],
		\                 'matchstr(v:val, ''^[!"b]*\s\+\zs\u\w*\ze'')')
	if empty(command_names) | return | endif

	execute 'syntax keyword vimCommand contained' join(command_names)
endfunction
" }}}

setlocal textwidth=0
setlocal foldmethod=marker
