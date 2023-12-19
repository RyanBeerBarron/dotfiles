" Normal mode mappings
nnoremap <C-e> <Cmd>edit .<CR>
nnoremap [[  ?{<CR>w99[{
nnoremap ]]  j0[[%/{<CR>
nnoremap ][  /}<CR>b99]}
nnoremap []  k$][%?}<CR>
nnoremap <C-b> <cmd>tag<cr>
nnoremap <F1> <cmd>cprev<cr>
nnoremap <F2> <cmd>cnext<cr>
nnoremap <F3> <cmd>lprev<cr>
nnoremap <F4> <cmd>lnext<cr>
nnoremap <C-j> <cmd>bprevious<cr>
nnoremap <C-k> <cmd>bnext<cr>
nnoremap <S-j> j

" Normal mode mappings with leader key
nnoremap <leader>tc <Cmd>tabclose<CR>
nnoremap <leader>tn <Cmd>tabnew<CR>
nnoremap <leader>f <Cmd>execute \"find\" expand(\"<cword>\")<CR>
nnoremap <leader>p "+p
nnoremap <leader>P "+P
nnoremap <leader>y "+y
nnoremap <leader>Y "+Y

" Normal mode mappings starting with ','
nnoremap ,bd <cmd>bdel<cr>
nnoremap ,cc <cmd>cclose<cr>

" Insert mode mapping
inoremap {<cr> {<cr>}<ESC>O
inoremap <C-p> <Up>
inoremap <C-n> <Down>


" Visual mode mappings
vnoremap > >gv
vnoremap < <gv
vnoremap <S-j> j
vnoremap <S-k> k
vnoremap <leader>p "+p
vnoremap <leader>P "+P
vnoremap <leader>y "+y


cnoremap <C-x> <C-a>
