augroup Highlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank() {higroup="Normal",on_visual=false}
augroup END
