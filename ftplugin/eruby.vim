augroup vimrc-filetype-eruby
	autocmd!
	autocmd FileType eruby inoremap <buffer> {{ <%
	autocmd FileType eruby inoremap <buffer> }} %>
	autocmd FileType eruby inoremap <buffer> {{e <% end %><ESC>
	autocmd FileType eruby inoremap <buffer> {b <br /><ESC>
augroup END
