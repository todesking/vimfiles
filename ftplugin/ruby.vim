setlocal expandtab
setlocal shiftwidth=2

inoremap <buffer> <c-]> end<ESC>

nnoremap <buffer> <leader>f :set foldmethod=syntax<CR>:set foldmethod=manual<CR>
set foldmethod=manual

" To avoid ultra-heavy movement when Ruby insert mode {{{
" Don't screw up folds when inserting text that might affect them, until
" leaving insert mode. Foldmethod is local to the window. Protect against
" screwing up folding when switching between windows.
autocmd InsertEnter <buffer> if !exists('w:last_fdm') | let w:last_fdm=&foldmethod | setlocal foldmethod=manual | endif
autocmd InsertLeave,WinLeave <buffer> if exists('w:last_fdm') | let &l:foldmethod=w:last_fdm | unlet w:last_fdm | endif
" }}}
