inoremap <buffer> sout System.out.println
inoreabbrev <buffer> main public static void main(String[] args) {<cr>}<ESC>kA

nnoremap <buffer> <A-o> <Cmd>lua require('jdtls').organize_imports()<CR>
nnoremap <buffer> crv <Cmd>lua require('jdtls').extract_variable()<CR>
vnoremap <buffer> crv <Cmd>lua require('jdtls').extract_variable(true)<CR>
nnoremap <buffer> crc <Cmd>lua require('jdtls').extract_constant()<CR>
vnoremap <buffer> crc <Cmd>lua require('jdtls').extract_constant(true)<CR>
vnoremap <buffer> crm <Cmd>lua require('jdtls').extract_method(true)<CR>

" If using nvim-dap
" This requires java-debug and vscode-java-test bundles, see install steps in this README further below.
" nnoremap <leader>df <Cmd>lua require'jdtls'.test_class()<CR>
" nnoremap <leader>dn <Cmd>lua require'jdtls'.test_nearest_method()<CR>
