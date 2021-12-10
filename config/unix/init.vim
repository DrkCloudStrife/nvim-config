" Vim Configurations
set autoindent
set clipboard+=unnamedplus
set encoding=utf-8
set expandtab
set foldlevel=1
set foldmethod=indent
set guifont=Anonymous\ Pro:h18
set hlsearch
set ignorecase
set nobackup
set nocompatible
set noswapfile
set nowrap
set number
set ruler
set shiftwidth=2
set smarttab
set tabstop=2
set wildignore=*/app/assets/images/*,*/log/*,*/tmp/*,*/public/assets/*,*/public/course-data/*,*/public/system/*,*/public/api/v1/system/*,*/data/course-data/*,*/data/shared/*,.DS_Store,*/node_modules/*,public/app/packs/js/*
set wildignore+=*.png,*.jpg,*.gif,*.jpeg

" vim-plug packages
call plug#begin('~/.nvim/plugged')
  Plug 'airblade/vim-gitgutter'
  Plug 'ervandew/supertab'
  Plug 'jeetsukumaran/vim-buffergator'
  Plug 'junegunn/vim-easy-align'
  Plug 'mileszs/ack.vim'
  Plug 'preservim/nerdcommenter'
  Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
  Plug 'tpope/vim-endwise'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rvm'
  Plug 'tpope/vim-surround'
  Plug 'wincent/command-t'

  " Themes
  Plug 'dracula/vim', { 'as': 'dracula' }

  " highlighters/syntax
  Plug 'briancollins/vim-jst'
  Plug 'octol/vim-cpp-enhanced-highlight'
  Plug 'pangloss/vim-javascript'
  Plug 'posva/vim-vue'
  Plug 'tpope/vim-rails'
  Plug 'vim-ruby/vim-ruby'
  Plug 'vim-scripts/indentpython.vim'
" Initialize plugin system
call plug#end()

"Plugin configurations
let g:CommandTMaxFiles=80085
let g:buffergator_suppress_keymaps=1
let g:ack_default_options = " -s -H --nocolor --nogroup --column --ignore-dir={data,log,tmp,node_modules,dist} --ignore-dir={public/app/packs,public/account/packs,public/app/packs-test}"

let g:python_host_prog='/usr/bin/python2.7'
let g:python3_host_prog='/usr/bin/python3'
let g:ale_fixers = {
      \ 'javascript': ['eslint'],
      \ 'ruby': ['rubocop']
      \ }
let g:ale_sign_error = '❌'
let g:ale_sign_warning = '⚠️'
let g:ale_fix_on_save = 1

syntax on
filetype plugin indent on

colorscheme dracula

let mapleader=','

" Shortcuts
noremap <leader>t :CommandT<CR>
noremap <leader>sd :NERDTree<CR>
nmap <silent> ,/ :let @/=""<CR>
nnoremap <silent> <Leader>b :BuffergatorOpen<CR>
nnoremap <silent> <Leader>B :BuffergatorClose<CR>
nnoremap <silent> <Leader>bt :BuffergatorTabsOpen<CR>
nnoremap <silent> <Leader>BT :BuffergatorTabsClose<CR>


" Custom Scripts

" Strip trailing whitespace (,ss)
function! StripWhiteSpace ()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    :%s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhiteSpace ()<CR>
au BufWrite *.rb,*.coffee,*.scss :call StripWhiteSpace()

"TODO: Move to a function to detect current version, if already default, do
"nothing.
autocmd VimEnter * Rvm use default

" Pretty XML
function! DoPrettyXML()
  " save the filetype so we can restore it later
  let l:origft = &ft
  set ft=
  " delete the xml header if it exists. This will
  " permit us to surround the document with fake tags
  " without creating invalid xml.
  1s/<?xml .*?>//e
  " insert fake tags around the entire document.
  " This will permit us to pretty-format excerpts of
  " XML that may contain multiple top-level elements.
  0put ='<PrettyXML>'
  $put ='</PrettyXML>'
  silent %!xmllint --format -
  " xmllint will insert an <?xml?> header. it's easy enough to delete
  " if you don't want it.
  " delete the fake tags
  2d
  $d
  " restore the 'normal' indentation, which is one extra level
  " too deep due to the extra tags we wrapped around the document.
  silent %<
  " back to home
  1
  " restore the filetype
  exe "set ft=" . l:origft
endfunction
command! PrettyXML call DoPrettyXML()
noremap <leader>pxml :call DoPrettyXML()<CR>

" Pretty JSON
function! DoPrettyJSON()
  silent %!python2.7 -m json.tool
endfunction
command! PrettyJSON call DoPrettyJSON()
noremap <leader>pjs :call DoPrettyJSON()<CR>

" Pretty CSS
command! PrettyCSS :%s/[{;}]/&\r/g|norm! =gg
