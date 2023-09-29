" Normal mode mappings
nnoremap <C-e> <Cmd>e .<CR>
nnoremap <M-m> <Cmd>make<CR>
nnoremap <F5> <Cmd>cprev<CR>
nnoremap <F6> <Cmd>cnext<CR>
nnoremap [[  ?{<CR>w99[{
nnoremap ]]  j0[[%/{<CR>
nnoremap ][  /}<CR>b99]}
nnoremap []  k$][%?}<CR>
nnoremap <M-t> <cmd>tag<cr>


" Normal mode mappings with leader key
nnoremap <leader>tc <Cmd>tabclose<CR>
nnoremap <leader>tn <Cmd>tabnew<CR>
nnoremap <leader>f <Cmd>execute \"find\" expand(\"<cword>\")<CR>
nnoremap <leader>cc <Cmd>Config<CR>
nnoremap <leader>cd <Cmd>Cdb<CR>


" Insert mode mapping
inoremap {<cr> {<cr>}<ESC>O


" Visual mode mappings
vnoremap > >gv
vnoremap < <gv


" readline/emacs mappings
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
cnoremap <M-f> <S-Right>
cnoremap <M-b> <S-Left>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
"this mapping does not work as expected if inside a word, it will delete it al
"when it should delete the part in front of the cursor, like :normal dw
"cnoremap <M-d> <S-Right><C-w>
inoremap <C-f> <Right>
inoremap <C-b> <Left>
inoremap <M-f> <S-Right>
inoremap <M-b> <S-Left>
inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-d> <Del>
inoremap <M-d> <C-o>dvw


" vim: foldmethod=expr
