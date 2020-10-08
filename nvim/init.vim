" Copyright Mazurel 2020
 
" Vim plugins outside plug
source $HOME/.config/nvim/vim-surround.vim

" Plugs
call plug#begin('~/.vim/plugged')

Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'preservim/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" For c++ highlighting
Plug 'jackguo380/vim-lsp-cxx-highlight'
" Add "clangd.semanticHighlighting": true 
" To coc config

Plug 'rhysd/vim-clang-format'

Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'

Plug 'wlangstroth/vim-racket'

call plug#end()

" My coc plugins:
" CocInstall coc-tsserver coc-json coc-clangd coc-rls

" Settings
set number
set relativenumber

set tabstop=4
set shiftwidth=4
set expandtab

colorscheme gruvbox
set background=dark

" Better find
set path+=**
set wildmenu

let g:clang_format#style_options = {
            \ "AccessModifierOffset" : -4,
            \ "AllowShortIfStatementsOnASingleLine" : "true" }

" Key bindings
let mapleader=" "

" File reloads
nmap <leader>vr :so%<CR>

" Terminal mappings 
tnoremap <ESC> <C-\><C-n>

" Buffer settings
nmap <leader>bn :bn<CR>
nmap <leader>bp :bp<CR>
nmap <leader>bl :ls<CR>
nnoremap <leader>bo :ls<CR>:b 
nnoremap <leader>bd :bdelete!<CR> 

" Window manipulations 
nmap <leader>w <C-w>

" Quitting
nnoremap <leader>wq :q!<CR>
nnoremap <leader>wd :wq<CR>

au BufNewFile,BufRead *.cpp|*.c|*.h|*.hpp vmap <leader>ff :ClangFormat<CR>
au BufNewFile,BufRead *.cpp|*.c|*.h|*.hpp map <leader>ff :ClangFormat<CR>
au BufNewFile,BufRead *.cpp|*.c|*.h|*.hpp map <leader>ft :ClangFormatAutoToggle<CR>

nmap <leader>tt :terminal<CR>
nmap <leader>tn :NERDTree<CR>

" Spell checking 
nmap <leader>se :set spell<CR>
nmap <leader>sd :set spell&<CR>
nmap <leader>sl :set spell spelllang=

" Snippets
nnoremap <leader>imc i Copyright Mateusz 2020<cr><ESC>

" Include coc defaults
source $HOME/.config/nvim/coc-settings.vim
