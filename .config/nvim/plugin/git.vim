command -range -nargs=* GitBlame <line1>,<line2>call <SID>gitBlame([<f-args>])
command -range -nargs=* GitLog <line1>,<line2>call <SID>gitLog([<f-args>])

function s:gitLog(args) range abort
    let range_arg = expand("%")
    if a:firstline != 1 && a:lastline != 1
        let range_arg = " -L " . a:firstline . "," . a:lastline . ":" . expand("%")
    endif
    call RunInTerm("git log " . join(a:args, " ") . range_arg )
endfunction

function s:gitBlame(args) range abort
    let range_arg = ""
    if a:firstline != 1 && a:lastline != 1
        let range_arg = " -L " . a:firstline . "," . a:lastline
    endif
    call RunInTerm("git blame " . join(a:args, " ") . range_arg . " " . expand("%"))
endfunction


function s:gitDiff() range

endfunction
nnoremap <C-g>d <cmd>call RunInTerm("git diff " .. expand("%"))<cr>

vnoremap <C-g>b :GitBlame<CR>
vnoremap <C-g><C-b> :GitBlame
nnoremap <C-g>b <cmd>0,0GitBlame<CR>

vnoremap <C-g>l :GitLog<CR>
vnoremap <C-g><C-l> :GitLog
nnoremap <C-g>l <cmd>0,0GitLog<CR>
