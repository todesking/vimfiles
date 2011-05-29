call pathogen#runtime_append_all_bundles()

set smartcase
set wrapscan
set incsearch

set number
set showmatch
set laststatus=2
set showcmd
set viminfo='100,<100,s100,h,rA:,rB:,!,/100

set smartindent
set autoindent

set tabstop=4
set shiftwidth=4

set clipboard=unnamed

set wildmode=list:longest
set completeopt=menuone,preview

set hidden

set history=500

if(has('gui'))
	set noballooneval
	set guifont=Osaka-Mono:h18
endif


" keymap
nnoremap ,n :tabnew<CR>
nnoremap ,h :tabPrevious<CR>
nnoremap ,l :tabNext<CR>

nnoremap ,bd :bdelete<CR>


" normalでしばらく放置するとcursorline
augroup vimrc-auto-cursorline
  autocmd!
  autocmd CursorMoved * call s:auto_cursorline('CursorMoved')
  autocmd CursorHold * call s:auto_cursorline('CursorHold')
  autocmd WinEnter * call s:auto_cursorline('WinEnter')
  autocmd WinLeave * call s:auto_cursorline('WinLeave')

  let s:cursorline_lock = 0
  function! s:auto_cursorline(event)
    if a:event ==# 'WinEnter'
      setlocal cursorline
      let s:cursorline_lock = 2
    elseif a:event ==# 'WinLeave'
      setlocal nocursorline
    elseif a:event ==# 'CursorMoved'
      if s:cursorline_lock
        if 1 < s:cursorline_lock
          let s:cursorline_lock = 1
        else
          setlocal nocursorline
          let s:cursorline_lock = 0
        endif
      endif
    elseif a:event ==# 'CursorHold'
      setlocal cursorline
      let s:cursorline_lock = 1
    endif
  endfunction
augroup END
