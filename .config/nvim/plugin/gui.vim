if has("gui_running")
    function! s:IncreaseFontSize(...)
        let num = a:0 >= 1 ? a:1 : 2
        let guifont = &guifont
        let fontsize = str2nr(matchstr(guifont, "\\d\\+$"))
        let fontsize = fontsize + num
        let &guifont = substitute(guifont, "\\d\\+$", fontsize, "")
    endfunction

    function! s:SetFontSize(fontsize)
        let &guifont = substitute(&guifont, "\\d\\+$", a:fontsize, "")
    endfunction

    command! -nargs=? IncreaseFontSize call <SID>IncreaseFontSize(<args>)
    command! -nargs=1 SetFontSize call <SID>SetFontSize(<args>)

    nnoremap <silent> <C-=> <Cmd>IncreaseFontSize 1<cr>
    nnoremap <silent> <C--> <Cmd>IncreaseFontSize -1<cr>

endif
