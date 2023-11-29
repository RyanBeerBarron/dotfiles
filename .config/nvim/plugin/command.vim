" Config: open the nvim config folder
command! -nargs=0 Config execute "edit" stdpath('config')
nnoremap <leader>cf <cmd>Config<cr>

" CdBuffer: cd in buffer directory
command! -nargs=0 Cd cd %:h | echo "now in directory: " .. getcwd()
command! -nargs=0 Lcd lcd %:h | echo "now current window in directory: " .. getcwd()
nnoremap <leader>cd <cmd>Cd<cr>
nnoremap <leader>lcd <cmd>Lcd<cr>

command! -nargs=1 Mksession execute "mksession" stdpath('cache') .. "/<args>.vim"

command! -nargs=0 Trim %substitute/\s\+$//e <bar> %substitute/\($\n\s*\)\+\%$//e
