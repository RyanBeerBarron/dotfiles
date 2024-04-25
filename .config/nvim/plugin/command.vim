" Config: open the nvim config folder
command! -nargs=0 Config call <SID>editConfig()

let s:configWinId = -1
function s:editConfig()
    if ! win_gotoid(s:configWinId)
        execute 'tabnew' stdpath('config')
        execute 'tcd' stdpath('config')
        let s:configWinId = win_getid()
        setlocal wildignore+=*/pack/*
    endif
endfunction
nnoremap <leader>cf <cmd>Config<cr>

" CdBuffer: cd in buffer directory
command! -nargs=0 Cd cd %:h | echo "now in directory: " .. getcwd()
command! -nargs=0 Lcd lcd %:h | echo "now current window in directory: " .. getcwd()
nnoremap <leader>cd <cmd>Cd<cr>
nnoremap <leader>lcd <cmd>Lcd<cr>

command! -nargs=1 MoveWin call <SID>moveWinToTab(<args>)
nnoremap <C-t>m <cmd>execute "MoveWin " .. v:count1<cr>

function! s:moveWinToTab(tabnum)
    let bufnr = bufnr()
    wincmd c
    execute "normal " .. a:tabnum .. "gt"
    execute "sbuffer " .. bufnr
endfunction
