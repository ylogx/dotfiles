" Formatting {
    set number  " Alternative: set nu!
    set hlsearch    " Highlight searched item
    set nowrap                      " wrap long lines
    set autoindent                  " indent at the same level of the previous line
    set shiftwidth=4                " use indents of 4 spaces
    set expandtab                   " tabs are spaces, not tabs
    set tabstop=4                   " an indentation every four columns
    set softtabstop=4               " let backspace delete indent
    "set matchpairs+=<:>                " match, to be used with % 
    set pastetoggle=<F10>           " pastetoggle (sane indentation on pastes)
    "set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks
    " Remove trailing whitespaces and ^M chars
    autocmd FileType c,cpp,java,php,js,python,twig,xml,yml autocmd BufWritePre <buffer> :call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))
" }



" General {
    set tags=./tags,tags,./TAGS,TAGS,~/tags,~/.tags     " Exuberent ctags
    " Move to a given tag
    map <C-y> g<C-]>
    " set background=dark         " Assume a dark background
    " if !has('win32') && !has('win64')
    "     set term=$TERM       " Make arrow and other keys work
    " endif
    let c_space_errors=1    " Show error if space left at end of line
    filetype plugin indent on   " Automatically detect file types.
    syntax on                   " syntax highlighting
    set mouse=a                 " automatically enable mouse usage
    "set autochdir              " always switch to the current file directory.. Messes with some plugins, best left commented out
    " not every vim is compiled with this, use the following line instead
    " If you use command-t plugin, it conflicts with this, comment it out.
     "autocmd BufEnter * if bufname("") !~ ^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
    "scriptencoding utf-8
    set ic " Ignore case in search

    " set autowrite                  " automatically write a file when leaving a modified buffer
    "set shortmess+=filmnrxoOtT      " abbrev. of messages (avoids 'hit enter')
    "set viewoptions=folds,options,cursor,unix,slash " better unix / windows compatibility
    set virtualedit=onemore         " allow for cursor beyond last character
    "set history=1000                " Store a ton of history (default is 20)
    "set spell                       " spell checking on
    
    " Setting up the directories {
        "set backup                      " backups are nice ...
        " Moved to function at bottom of the file
        "set backupdir=$HOME/.vimbackup//  " but not when they clog .
        "set directory=$HOME/.vimswap//     " Same for swap files
        "set viewdir=$HOME/.vimviews//  " same for view files
        
        "" Creating directories if they don't exist
        "silent execute '!mkdir -p $HVOME/.vimbackup'
        "silent execute '!mkdir -p $HOME/.vimswap'
        "silent execute '!mkdir -p $HOME/.vimviews'
        "au BufWinLeave * silent! mkview  "make vim save view (state) (folds, cursor, etc)
        "au BufWinEnter * silent! loadview "make vim load view (state) (folds, cursor, etc)
    " }
" }

" Commenting blocks of code.
autocmd FileType c,cpp,java,scala let b:comment_leader = '// '
autocmd FileType sh,ruby,python   let b:comment_leader = '# '
autocmd FileType conf,fstab       let b:comment_leader = '# '
autocmd FileType tex              let b:comment_leader = '% '
autocmd FileType mail             let b:comment_leader = '> '
autocmd FileType vim              let b:comment_leader = '" '
noremap <silent> ,cc :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
noremap <silent> ,cx :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>


" Key (re)Mappings {

    "The default leader is '\', but many people prefer ',' as it's in a standard
    "location
    "let mapleader = ','
    
" Making it so ; works like : for commands. Saves typing and eliminates :W style typos due to lazy holding shift.
    "nnoremap ; :


    " Easier moving in tabs and windows
    "map <C-J> <C-W>j<C-W>_
    "map <C-K> <C-W>k<C-W>_
    "map <C-L> <C-W>l<C-W>_
    "map <C-H> <C-W>h<C-W>_
    "map <C-K> <C-W>k<C-W>_
    
    " Wrapped lines goes down/up to next row, rather than next line in file.
    "nnoremap j gj
    "nnoremap k gk

    " The following two lines conflict with moving to top and bottom of the
    " screen
    " If you prefer that functionality, comment them out.
    "map <S-H> gT          
    "map <S-L> gt

    " Stupid shift key fixes
"    cmap W w
    cmap WQ wq
    cmap wQ wq
"    cmap Q q
    " Change Working Directory to that of the current file
    "cmap cwd lcd %:p:h
    "cmap cd. lcd %:p:h
" }

"{{{2 Visual Cues
" A problem that plagued me for months, having visual cues for white spacing
" solves formatting problems a lot quicker. Also, we're using modern shells
" (right?) so using UTF-8 characters for symbols should be a given.
set fillchars=diff:⣿,vert:│
set guifont=monoOne\ 9

" A visual cue for line-wrapping.
set showbreak=↪

" Visual cues when in 'list' model.
"set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮,trail:·,nbsp:×
set listchars=tab:▸\ ,extends:❯,precedes:❮,trail:·,nbsp:×

" Show me these markings.
set list

" Update by redraw and not INS/DEL
set ttyscroll=3
set nottyfast

" Show me what I was doing.
set showcmd
set showfulltag

" Ensures that local tags are loaded into the mix.
function! s:load_local_tags()
  setl tags+=$PWD/.tags
  setl tags+=$PWD/TAGS,
  setl tags+=$PWD/tags
  setl tags+=$PWD/.bzr/tags
  setl tags+=$PWD/.git/tags
  setl tags+=$PWD/.svn/tags
  setl tags+=$PWD/.hg/tags
  setl tags+=$PWD/build/tags
endfunction

let g:tagbar_type_markdown = {
      \ 'ctagstype' : 'markdown',
      \ 'kinds' : [
      \ 'h:Heading_L1',
      \ 'i:Heading_L2',
      \ 'k:Heading_L3'
      \ ]
      \ }

" Improve C++ matching.
let g:tagbar_type_cpp = {
      \ 'kinds' : [
      \ 'd:macros:1:0',
      \ 'p:prototypes:1:0',
      \ 'g:enums',
      \ 'e:enumerators:0:0',
      \ 't:typedefs:0:0',
      \ 'n:namespaces',
      \ 'c:classes',
      \ 's:structs',
      \ 'u:unions',
      \ 'f:functions',
      \ 'm:members:0:0',
      \ 'v:variables:0:0',
      \ ],
      \ }

" Make sure we use CoffeTags, shun.
let g:tagbar_type_coffee = {
      \ 'ctagsbin' : 'coffeetags',
      \ 'ctagsargs' : '',
      \ 'kinds' : [
      \ 'f:functions',
      \ 'o:object',
      \ ],
      \ 'sro' : ".",
      \ 'kind2scope' : {
      \ 'f' : 'object',
      \ 'o' : 'object',
      \ }
      \ }

