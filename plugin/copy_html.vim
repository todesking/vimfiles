" Convert selected region to HTML and copy to clipboard
" Mac OSX only
"
" See :help TOhtml to format configuration

"let g:html_number_lines = 0 " Disable line numbers

command! -nargs=0 -range=% CopyHtml call s:copy_html()

function! s:copy_html() abort " {{{
	'<,'>TOhtml
	w !textutil -format html -convert rtf -stdin -stdout | pbcopy
	bdelete!
endfunction " }}}
