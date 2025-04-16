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
set wildignore=*/app/assets/images/*,*/log/*,*/tmp/*,*/public/assets/*,*/public/course-data/*,*/public/system/*,*/public/api/v1/system/*,*/data/course-data/*,*/data/shared/*,.DS_Store,*/node_modules/*,public/app/packs/js/*
set wildignore+=*.png,*.jpg,*.gif,*.jpeg,*.svg

filetype off

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin("~/.vim/plugged")
  Plug 'Yggdroot/indentLine'
  Plug 'airblade/vim-gitgutter'
  Plug 'dense-analysis/ale'
  Plug 'ervandew/supertab'
  Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
  Plug 'hashivim/vim-terraform'
  Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
  Plug 'iamcco/mathjax-support-for-mkdp'
  Plug 'jeetsukumaran/vim-buffergator'
  Plug 'kchmck/vim-coffee-script'
  Plug 'mileszs/ack.vim'
  Plug 'pangloss/vim-javascript'
  Plug 'pedrohdz/vim-yaml-folds'
  Plug 'posva/vim-vue'
  Plug 'preservim/nerdcommenter'
  Plug 'preservim/nerdtree'
  Plug 'robitx/gp.nvim'
  Plug 'tpope/vim-endwise'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rails'
  Plug 'tpope/vim-rbenv'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-python/python-syntax'
  Plug 'vim-ruby/vim-ruby'
  Plug 'wincent/command-t'

  " Themes
  Plug 'maxmx03/dracula.nvim'
  Plug 'EdenEast/nightfox.nvim'
call plug#end()

syntax on
filetype plugin indent on

"Plugin configurations
colorscheme nordfox
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_fixers = {
\   'javascript': ['eslint'],
\   'ruby': ['rubocop']
\ }
let g:ale_linters = {
\   'javascript': ['eslint'],
\   'python': ['flake8','black'],
\   'ruby': ['rubocop','ruby'],
\   'dockerfile': ['dockerfile_lint', 'dockerlinter', 'hadolint']
\ }
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_save = 1
let b:ale_fix_on_save = 0
let g:ale_set_highlights = 0 " Disable highligting

highlight ALEWarning ctermbg=DarkMagenta
highlight ALEError ctermbg=DarkMagenta

highlight ALEError ctermbg=none cterm=underline
highlight ALEWarning ctermbg=none cterm=underline

let g:ack_default_options = " -s -H --nocolor --nogroup --column --ignore-dir={data,log,tmp,node_modules,dist} --ignore-dir={public/app/packs,public/account/packs,public/app/packs-test}"
let g:buffergator_suppress_keymaps = 1

let g:indentLine_char = '⦙'
let g:vim_json_conceal = 0
let g:markdown_syntax_conceal=0

let g:CommandTMaxFiles = 80085
let g:CommandTPreferredImplementation='lua'

let otl_map_tabs = 1
let otl_install_menu=1
let no_otl_maps=0
let no_otl_insert_maps=0

let mapleader=','

"NERDCommenter
let g:NERDCreateDefaultMappings = 1
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1

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

" Autoset ruby to 3.3.7 for command-t
autocmd VimEnter * Rbenv shell 3.3.7

" YAML 2 space indentation
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

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
  silent %!python3 -m json.tool
endfunction
command! PrettyJSON call DoPrettyJSON()

" Pretty CSS
command! PrettyCSS :%s/[{;}]/&\r/g|norm! =gg

" Lua Conf
lua << EOF
  -- Config for Gp.nvim
  -- https://github.com/Robitx/gp.nvim/blob/8dd99d85adfcfcb326f85a1f15bcd254f628df59/lua/gp/config.lua#L10-L627
  local config = {
    -- configure provider
    -- openai_api_key = os.getenv("OPENAI_API_KEY"),
    providers = {
      anthropic = {
        disable = true,
        endpoint = "https://api.anthropic.com/v1/messages",
        secret = os.getenv("ANTHROPIC_API_KEY"),
      },
      openai = {
        disable = true,
        endpoint = "https://api.openai.com/v1/chat/completions",
        secret = os.getenv("OPENAI_API_KEY"),
      },
      ollama = {
        endpoint = "http://localhost:11434/v1/chat/completions",
      },
    },
    agents = {
      {
        provider = "ollama",
        name = "ChatOllamaLlama3.2B",
        chat = true,
        command = false,
        -- string with model name or table with model name and parameters
        model = {
          model = "llama3.2",
          temperature = 0.6,
          top_p = 1,
          min_p = 0.05,
        },
        -- system prompt (use this to specify the persona/role of the AI)
        system_prompt = "You are a general AI assistant.",
      },
      {
        provider = "ollama",
        name = "CodeOllamaLlama3.2B",
        chat = false,
        command = true,
        -- string with model name or table with model name and parameters
        model = {
          model = "llama3.2",
          temperature = 0.4,
          top_p = 1,
          min_p = 0.05,
        },
        -- system prompt (use this to specify the persona/role of the AI)
        system_prompt = require("gp.defaults").code_system_prompt,
      },
    },
  }

  require("gp").setup(config)
EOF
