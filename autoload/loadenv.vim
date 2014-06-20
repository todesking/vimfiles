function! loadenv#load(shell_command_template, var_names) abort " {{{
	let temp = tempname()
	let commands = map(copy(a:var_names), '"echo $" . v:val . " > ' . temp . '_" .  v:val')
	let command = substitute(a:shell_command_template, '__CMD__', "'" . join(commands, ';') . "'", '')
	call system(command)
	for name in a:var_names
		let value = substitute(system("cat " . temp . '_' . name), "\n$", '', 'g')
		if !empty(value)
			execute 'let $' . name . ' = value'
		endif
		call system('rm ' . temp . '_' . name)
	endfor
endfunction " }}}

