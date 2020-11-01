let mapleader = "\<Space>"

set nocompatible
filetype off

call plug#begin('~/.vim/plugged')

" Essential plugins
Plug 'itchyny/lightline.vim'
Plug 'jnurmine/Zenburn'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-session'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'jiangmiao/auto-pairs'
Plug 'mcchrish/nnn.vim'

" Nerdtree
" Plug 'preservim/nerdtree'

" Semantic language support
" use coc release branch (recommend)
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Fuzzy finder
Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Syntactic language support
Plug 'cespare/vim-toml'
Plug 'stephpy/vim-yaml'
Plug 'rust-lang/rust.vim'
Plug 'dag/vim-fish'
Plug 'vim-ruby/vim-ruby'

" Git
Plug 'tpope/vim-fugitive'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'airblade/vim-gitgutter'

call plug#end()

let g:gitgutter_sign_added = '✚'
let g:gitgutter_sign_modified = '✹'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_removed_first_line = '-'
let g:gitgutter_sign_modified_removed = '-'

" Open nnn in a floating window
let g:nnn#layout = {'window': { 'width': 0.9, 'height': 0.6, 'highlight': 'Debug' }}

let g:NERDTreeGitIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }

let g:lightline = {
	\ 'active': {
	\	'left': [ [ 'mode', 'paste' ],
	\			  [ 'gitbranch', 'fugitive', 'readonly', 'filename', 'modified', 'cocstatus'] ]
	\ },
	\ 'component_function': {
	\	'filename': 'LightlineFilename',
	\	'cocstatus': 'coc#status'
	\ },
	\ 'compnent_function': {
	\	'fugitive': 'LightlineFugitive',
	\ },
	\ 'colorscheme': 'seoul256',
	\ }
function! LightlineFilename()
	return expand('%:t') !=# '' ? @% : '[No Name]'
endfunction

function! LightlineFugitive() abort
  if &filetype ==# 'help'
    return ''
  endif
  if has_key(b:, 'lightline_fugitive') && reltimestr(reltime(b:lightline_fugitive_)) =~# '^\s*0\.[0-5]'
    return b:lightline_fugitive
  endif
  try
    if exists('*fugitive#head')
      let head = fugitive#head()
    else
      return ''
    endif
    let b:lightline_fugitive = head
    let b:lightline_fugitive_ = reltime()
    return b:lightline_fugitive
  catch
  endtry
  return ''
endfunction

" Ruby support
let g:coc_global_extensions = ['coc-solargraph']
"Use autocmd to force lightline update.
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

" from http://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/
if executable('ag')
	set grepprg=ag\ --nogroup\ --nocolor
endif
if executable('rg')
	set grepprg=rg\ --no-heading\ --vimgrep
	set grepformat=%f:%l:%c:%m
endif

" Open hotkeys
nmap <leader>; :Buffers<CR>
map <C-p> :Files<CR>

" More hotkeys
nnoremap <leader>sv :source $MYVIMRC<CR>
nnoremap <leader>w :w<CR>
nmap <Leader><Leader> V
map <C-n> :NERDTreeToggle<CR>

" Completion
" Better display for messages
set cmdheight=2

set updatetime=300

" =======================================
" Editor settings
" =======================================

filetype plugin indent on
syntax enable

set completeopt=menuone,noinsert,noselect
set timeoutlen=300
set encoding=utf-8
set scrolloff=2
set noshowmode
set hidden
set nowrap
set nojoinspaces
set number
set signcolumn=yes
set autoread

" Sane splits (whatever that means?)
set splitright
set splitbelow

" Permanent undo
set undodir=~/.vimdid
set undofile

set tabstop=8
set noexpandtab
set shiftwidth=4
set autoindent
set smartindent
set cindent
set softtabstop=4

" Proper search
set incsearch
set ignorecase
set smartcase
set gdefault

" =======================================
" GUI settings
" =======================================
set backspace=2
set laststatus=2

set colorcolumn=120
set showcmd
set shortmess+=c

" set listchars=nbsp:,extends:,precedes:,trail:

" Jump to start and end of line using the home row keys
map H ^
map L $

" X clip integration
" ,p will paste clipboard into buffer
" ,c will copy entire buffer into clipboard
noremap <leader>p :read !xsel --clipboard --output<cr>
noremap <leader>c :w !xsel -ib<cr><cr>

" Open a new file adjacent to current file
nnoremap <leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" Left and right can switch buffers
nnoremap <left> :bp<cr>
nnoremap <right> :bn<cr>

" ===================================================
" 'Smart' navigation
" Use tab for trigger completion with characters ahead and navigate
inoremap <silent><expr> <TAB>
	\ pumvisible() ? "\<C-n>" :
	\ <SID>check_back_space() ? "\<TAB>" :
	\ coc#refresh()

function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col -1] =~# '\s'
endfunction

" Use <cr> to confirm completion, `<C-g>u` means break undo at current
" position. Coc only does snippet and additional edit on confirm.
if exists('*complete_info')
	inoremap <expr><cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
	imap <expr><cr> pumvisible() ? "\<C-y>" | "\<C-g>u\<CR>"
endif

" Use <c-.> to trigger completion
inoremap <silent><expr> <c-.> coc#refresh()

" use [g and ]g to naviagate diagnostics
nmap <silent> [g <Plug>(coc-diagnostics-prev)
nmap <silent> ]g <Plug>(coc-diagnostics-next)

" Goto code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation preview in window.
nnoremap <silent> K :call <SID>show_documentation()<cr>

function! s:show_documentation()
	if (index(['vim','help'], &filetype) >= 0)
		execute 'h '.expand('<cword>')
	else
		call CocAction('doHover')
	endif
endfunction

" Highlight the symbol and its references when holding the cursore.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f <Plug>(coc-format-selected)
nmap <leader>f <Plug>(coc-format-selected)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')
" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language
" server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for selections ranges.
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

" Find symbol of current document
nnoremap <silent><space>o :<C-u>CocList outline<cr>

" Search workspace symbols
nnoremap <silent><space>o :<C-u>CocList -I symbols<cr>

" Implement methods for trait
nnoremap <silent><space>i :call CocActionsAsync('codeAction', '', 'Implement missing members')<cr>

" Show actions available at this location
nnoremap <silent><space>a :CocAction<cr>



" Follow Rust code style guide
au Filetype rust source ~/.config/nvim/scripts/spacetab.vim
au Filetype rust set colorcolumn=100

" NERDTreeToggle stuff
"
map <C-n> :NERDTreeToggle<cr>

" Close vim if only window left is NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTvueeDirArrowCollapsible = '▾'
colorscheme zenburn

