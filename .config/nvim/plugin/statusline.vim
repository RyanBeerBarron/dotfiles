let Dict = {
            \ "n": "Normal",
            \ "v": "Visual",
            \ "i": "Insert",
            \ "c": "Command"
            \ }

function FormatMode()
    let m = mode()
    return get(g:Dict, tolower(m[0]), "")
endfunction

function FormatColorscheme()
    if exists("g:colors_name")
        return g:colors_name . ":" . &background
    endif
    return "undefined"
endfunction

function FormatFont()
    if has("gui_running")
        let colon_indx = stridx(&guifont, ":")
        return &guifont[:colon_indx-1]
    else
        return system("fonts")[:-2]
    endif
endfunction

" set statusline=\ %{FormatMode()}\ --\ %t%=%{FormatColorscheme()}\ --\ %{FormatFont()}\
let &statusline=' %{FormatMode()} -- %t %m%=%{FormatColorscheme()} ' " -- %{FormatFont()} '
