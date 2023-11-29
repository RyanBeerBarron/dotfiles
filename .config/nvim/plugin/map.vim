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
nnoremap <leader>p "+p
nnoremap <leader>P "+P
nnoremap <leader>y "+y
nnoremap <leader>Y "+Y


" Insert mode mapping
inoremap {<cr> {<cr>}<ESC>O


" Visual mode mappings
vnoremap > >gv
vnoremap < <gv
vnoremap <leader>p "+p
vnoremap <leader>P "+P
vnoremap <leader>y "+y



" vim: foldmethod=expr
