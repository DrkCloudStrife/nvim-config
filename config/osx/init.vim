set autoindent
set clipboard=unnamed
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

"Plugin configurations
set wildignore=*/app/assets/images/*,*/log/*,*/tmp/*,*/public/assets/*,*/public/course-data/*,*/public/system/*,*/public/api/v1/system/*,*/data/course-data/*,*/data/shared/*,.DS_Store,*/node_modules/*,public/app/packs/js/*
set wildignore+=*.png,*.jpg,*.gif,*.jpeg,*.svg

let g:CommandTMaxFiles=80085
let g:buffergator_suppress_keymaps=1
let g:ack_default_options = " -s -H --nocolor --nogroup --column --ignore-dir={data,log,tmp,node_modules,dist} --ignore-dir={public/app/packs,public/account/packs,public/app/packs-test}"

filetype off

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin("~/.vim/plugged")
  Plug 'airblade/vim-gitgutter'
  Plug 'dense-analysis/ale'
  Plug 'dracula/vim',{ 'name': 'dracula' }
  Plug 'ervandew/supertab'
  Plug 'jeetsukumaran/vim-buffergator'
  Plug 'kchmck/vim-coffee-script'
  Plug 'mileszs/ack.vim'
  Plug 'posva/vim-vue'
  Plug 'pangloss/vim-javascript'
  Plug 'preservim/nerdcommenter'
  Plug 'preservim/nerdtree'
  Plug 'tpope/vim-endwise'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rails'
  Plug 'tpope/vim-rbenv'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-ruby/vim-ruby'
  Plug 'wincent/command-t'
call plug#end()

let g:ale_fixers = {
      \ 'javascript': ['eslint'],
      \ 'ruby': ['rubocop']
      \ }
let g:ale_sign_error = '❌'
let g:ale_sign_warning = '⚠️'
let g:ale_fix_on_save = 1

syntax on
filetype plugin indent on

let otl_map_tabs = 1
let otl_install_menu=1
let no_otl_maps=0
let no_otl_insert_maps=0

let mapleader=','

noremap <leader>t :CommandT<CR>
noremap <leader>sd :NERDTree<CR>
noremap <leader>sf :Sex<CR>
nmap <silent> ,/ :let @/=""<CR>

noremap <Leader>vm :RVmodel <CR>
noremap <Leader>vc :RVcontroller <CR>
noremap <Leader>vv :RVview <CR>
noremap <Leader>vu :RVunittest <CR>
noremap <Leader>vM :RVmigration <CR>
noremap <Leader>vs :RVspec <CR>
noremap <Leader>rf :Rfind
nnoremap <silent> <Leader>b :BuffergatorOpen<CR>
nnoremap <silent> <Leader>B :BuffergatorClose<CR>
nnoremap <silent> <Leader>bt :BuffergatorTabsOpen<CR>
nnoremap <silent> <Leader>BT :BuffergatorTabsClose<CR>

" FUNCTIONS
" =========

" Autoset ruby to 3.0.2 for command-t
autocmd VimEnter * Rbenv shell 3.0.2

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
au BufReadPost *.json.jb set syntax=ruby

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

" Pretty JSON
function! DoPrettyJSON()
  silent %!python2.7 -m json.tool
endfunction
command! PrettyJSON call DoPrettyJSON()

" Pretty CSS
command! PrettyCSS :%s/[{;}]/&\r/g|norm! =gg
