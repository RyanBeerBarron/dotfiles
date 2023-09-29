" Config: open the nvim config folder
command! Config execute "edit" stdpath('config')

" CdBuffer: cd in buffer directory
command! Cdb cd %:h | echo "now in directory: " .. getcwd()

command! -nargs=1 Mksession execute "mksession" stdpath('cache') .. "/<args>.vim"

command! Trim %substitute/\s\+$//e <bar> %substitute/\($\n\s*\)\+\%$//e
