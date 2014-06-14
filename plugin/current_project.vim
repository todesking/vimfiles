" file_path:h => project_info
let s:project_cache = {}
let s:project_marker_dirs = ['lib', 'ext', 'test', 'spec', 'bin', 'autoload', 'plugins', 'plugin', 'src']
let s:project_replace_pattern = '\(.*\)/\('.join(project_marker_dirs,'\|').'\)\(/.\{-}\)\?$'

function! CurrentProjectInfo(...) abort " {{{
	if a:0 == 0
		let file_path = expand('%')
	elseif a:0 == 1
		let file_path = a:1
	else
		throw "Illegal argument size(expected 0 to 1): ".a:0
	endif
	if file_path == ''
		return {
		\  'name': '',
		\  'main_name': '',
		\  'sub_name': '',
		\  'path': '',
		\  'main_path': '',
		\  'sub_path': '',
		\}
	endif
	if has_key(s:project_cache, file_path)
		return s:project_cache[file_path]
	endif
	let dir = fnamemodify(file_path, ':p:h')
	if has_key(s:project_cache, dir)
		let s:project_cache[file_path] = s:project_cache[dir]
		return s:project_cache[dir]
	endif
	let project_root = s:project_root(file_path)
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

function! s:project_root(file_path) abort abort " {{{
	let dir = fnamemodify(a:file_path, ':p:h')
	if exists('b:rails_root')
		return b:rails_root
	endif

	let project_dir = s:current_project_dir_by_git(dir)
	if !empty(project_dir) | return project_dir | endif

	let project_dir = s:current_project_dir_by_rule(dir)
	if !empty(project_dir) | return project_dir | endif

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

function! s:current_project_dir_by_git(dir) abort " {{{
	let i = 0
	let d = a:dir
	while i < 10
		if d == '/'
			return ''
		endif
		if !empty(globpath(d, '/.git'))
			return d
		endif
		let d = fnamemodify(d, ':h')
		let i += 1
	endwhile
	return ''
endfunction " }}}

function! s:current_project_dir_by_rule(dir) abort " {{{
	let dir = a:dir
	if dir =~ '/projects/'
		return substitute(dir, '\v(.*\/projects\/[-_a-zA-Z0-9])\/.*', '\1', '')
	elseif dir =~ s:project_replace_pattern && dir !~ '/usr/.*'
		return substitute(dir, s:project_replace_pattern, '\1', '')
	endif
endfunction " }}}
