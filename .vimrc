" ----------------- SETS ------------------
set nocompatible

syntax enable

set path+=**
set wildmenu
set wildmode=list,full
set wildignore=*.o,*.bin,*.tmp,*.dylib,*.lock,*.timestamp,*.gz

set hidden

set nu
set relativenumber

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

set smartindent

set nowrap

set noswapfile
set nobackup
set undodir=~/.vim/undodir.vim
set undofile

set nohlsearch
set incsearch
set ignorecase
set smartcase

set scrolloff=8
set signcolumn=auto

set updatetime=50

" set colorcolumn=80

set laststatus=2
set statusline=%!CustomStatusLine()


" ----------------- REMAPS ------------------
let g:mapleader=' '

inoremap ` <esc>:echo "Use Shift+` for a tick (`)"<CR>
inoremap ¬ `
nnoremap ` <esc>:echo "Use Shift+` for a tick (`)"<CR>
nnoremap ¬ `
vnoremap ` <esc>:echo "Use Shift+` for a tick (`)"<CR>
vnoremap ¬ `
cnoremap ` <esc>:echo "Use Shift+` for a tick (`)"<CR>
cnoremap ¬ `
snoremap ` <esc>:echo "Use Shift+` for a tick (`)"<CR>
snoremap ¬ `
xnoremap ` <esc>:echo "Use Shift+` for a tick (`)"<CR>
xnoremap ¬ `


" Move lines up and down in visual mode
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Keep cursor in the middle when iterating over search terms
nnoremap n nzzzv
nnoremap N Nzzzv

nnoremap Q <nop>

" Find files and buffers
nnoremap <leader>ff :find *
nnoremap <leader>fb :buffer *

" Navigate through buffers
nnoremap <leader>b :ls<CR>:b<space>
nnoremap <C-Tab> :bnext<CR>

" Open a file browser
nnoremap <C-n> :call ToggleCustomFileTree()<CR>

" Toggle the terminal
nnoremap <C-j> :call ToggleCustomTerminalWindow()<CR>
tnoremap <C-j> <C-w>:call ToggleCustomTerminalWindow()<CR>

" ------------------- WINDOW NAVIGATION -------------------
nnoremap <C-h> <C-w><C-h>
nnoremap <C-l> <C-w><C-l>
" nnoremap <C-k> <C-w><C-k>   -- disabled vertical switch as <C-j> opens term
" nnoremap <C-j> <C-w><C-j>   -- disabled vertical switch as <C-j> opens term


" -------------------- FILE BROWSING ----------------------
let g:netrw_banner=0              " disable annoying banner
let g:netrw_browse_split=4        " open in prior window
let g:netrw_altv=1                " open splits to the right
let g:netrw_liststyle=3           " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

let g:custom_file_tree_win_open = 0
function ToggleCustomFileTree()
    if (g:custom_file_tree_win_open == 0)
        let g:custom_file_tree_prev_win = winnr()
        :1wincmd W
        vsp
        vert res 25
        edit .
        let g:custom_file_tree_win_open = 1
    else
        if (winnr() > 1)
            let g:custom_file_tree_prev_win = winnr() - 1
        endif
        :1quit
        exe g:custom_file_tree_prev_win .. "wincmd w"
        let g:custom_file_tree_win_open = 0
    endif
endfunction

function! NetrwMapping()
    nmap <buffer> o <CR>
endfunction

augroup netrw_mapping
  autocmd!
  autocmd filetype netrw call NetrwMapping()
augroup END


" -------------------------- TERMINAL -------------------------
let g:custom_terminal_win_open = 0
function ToggleCustomTerminalWindow()
    if (g:custom_terminal_win_open == 0)
        let g:custom_terminal_win_open = 1
        term ++curwin
    else
        let g:custom_terminal_win_open = 0
        exe "bd!"
    endif
endfunction


" ------------------------- STATUS LINE ------------------------
function! CustomStatusLine()
    let l:mode = mode()
    if (l:mode == 'n')
        let l:mode = 'NORMAL'
    elseif (l:mode == 'i')
        let l:mode = 'INSERT'
    elseif (l:mode == 'R')
        let l:mode = 'REPLACE'
    elseif (l:mode == 'c')
        let l:mode = 'COMMAND'
    elseif (l:mode == 'v')
        let l:mode = 'VISUAL'
    elseif (l:mode == 'V')
        let l:mode = 'VISUAL-LINE'
    elseif (l:mode == '^V')
        let l:mode = 'VISUAL-BLOCK'
    elseif (l:mode == 't')
        let l:mode = 'TERMINAL'
    endif

    if (has('unix') == 1)
        if (has('macunix') == 1)
            let l:system = ' | MacOS'
        else
            let l:system = ' | Linux'
        endif
    elseif (has('win32') == 1 || has('win16') == 1 || has('win64') == 1 || has('win95') == 1)
        let l:system = ' | Windows'
    else
        let l:system = ''
    endif

    if (&filetype != '')
        let l:filetype = ' | ' . &filetype
    else
        let l:filetype = ''
    endif

    return '%( ' . l:mode . ' | buffer #%n: %f %m %r%) %= %(' . &fileencoding . l:system . l:filetype . ' | %p%% | %l:%c %)'
endfunction
