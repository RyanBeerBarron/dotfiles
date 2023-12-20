function s:matchBracket(arg)
    let char = g:Get_char()
    if char == a:arg
       call feedkeys("\<Right>")
    else
        call feedkeys(a:arg, 'n')
    endif
endfunction

function s:matchSingle()
    call <SID>matchQuote("'")
endfunction

function s:matchDouble()
    call <SID>matchQuote("\"")
endfunction

function s:matchQuote(arg)
    if a:arg == '"' && &ft == "vim"
        call feedkeys('"', 'n')
        return
    endif
    let char = g:Get_char()
    if char == a:arg
        call feedkeys("\<Right>")
    else
        call feedkeys(a:arg .. a:arg .. "\<Left>", 'n')
    endif
endfunction

function s:cleverTab()
	   if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
	      return "\<Tab>"
	   else
	      return "\<C-N>"
	   endif
endfunction

inoremap { {}<Left>
inoremap [ []<Left>
inoremap ( ()<Left>

inoremap } <cmd>call <SID>matchBracket("}")<cr>
inoremap ) <cmd>call <SID>matchBracket(")")<cr>
inoremap ] <cmd>call <SID>matchBracket("]")<cr>
inoremap ' <cmd>call <SID>matchQuote("'")<cr>
inoremap " <cmd>call <SID>matchQuote("\"")<cr>

inoremap <silent> <Tab> <C-R>=<SID>cleverTab()<CR>
