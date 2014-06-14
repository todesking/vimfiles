" Syntax trace {{{
" from http://vim.wikia.com/wiki/Identify_the_syntax_highlighting_group_used_at_the_cursor
command! SyntaxTrace echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"
"}}}

