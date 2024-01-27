function s:matchBracket(bracket)
    let char = g:Get_char()
    if char == a:bracket
       return "\<Right>"
    else
        return a:bracket
    endif
endfunction

function s:matchQuote(quote)
    if a:quote == '"' && &ft == "vim"
        return '"'
    endif
    let char = g:Get_char()
    if char == a:quote
        return "\<Right>"
    else
        return a:quote .. a:quote .. "\<Left>"
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

inoremap <silent> } <C-R>=<SID>matchBracket("}")<cr>
inoremap <silent> ) <C-R>=<SID>matchBracket(")")<cr>
inoremap <silent> ] <C-R>=<SID>matchBracket("]")<cr>
inoremap <silent> ' <C-R>=<SID>matchQuote("'")<cr>
inoremap <silent> " <C-R>=<SID>matchQuote("\"")<cr>

inoremap <silent> <Tab> <C-R>=<SID>cleverTab()<CR>

cnoremap <expr> <C-p> pumvisible()?"<C-p>":"<Up>"
cnoremap <expr> <C-n> pumvisible()?"<C-n>":"<Down>"
