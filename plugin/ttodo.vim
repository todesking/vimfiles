augroup vimrc-todo
	autocmd BufNewFile,BufRead TODO set filetype=todo
	autocmd FileType TODO call s:todo_syntax()
	autocmd FileType TODO call s:todo_folding()
	autocmd FileType TODO call s:todo_keymap()
augroup END

let g:todo_current_doing='(none)'

function! s:todo_keymap()
	nnoremap <buffer> <Plug>(todo-mark-done)    :<C-U>call <SID>todo_done()<CR>
	nnoremap <buffer> <Plug>(todo-mark-discard) :<C-U>call <SID>todo_discard()<CR>
	nnoremap <buffer> <Plug>(todo-mark-clear)   :<C-U>call <SID>todo_clear_mark()<CR>
	nnoremap <buffer> <Plug>(todo-reorder)      :<C-U>call <SID>todo_reorder_buffer()<CR>
	nnoremap <buffer> <Plug>(todo-move-up)      :<C-U>call <SID>todo_move_up()<CR>
	nnoremap <buffer> <Plug>(todo-move-down)    :<C-U>call <SID>todo_move_down()<CR>
	nnoremap <buffer> <Plug>(todo-move-top)    :<C-U>call <SID>todo_move_top()<CR>

	nmap <buffer> <leader>d       <Plug>(todo-mark-done)
	nmap <buffer> <leader>x       <Plug>(todo-mark-discard)
	nmap <buffer> <leader>r       <Plug>(todo-reorder)
	nmap <buffer> <leader><Space> <Plug>(todo-mark-clear)
	nmap <buffer> <leader>k       <Plug>(todo-move-up)
	nmap <buffer> <leader>j       <Plug>(todo-move-down)
	nmap <buffer> <leader>t       <Plug>(todo-move-top)
endfunction

function! s:todo_move_mode()
	nnoremap j <Plug>(todo-move-up)
	nnoremap k <Plug>(todo-move-down)
	nnoremap <ESC> <Plug>(todo-exit-move-mode)
endfunction

function! s:todo_exit_move_mode()
	augroup
endfunction

function! s:todo_syntax()
	highlight TodoDone guifg=darkgray
	highlight TodoDisabled guifg=gray
	highlight TodoNormal guifg=lightgreen
	highlight TodoSeparator guifg=#777777
	highlight link TodoDoing Todo
	highlight link TodoDetail Comment
	syntax match TodoSeparator /: / contained
	syntax match TodoDone  /^\s*\zs\* .*\ze/ contains=TodoSeparator
	syntax match TodoDoing /^\s*\zs> .*\ze/ contains=TodoSeparator
	syntax match TodoDisabled /^\s*\zsx .*\ze/ contains=TodoSeparator
	syntax match TodoNormal /^\(\s*. \)\@!\s*\zs.*\ze/ contains=TodoSeparator
	syntax match TodoDetail /^\s*\zs|.*\ze/
endfunction

function! Vimrc_todo_foldexpr(lnum)
	let indent_level = indent(a:lnum) / &shiftwidth
	if getline(a:lnum) =~ '^\s*|'
		if line('$') >= a:lnum + 1 && getline(a:lnum + 1) =~ '^\s*|'
			return (indent_level + 1)
		else
			return '<'.(indent_level + 1)
		endif
	else
		return '>'.(indent_level + 1)
	endif
endfunction

function! s:todo_folding()
	setlocal foldmethod=expr
	setlocal foldexpr=Vimrc_todo_foldexpr(v:lnum)
endfunction

function! s:todo_discard()
	call s:todo_set_mark_buffer('.', 'x')
endfunction

function! s:todo_done()
	call s:todo_set_mark_buffer('.', '*')
endfunction

function! s:todo_clear_mark()
	call s:todo_set_mark_buffer('.', '')
endfunction

function! s:todo_set_mark_buffer(lnum, mark)
	let line = getline(a:lnum)
	let marked_line = s:todo_set_mark(line, a:mark)
	if line == marked_line
		return
	endif
	call setline(a:lnum, marked_line)
endfunction

function! s:todo_set_mark(line, mark)
	let prefix = (a:mark == '') ? '' : a:mark . ' '
	return substitute(s:strip_mark(a:line), '^\v(\s*)(.*)', '\1'.prefix.'\2', '')
endfunction

function! s:strip_mark(line)
	return substitute(a:line, '\v^\s*\zs[*>x] \ze.*', '', '')
endfunction

function! s:get_mark(line)
	let mark = matchstr(a:line, '\v^\s*\zs[*>x ]\ze .*')
	if mark == ''
		let mark = ' '
	endif
	return mark
endfunction

function! s:mark_priority(mark)
	let definition = {'>':0, ' ':1, '*': 3, 'x':3}
	return definition[a:mark]
endfunction

function! s:stable_sort(list, func)
	let i = 0
	while i < len(a:list)
		let j = len(a:list) - 1
		while j > i
			if a:func(a:list[j - 1], a:list[j]) > 0
					let tmp = a:list[j]
					let a:list[j] = a:list[j - 1]
					let a:list[j - 1] = tmp
			endif
			let j -= 1
		endwhile
		let i += 1
	endwhile
	return a:list
endfunction

function! s:todo_move_up() abort
	let todo = s:create_todo_structure_from_current_buffer()
	let todo_orig = deepcopy(todo)
	let lnum = line('.')
	let lnum =  s:todo_move(todo, lnum, -1)
	if todo != todo_orig
		call s:todo_redraw(todo)
		call cursor(lnum, 0)
	endif
endfunction

function! s:todo_move_down() abort
	let todo = s:create_todo_structure_from_current_buffer()
	let todo_orig = deepcopy(todo)
	let lnum = line('.')
	let lnum = s:todo_move(todo, lnum, 1)
	if todo != todo_orig
		call s:todo_redraw(todo)
		call cursor(lnum, 0)
	endif
endfunction

function! s:todo_move_top() abort
	let todo = s:create_todo_structure_from_current_buffer()
	let todo_orig = deepcopy(todo)
	let lnum = line('.')
	let parent = s:todo_parent_of(todo, lnum)
	let children = []

	for c in parent.children
		if c.lnum == lnum
			call insert(children, c)
		else
			call add(children, c)
		endif
	endfor
	let parent.children = children
	call s:todo_renumber(parent)

	if todo != todo_orig
		call s:todo_redraw(todo)
		call cursor(lnum, 0)
	endif
endfunction

function! s:todo_move(todo, lnum, distance) abort
	let parent = s:todo_parent_of(a:todo, a:lnum)
	let i = 0
	while i < len(parent.children)
		if i + a:distance >= 0 && parent.children[i].lnum == a:lnum
			let tmp = parent.children[i]
			let parent.children[i] = parent.children[i + a:distance]
			let parent.children[i + a:distance] = tmp
			call s:todo_renumber(parent)
			return tmp.lnum
		endif
		let i += 1
	endwhile
endfunction

" return: next lnum
function! s:todo_renumber(todo) abort
	let lnum = a:todo.lnum + 1
	for c in a:todo.children
		let c.lnum = lnum
		let lnum = s:todo_renumber(c)
	endfor
	return lnum
endfunction

function! s:todo_line_count(todo) abort
	let count = 1
	for c in a:todo.children
		let count += s:todo_line_count(c)
	endfor
	return count
endfunction

function! s:todo_parent_of(todo, lnum) abort
	for c in a:todo.children
		if c.lnum == a:lnum
			return a:todo
		endif
		let found = s:todo_parent_of(c, a:lnum)
		if found != {}
			return found
		endif
	endfor
	return {}
endfunction

function! s:update_todo_doing_status(todo)
	call s:todo_clear_doing_mark_all(a:todo)
	call s:sort_todo_structure(a:todo, function('s:todo_ordering'))
	if empty(a:todo.children)
		return a:todo
	endif
	let cur = a:todo.children[0]
	while 1
		let mark = s:get_mark(cur.line)
		if mark == ' '
			let cur.line = s:todo_set_mark(cur.line, '>')
		endif
		if empty(cur.children)
			break
		endif
		let cur = cur.children[0]
	endwhile
	return a:todo
endfunction

function! s:todo_current_doing(todo) abort
	let current_doing = ''
	if a:todo.root || s:get_mark(a:todo.line) == '>'
		let current_doing = a:todo.root ? '' : substitute(s:todo_set_mark(a:todo.line, ''), '^\s\+', '', '')
		for c in a:todo.children
			let child_doing = s:todo_current_doing(c)
			if child_doing != ''
				let current_doing = current_doing . ' > ' . child_doing
			endif
		endfor
	end
	return substitute(current_doing, '^ > ', '', '')
endfunction

function! s:todo_reorder_buffer() abort
	let todo = s:create_todo_structure_from_current_buffer()
	let sorted_todo = s:update_todo_doing_status(deepcopy(todo))
	let g:todo_current_doing = s:todo_current_doing(sorted_todo)
	if todo == sorted_todo
		return
	endif
	call s:todo_redraw(sorted_todo)
endfunction

function! s:todo_redraw(todo)
	let lazyredraw = &lazyredraw
	set lazyredraw
	normal! ggdG
	call s:todo_emit(a:todo)
	normal! gg
	let &lazyredraw=lazyredraw
endfunction

function! s:todo_emit(todo) abort
	if !a:todo.root
		call append(line('$') - 1, a:todo.line)
		for detail in a:todo.detail
			call append(line('$') - 1, repeat("\t", a:todo.level).'| '.detail)
		endfor
	endif
	for c in a:todo.children
		call s:todo_emit(c)
	endfor
endfunction

function! s:todo_clear_doing_mark_all(todo)
	if s:get_mark(a:todo.line) == '>'
		let a:todo.line = s:todo_set_mark(a:todo.line, '')
	endif
	for c in a:todo.children
		call s:todo_clear_doing_mark_all(c)
	endfor
endfunction

function! s:sort_todo_structure(todo, func) abort
	call s:stable_sort(a:todo.children, a:func)
	for c in a:todo.children
		call s:sort_todo_structure(c, a:func)
	endfor
	return a:todo
endfunction

function! s:todo_ordering(a,b)
	return s:mark_priority(s:get_mark(a:a.line)) - s:mark_priority(s:get_mark(a:b.line))
endfunction

let g:todo_debug = []

" for debugging
function! s:print_todo_structure(todo, indent_level)
	echo repeat(' ', a:indent_level * 2) . matchstr(a:todo.line, '\v^\s*\zs.*\ze$')
	for c in a:todo.children
		call s:print_todo_structure(c, a:indent_level + 1)
	endfor
endfunction

function! s:create_todo_structure_from_current_buffer() abort
	let structure = []
	let stack = [s:new_todo_structure(0, 'ROOT')]
	let stack[-1].root = 1
	let lnum = 1
	let prev_indent_level = -1
	let prev_todo = {}

	while lnum <= line('$')
		let line = getline(lnum)

		if line == ''
			let lnum += 1
			continue
		endif

		if line =~ '^\s*|' && !empty(prev_todo)
			call add(prev_todo.detail, substitute(line, '^\s*|\s*', '', ''))
			let lnum += 1
			continue
		endif

		let cur = s:new_todo_structure(lnum, line)
		let prev_todo = cur
		let indent_level = indent(lnum) / &shiftwidth
		let cur.level = indent_level
		if prev_indent_level == indent_level
			let s=remove(stack, -1)
			call add(stack[-1].children, cur)
			call add(stack, cur)
		elseif prev_indent_level < indent_level
			call add(stack[-1].children, cur)
			call add(stack, cur)
		else " prev_indent_level > indent_level
			let pop_count = prev_indent_level - indent_level
			let removed = remove(stack, -pop_count - 1, -1)
			call add(stack[-1].children, cur)
			call add(stack, cur)
		end

		let prev_indent_level = indent_level
		let lnum += 1
	endwhile

	return stack[0]
endfunction

function! s:new_todo_structure(lnum, line) abort
	return {'lnum': a:lnum, 'root': 0, 'level': 0, 'line': a:line, 'children': [], 'detail': []}
endfunction
