" ###########################################
" KEYBINDINGS AND OTHER SETTINGS
" ###########################################

" General Vim settings
set number
set wrap
set encoding=utf-8
set wildmenu
set lazyredraw
set ruler
set tabstop=4
set shiftwidth=4
set showmatch
set expandtab
set softtabstop=4
set autoindent
set smartindent

" Keybindings
inoremap jk <ESC>

" Search Settings
" show search results while typing
set incsearch
" highlight search results while typing
set hlsearch

"" Auto Strip Trailing Spaces
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

" Apply to all files by default
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

" Syntax highlighting
syntax on
filetype plugin indent on
set mouse=a
set mousehide

if exists('g:vscode')
  xmap gc <Plug>VSCodeCommentary
  nmap gc <Plug>VSCodeCommentary
  omap gc <Plug>VSCodeCommentary
  nmap gcc <Plug>VSCodeCommentaryLine
endif

set clipboard=unnamed

set backup
set undofile
set undolevels=1000
set undoreload=10000

let mapleader =','

function! InitializeDirectories()
    let parent = $HOME
    let prefix = 'vim'
    let dir_list = {
                \ 'backup': 'backupdir',
                \ 'views': 'viewdir',
                \ 'swap': 'directory' }

    if has('persistent_undo')
        let dir_list['undo'] = 'undodir'
    endif

    " To specify a different directory in which to place the vimbackup,
    " vimviews, vimundo, and vimswap files/directories, add the following to
    " your .vimrc.before.local file:
    "   let g:spf13_consolidated_directory = <full path to desired directory>
    "   eg: let g:spf13_consolidated_directory = $HOME . '/.vim/'
    if exists('g:spf13_consolidated_directory')
        let common_dir = g:spf13_consolidated_directory . prefix
    else
        let common_dir = parent . '/.' . prefix
    endif

    for [dirname, settingname] in items(dir_list)
        let directory = common_dir . dirname . '/'
        if exists("*mkdir")
            if !isdirectory(directory)
                call mkdir(directory)
            endif
        endif
        if !isdirectory(directory)
            echo "Warning: Unable to create backup directory: " . directory
            echo "Try: mkdir -p " . directory
        else
            let directory = substitute(directory, " ", "\\\\ ", "g")
            exec "set " . settingname . "=" . directory
        endif
    endfor
endfunction
call InitializeDirectories()

