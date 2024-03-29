"basic settings
set autowrite
set backupext=.bak
set cmdheight=1
set cmdwinheight=12
set concealcursor=
set conceallevel=0
set cursorcolumn
set cursorline
set expandtab
set foldclose&
set foldcolumn=4
set foldexpr=FoldParagraphs(v\:lnum)
set foldlevel=2
set foldmethod=expr
set guifont=CaskaydiaCove\ Nerd\ Font:h16
"set guifont=IosevkaTerm\ Nerd\ Font:h16
set incsearch
set laststatus=3
set linebreak
set list
set listchars=tab:󰌒\ \ ,eol:↲,trail:.,extends:<,precedes:>,nbsp:␣
set matchtime=1
set modelineexpr
set noshowmode
set nowrap
set number
set path+=**
set path+=/usr/include/x86_64-linux-gnu
set scrolloff=8
set shiftwidth=4
set showmatch
set smartindent
set softtabstop=4
set tabstop=4
set tildeop
set wildignore+=*.class
set wildignore+=**/target/**

"netrw settings
let g:netrw_banner=0
let g:netrw_liststyle=0

autocmd FileType java,lua,bash,sh,c,vim,json,go setlocal foldexpr=nvim_treesitter#foldexpr()
autocmd BufReadPost *.bak execute "doautocmd BufReadPost " .. expand("<afile>:r")

" Global variables
let g:loaded_matchit = 1

" vim: foldlevel=0
