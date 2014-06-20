" file_path:h => project_info
let s:project_cache = {}
let s:project_marker_dirs = ['lib', 'ext', 'test', 'spec', 'bin', 'autoload', 'plugins', 'plugin', 'src']
let s:project_replace_pattern = '\(.*\)/\('.join(s:project_marker_dirs,'\|').'\)\(/.\{-}\)\?$'

let s:default_project_dir = expand('~/projects/')

let s:project_root_filenames = ['.git', '.svn']

let s:project_detection_methods = []

" Utility {{{
function! s:starts_with(str, prefix) abort " {{{
	return len(a:prefix) <= len(a:str) && a:prefix == a:str[0:len(a:prefix) - 1]
endfunction " }}}
" }}}

" Detection method {{{
function s:register_project_detection_method(definition) abort
	call insert(s:project_detection_methods, a:definition)
endfunction

let s:dm = {'name': 'default'} " {{{
function! s:dm.project_root_of(dir) abort " {{{
	if s:starts_with(a:dir, s:default_project_dir)
		return a:dir[len(s:default_project_dir):-1]
	elseif a:dir =~ s:project_replace_pattern && a:dir !~ '/usr/.*'
		return substitute(a:dir, s:project_replace_pattern, '\1', '')
	endif
endfunction " }}}
call s:register_project_detection_method(s:dm)
" }}}

let s:dm = {'name': 'project root filename'} " {{{
function! s:dm.project_root_of(dir) abort " {{{
	let i = 0
	let d = a:dir
	while i < 20
		if d == '/'
			return ''
		endif
		for f in s:project_root_filenames
			if !empty(globpath(d, '/' . f))
				return d
			endif
		endfor
		let d = fnamemodify(d, ':h')
		let i += 1
	endwhile
	return ''
endfunction " }}}
call s:register_project_detection_method(s:dm)
" }}}

" }}}


let s:empty_project_info = {
\  'name': '',
\  'main_name': '',
\  'sub_name': '',
\  'path': '',
\  'main_path': '',
\  'sub_path': '',
\}
function! CurrentProjectInfo(...) abort " {{{
	if a:0 == 0
		let file_path = expand('%')
	elseif a:0 == 1
		let file_path = a:1
	else
		throw "Illegal argument size(expected 0 to 1): ".a:0
	endif

	if file_path == ''
		return copy(s:empty_project_info)
	else

	if has_key(s:project_cache, file_path)
		return s:project_cache[file_path]
	endif

	let dir = fnamemodify(file_path, ':p:h')
	if has_key(s:project_cache, dir)
		let s:project_cache[file_path] = s:project_cache[dir]
		return s:project_cache[dir]
	endif

	let project_root = s:project_root_for(file_path)
	let sub_project_name = s:subproject_name(project_root, file_path)
	let main_project_name = fnamemodify(project_root, ':t')
	let name = main_project_name
	let path = project_root
	if !empty(sub_project_name)
		let name .= '/'.sub_project_name
		let path .= '/'.sub_project_name
	endif
	let info = {
	\  'name': name,
	\  'main_name': main_project_name,
	\  'sub_name': sub_project_name,
	\  'path': path,
	\  'main_path': project_root,
	\  'sub_path': path,
	\}
	let s:project_cache[dir] = info
	let s:project_cache[file_path] = info
	return info
endfunction " }}}

function! s:project_root_for(file_path) abort abort " {{{
	let dir = fnamemodify(a:file_path, ':p:h')

	for method in s:project_detection_methods
		if has_key(method, 'project_root_of')
			let root = method.project_root_of(dir)
		else
			throw "Invalid method definition: " . get(method, 'name', '(unnamed)')
		endif
		if !empty(root)
			return root
		endif
	endfor
	return ''
endfunction " }}}

function! s:subproject_name(root, path) abort abort " {{{
	let name = matchstr(fnamemodify(a:path, ':p'), '^'.a:root.'/\zs[^/]\+\ze/.*')
	if name != -1 && !empty(name) && index(s:project_marker_dirs, name) == -1
		for suffix in s:project_marker_dirs
			if getftype(a:root.'/'.name.'/'.suffix) == 'dir'
				return name
			endif
		endfor
	endif
	return ''
endfunction " }}}

