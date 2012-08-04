#!/bin/sh

# TODO: submodule install/update

MACVIM_APP="/Applications/MacVim.app"
MACVIM="${MACVIM_APP}/Contents/Resources/vim/runtime"

function rm_with_message() {
	local file=$1
	if [ -f "${file}" ]; then
		echo "removing: $file"
		rm -f $file
	else
		echo "not found: $file"
	fi
}

if [ -x "$MACVIM" ]; then
	for ruby in ruby eruby; do
		for type in syntax indent ftplugin compiler; do
			rm_with_message $MACVIM/${type}/${ruby}.vim
		done
	done
	rm_with_message $MACVIM/compiler/rubyunit.vim
	rm_with_message $MACVIM/autoload/rubycomplete.vim
fi
