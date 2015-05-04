"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vundle {
    " This must be first, because it changes other options as a side effect.
    set nocompatible               " be iMproved
    filetype off                   " required!

    set rtp+=~/.vim/bundle/vundle/  " set runtimepath
    call vundle#rc()

    " let Vundle manage Vundle
    " required!
    Plugin 'gmarik/vundle'

    " My Bundles here:
    " Original repos on github
    "
    " Git wrapper
    Plugin 'tpope/vim-fugitive'
    Plugin 'Lokaltog/vim-easymotion'
    " Compile and find error
    Plugin 'scrooloose/syntastic'
    " Auto complete
    Plugin 'Shougo/neocomplcache.vim'
    " Tree mapped below at <F9>
    Plugin 'scrooloose/nerdtree'
    " ys, cs, ds surround with brackets and shit
    Plugin 'tpope/vim-surround'
    " Read tags and highlighten them
    " Plugin 'skroll/vim-taghighlight'
    " Plugin 'vim-scripts/TagHighlight'
    Plugin 'abudden/taghighlight-automirror'
    " Abreviate :Abolish {despa,sepe}rat{e,es,ed,ing,ely,ion,ions,or} {despe,sepa}rat{},
    " Substitute :%Subvert/child{,ren}/adult{,s}/g,
    " Coercion crs, crm
    Plugin 'tpope/vim-abolish'
    " <Leader>cc <Leader>c<space>
    Plugin 'scrooloose/nerdcommenter'
    " gcc, gc, gcmotion, gcvisual, :g/TODO/Commentary
    " Plugin 'tpope/vim-commentary'
    " <F5> to show undo/redo tree
    Plugin 'sjl/gundo.vim'
    " <F9> to show tagbar
    Plugin 'majutsushi/tagbar'
    " Better Status line
    Plugin 'bling/vim-airline'
    " Ruby on Rails plugin
    Plugin 'tpope/vim-rails'
    " sleuth.vim: Heuristically set buffer options like shiftwidth, expandtab...
    Plugin 'tpope/vim-sleuth'
    " Show python code coverage
    Plugin 'alfredodeza/coveragepy.vim'
    "Plugin ''

    " Enable file type detection. Do this after Vundle calls.
" }

" Pathogen {
    " call pathogen#runtime_append_all_bundles()
    " call pathogen#incubate()
    " call pathogen#helptags()
" }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Formatting {
    set backspace=2                " To make backspace work like all other apps
    "set backspace=indent,eol,start
    set number  " Alternative: set nu!
    set relativenumber " Show line numbers relative to cursor line
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
    autocmd FileType c,cpp,java,php,js,python,twig,vim,xml,yml,matlab autocmd BufWritePre <buffer> :call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))

    set modeline
    set modelines=10    " Search 10 lines from top and bottom for modelines
    set textwidth=79
    set colorcolumn=+1  " i.e textwidth+1
    " Change column color from red to greyish
    highlight ColorColumn ctermbg=233

    " Don't lose selection when indenting with visual selection
    vnoremap < <gv
    vnoremap > >gv

    " Reformatt the entire file and return back to mark (z) here
    map <F7> mzgg=G`z<CR>
    " use 256 colors in Console mode if we think the terminal supports it
    if &term =~? 'mlterm\|xterm'
        set t_Co=256
    endif
" }


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General {
" Automatic reloading of .vimrc file
    autocmd! BufWritePost .vimrc source %
    " allow saving as sudo if opened not as sudo
    cmap w!! w !sudo tee > /dev/null %

    "set tags=./tags,tags,./TAGS,TAGS,~/tags,~/.tags     " Exuberent ctags
    set tags=./tags;/,./TAGS;/,./.tags;/,./.TAGS;/     " Exuberent ctags
    " Move to a given tag " Note: C-t is for moving back in tagstack
    map <C-y> g<C-]>

    set undofile
    set undodir=~/.vimundo
    "set background=dark         " Assume a dark background
    "if !has('win32') && !has('win64')
    "    set term=$TERM       " Make arrow and other keys work
    "endif
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

    "set autowrite                  " automatically write a file when leaving a modified buffer
    "set shortmess+=filmnrxoOtT      " abbrev. of messages (avoids 'hit enter')
    "set viewoptions=folds,options,cursor,unix,slash " better unix / windows compatibility
    set virtualedit=onemore         " allow for cursor beyond last character
    set history=10000                " Store a ton of history (default is 20)
    "set spell                       " spell checking on

    " Setting up the directories {
        set backup                      " backups are nice ...
        " Moved to function at bottom of the file
        "set backupdir=$HOME/.vimbackup//  " but not when they clog .
        "set directory=$HOME/.vimswap//     " Same for swap files
        "set viewdir=$HOME/.vimviews//  " same for view files

        " backup to ~/.tmp
        set backupdir=~/.vimbackup,~/.tmp,~/tmp,/var/tmp,/tmp
        set backupskip=/tmp/*,/private/tmp/*
        set directory=~/.vimswap,~/.tmp,~/tmp,/var/tmp,/tmp
        set writebackup

        "" Creating directories if they don't exist
        "silent execute '!mkdir -p $HVOME/.vimbackup'
        "silent execute '!mkdir -p $HOME/.vimswap'
        "silent execute '!mkdir -p $HOME/.vimviews'
        "au BufWinLeave * silent! mkview  "make vim save view (state) (folds, cursor, etc)
        "au BufWinEnter * silent! loadview "make vim load view (state) (folds, cursor, etc)
    " }
" }



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Commenting blocks of code {
    autocmd FileType c,cpp,java,scala       let b:comment_leader = '// '
    autocmd FileType sh,ruby,python,perl    let b:comment_leader = '# '
    autocmd FileType conf,fstab             let b:comment_leader = '# '
    autocmd FileType tex,matlab             let b:comment_leader = '% '
    autocmd FileType mail                   let b:comment_leader = '> '
    autocmd FileType vim                    let b:comment_leader = '" '
    " noremap <silent> ,cc :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
    " noremap <silent> ,cx :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>
" }



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Key (re)Mappings {

    " Easily move between splits
    nnoremap <C-h> <C-w>h
    nnoremap <C-j> <C-w>j
    nnoremap <C-k> <C-w>k
    nnoremap <C-l> <C-w>l

    " Clear search highlights
    "noremap <silent><Leader>h :nohls<CR> " Done below map <leader>r :SyntasticReset<CR> :nohls<CR>

    " Sane regex
    "nnoremap / /\v
    "vnoremap / /\v

    "The default leader is '\', but many people prefer ',' as it's in a standard
    "location
    let mapleader = ','

    " Making it so ; works like : for commands. Saves typing and eliminates :W style typos due to lazy holding shift.
    "nnoremap ; :


    " Easier moving in tabs and windows
    map <C-J> <C-W>j<C-W>_
    map <C-K> <C-W>k<C-W>_
    map <C-L> <C-W>l<C-W>_
    map <C-H> <C-W>h<C-W>_

    " Wrapped lines goes down/up to next row, rather than next line in file.
    "nnoremap j gj
    "nnoremap k gk

    " The following two lines conflict with moving to top and bottom of the
    " screen
    " If you prefer that functionality, comment them out.
    "map <S-H> gT
    "map <S-L> gt

    " Stupid shift key fixes
    "cmap W w
    cmap WQ wq
    cmap wQ wq
    "cmap Q q
    " Change Working Directory to that of the current file
    "cmap cwd lcd %:p:h
    "cmap cd. lcd %:p:h
" }



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Visual Cues {
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
"}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Airline plugin {
    "set t_Co=256 "set t_AB=[[48;5;%dm "set t_AF=[[38;5;%dm
    set laststatus=2
    let g:airline_powerline_fonts = 1
"}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntastic Plugin {
    map <leader>r :SyntasticReset<CR> :nohls<CR>
    "map <leader>sr :SyntasticReset<CR>
    " Make C++11 work
    let g:syntastic_cpp_compiler = 'clang++'
    let g:syntastic_cpp_compiler_options = ' -std=c++11'
    " Make python3 work " TODO: Make it toggle
    let g:syntastic_python_python_exec = 'python3'
    let g:syntastic_python_checkers = ['pylint', 'python3-pylint', 'python']
    "let g:syntastic_python_pylint_exec = '/usr/local/bin/pylint'

" }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tagbar Plugin {
    " Some more down below
    nmap <F8> :TagbarToggle<CR>
    map <leader>t :TagbarToggle<CR>
"}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDtree Plugin {
    nmap <F9> :NERDTreeToggle<CR>
    map <leader>n :NERDTreeToggle<CR>
    "let g:NERDTreeWinPos = "right"
"}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDcommenter Plugin {
    let NERD_cpp_alt_style=1
    let NERD_c_alt_style=1
    let g:NERDCustomDelimiters = {
        \ 'c': { 'leftAlt': '//','rightAlt': '', 'left': '/*', 'right': '*/' },
        \ 'cpp': { 'leftAlt': '//','rightAlt': '', 'left': '/*', 'right': '*/' },
        \ }
"}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Gundo Plugin {
    nnoremap <F5> :GundoToggle<CR>
    map <Leader>u :GundoToggle<CR>
"}


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NeoComplCache Plugin {
    "Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
    " Disable AutoComplPop.
    let g:acp_enableAtStartup = 0
    " Use neocomplcache.
    let g:neocomplcache_enable_at_startup = 1
    " Use smartcase.
    let g:neocomplcache_enable_smart_case = 1
    " Set minimum syntax keyword length.
    let g:neocomplcache_min_syntax_length = 3
    let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

    " Enable heavy features.
    " Use camel case completion.
    "let g:neocomplcache_enable_camel_case_completion = 1
    " Use underbar completion.
    "let g:neocomplcache_enable_underbar_completion = 1

    " Define dictionary.
    let g:neocomplcache_dictionary_filetype_lists = {
        \ 'default' : '',
        \ 'vimshell' : $HOME.'/.vimshell_hist',
        \ 'scheme' : $HOME.'/.gosh_completions'
            \ }

    " Define keyword.
    if !exists('g:neocomplcache_keyword_patterns')
        let g:neocomplcache_keyword_patterns = {}
    endif
    let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

    " Plugin key-mappings.
    inoremap <expr><C-g>     neocomplcache#undo_completion()
    inoremap <expr><C-o>     neocomplcache#complete_common_string()
" }


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NeoCompleteCache Recommended key-mappings {
    " <CR>: close popup and save indent.
    inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    function! s:my_cr_function()
      return neocomplcache#smart_close_popup() . "\<CR>"
      " For no inserting <CR> key.
      "return pumvisible() ? neocomplcache#close_popup() : "\<CR>"
    endfunction
    " <TAB>: completion.
    inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
    " <C-h>, <BS>: close popup and delete backword char.
    inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
    inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
    inoremap <expr><C-p>  neocomplcache#close_popup()
    inoremap <expr><C-e>  neocomplcache#cancel_popup()
    " Close popup by <Space>.
    "inoremap <expr><Space> pumvisible() ? neocomplcache#close_popup() : "\<Space>"

    " For cursor moving in insert mode(Not recommended)
    "inoremap <expr><Left>  neocomplcache#close_popup() . "\<Left>"
    "inoremap <expr><Right> neocomplcache#close_popup() . "\<Right>"
    "inoremap <expr><Up>    neocomplcache#close_popup() . "\<Up>"
    "inoremap <expr><Down>  neocomplcache#close_popup() . "\<Down>"
    " Or set this.
    "let g:neocomplcache_enable_cursor_hold_i = 1
    " Or set this.
    "let g:neocomplcache_enable_insert_char_pre = 1

    " AutoComplPop like behavior.
    "let g:neocomplcache_enable_auto_select = 1

    " Shell like behavior(not recommended).
    "set completeopt+=longest
    "let g:neocomplcache_enable_auto_select = 1
    "let g:neocomplcache_disable_auto_complete = 1
    "inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

    autocmd vimenter * if !argc() | NERDTree | endif

    " Enable omni completion.
    " autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    " autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    " autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    " autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    " autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

    " Enable heavy omni completion.
    if !exists('g:neocomplcache_omni_patterns')
      let g:neocomplcache_omni_patterns = {}
    endif
    let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
    let g:neocomplcache_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
    let g:neocomplcache_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

    " For perlomni.vim setting.
    " https://github.com/c9s/perlomni.vim
    let g:neocomplcache_omni_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
"}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Relative line numbers {
    function! NumberToggle()
      if(&relativenumber == 1)
        set number
      else
        set relativenumber
      endif
    endfunc

    nnoremap <C-n> :call NumberToggle()<cr>
    " autocmd InsertEnter * :set number
    " autocmd InsertLeave * :set relativenumber
"}


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FUNCTIONS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " Append modeline after last line in buffer.
" " Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" " files.
function! AppendModeline()
  let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d %set :",
        \ &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
  let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
  call append(line("$"), l:modeline)
endfunction
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tagbar Plugin {
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
"}

function! ToggleNERDTreeAndTagbar()
    let w:jumpbacktohere = 1

    " Detect which plugins are open
    if exists('t:NERDTreeBufName')
        let nerdtree_open = bufwinnr(t:NERDTreeBufName) != -1
    else
        let nerdtree_open = 0
    endif
    let tagbar_open = bufwinnr('__Tagbar__') != -1

    " Perform the appropriate action
    if nerdtree_open && tagbar_open
        NERDTreeClose
        TagbarClose
    elseif nerdtree_open
        TagbarOpen
    elseif tagbar_open
        NERDTree
    else
        NERDTree
        TagbarOpen
    endif

    " Jump back to the original window
    for window in range(1, winnr('$'))
        execute window . 'wincmd w'
        if exists('w:jumpbacktohere')
            unlet w:jumpbacktohere
            break
        endif
    endfor
endfunction
nnoremap <leader>\ :call ToggleNERDTreeAndTagbar()<CR>
