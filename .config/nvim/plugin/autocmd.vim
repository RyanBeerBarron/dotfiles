augroup CursorHighlight
  autocmd!
  autocmd WinLeave * setlocal nocursorline nocursorcolumn
  autocmd WinEnter * setlocal cursorline cursorcolumn
augroup END

augroup Highlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank() {higroup="Normal",on_visual=false}
augroup END
