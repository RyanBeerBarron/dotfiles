augroup CursorHighlight
  autocmd!
  autocmd WinLeave * setlocal nocursorline nocursorcolumn
  autocmd WinEnter * setlocal cursorline cursorcolumn
augroup END
