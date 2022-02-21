lua require('plugins')

set rnu

" Specify a directory for plugins
call plug#begin(stdpath('data') . '/init.vim')

" A fuzzy file finder
Plug 'kien/ctrlp.vim'
" A Tree-like side bar for better navigation
Plug 'scrooloose/nerdtree'
" Better syntax-highlighting for filetypes in vim
Plug 'sheerun/vim-polyglot'
" Git integration
Plug 'tpope/vim-fugitive'
" Auto-close braces and scopes
Plug 'jiangmiao/auto-pairs'

" Initialize plugin system
call plug#end()

map nt :NERDTree<CR>
map ntt :NERDTreeToggle<CR>
map ntc :NERDTreeClose<CR>

" Start NERDTree and leave the cursor in it.
" autocmd VimEnter * NERDTree
