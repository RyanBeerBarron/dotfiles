let s:CmdRegister = ""

function! s:CmdKillWord()
    let cmdline = getcmdline()
    let cmd_len = strlen(cmdline)
    let index = getcmdpos()-1
    let startindex = index
    while index < cmd_len && cmdline[index] !~ '[a-zA-Z0-9_#]'
        let index += 1
    endwhile
    while index < cmd_len && cmdline[index] =~ '[a-zA-Z0-9_#]'
        let index += 1
    endwhile
    let cmd = cmdline[index:-1]
    if startindex != 0
        let cmd = cmdline[0:startindex-1] .. cmd
    endif
    let deleted = cmdline[startindex:index-1]
    if strlen(deleted) != 0
        let s:CmdRegister = deleted
    endif
    return cmd
endfunction

function! s:CmdBackwardKillWord()
    let cmdline = getcmdline()
    let cmd_len = strlen(cmdline)
    let index = getcmdpos()-1
    let startindex = index
    " We do 'index-1' because we look behind the cursor position
    " For the string, "as*df" where '*' is the cursor position
    " The cursor is on the 3rd column, so the index is at 2, i.e. on 'd'
    " But we want to look at 's' if it matches or not.
    while index-1 >= 0 && cmdline[index-1] !~ '[a-zA-Z0-9_#]'
        let index -= 1
    endwhile
    while index-1 >= 0 && cmdline[index-1] =~ '[a-zA-Z0-9_#]'
        let index -= 1
    endwhile
    let cmd = cmdline[startindex:-1]
    if index != 0
        let cmd = cmdline[0:index-1] .. cmd
    endif
    let killed = cmdline[index:startindex-1]
    if strlen(killed) != 0 && startindex != 0
        let s:CmdRegister = killed
        call setcmdpos(getcmdpos() - strlen(killed))
    endif
    return cmd
endfunction

function! s:CmdKillLine()
    let l:curpos = getcmdpos()
    let cmdline = getcmdline()
    if curpos == 1
        let s:CmdRegister = cmdline
        return ""
    else
        let killed = cmdline[curpos-1:-1]
        if strlen(killed) != 0
            let s:CmdRegister = killed
        endif
        return cmdline[0:curpos-2]
    endif
endfunction

function! s:CmdBackwardKillLine()
    let l:curpos = getcmdpos()
    let l:cmdline = getcmdline()
    let deleted = cmdline[0:curpos-2]
    call setcmdpos(1)
    if curpos != 1
        let s:CmdRegister = deleted
    endif
    return cmdline[curpos-1:-1]
endfunction

function! s:CmdYank()
    let curpos = getcmdpos()
    let cmdline = getcmdline()
    let cmd = s:CmdRegister .. cmdline[curpos-1:-1]
    if curpos != 1
        let cmd = cmdline[0:curpos-2] .. cmd
    endif
    call setcmdpos(curpos + strlen())
    return cmd
endfunction

" Command mode mapping for emacs/readline bindings
cnoremap <C-F> <Right>
cnoremap <C-B> <Left>
cnoremap <C-N> <Down>
cnoremap <C-P> <Up>
cnoremap <C-D> <Del>
cnoremap <M-f> <S-Right>
cnoremap <M-b> <S-Left>
cnoremap <C-A> <Home>
cnoremap <C-E> <End>
cnoremap <C-w> <C-\>e<SID>CmdBackwardKillWord()<cr>
cnoremap <C-u> <C-\>e<SID>CmdBackwardKillLine()<cr>
cnoremap <M-d> <C-\>e<SID>CmdKillWord()<cr>
cnoremap <C-k> <C-\>e<SID>CmdKillLine()<cr>
cnoremap <C-y> <C-\>e<SID>CmdYank()<cr>


function! s:InsertKillWord()
    if Get_char() != ""
        call feedkeys("\<C-o>de")
    endif
endfunction

function! s:InsertKillLine()
    if Get_char() != ""
        call feedkeys("\<C-o>d$")
    endif
endfunction

function! s:InsertBackwardKillWord()
    call feedkeys("\<C-o>dvb")
endfunction

function! s:InsertBackwardKillLine()
    call feedkeys("\<C-o>dv0")
endfunction

" Insert mode mapping for emacs/readline bindings
inoremap <C-F> <Right>
inoremap <C-B> <Left>
inoremap <M-f> <C-o>e<Right>
inoremap <M-b> <S-Left>
inoremap <C-A> <Home>
inoremap <C-E> <End>
inoremap <C-D> <Del>
"inoremap <C-h> backward-delete-char is a Vim default
inoremap <M-d> <cmd>call <SID>InsertKillWord()<cr>
inoremap <C-w> <cmd>call <SID>InsertBackwardKillWord()<cr>
inoremap <C-k> <cmd>call <SID>InsertKillLine()<cr>
inoremap <C-u> <cmd>call <SID>InsertBackwardKillLine()<cr>
inoremap <C-y> <C-R>"

" vim: foldmethod=expr
