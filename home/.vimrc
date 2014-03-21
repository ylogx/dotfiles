" command! -complete=shellcmd -nargs=+ Shell call s:RunShellCommand(<q-args>)
" function! s:RunShellCommand(cmdline)
"   let isfirst = 1
"   let words = []
"   for word in split(a:cmdline)
"     if isfirst
"       let isfirst = 0  " don't change first word (shell command)
"     else
"       if word[0] =~ '\v[%#<]'
"         let word = expand(word)
"       endif
"       let word = shellescape(word, 1)
"     endif
"     call add(words, word)
"   endfor
"   let expanded_cmdline = join(words)
"   botright new
"   setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
"   call setline(1, 'You entered:  ' . a:cmdline)
"   call setline(2, 'Expanded to:  ' . expanded_cmdline)
"   call append(line('$'), substitute(getline(2), '.', '=', 'g'))
"   silent execute '$read !'. expanded_cmdline
"   1
" endfunction


" function! s:ExecuteInShell(command)
"   let command = join(map(split(a:command), 'expand(v:val)'))
"   let winnr = bufwinnr('^' . command . '$')
"   silent! execute  winnr < 0 ? 'botright new ' . fnameescape(command) : winnr . 'wincmd w'
"   setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap number
"   echo 'Execute ' . command . '...'
"   silent! execute 'silent %!'. command
"   silent! execute 'resize ' . line('$')
"   silent! redraw
"   silent! execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
"   silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . command . ''')<CR>'
"   echo 'Shell command ' . command . ' executed.'
" endfunction
" command! -complete=shellcmd -nargs=+ Shell call s:ExecuteInShell(<q-args>)

"""""""""""""""""""""""""""""""""""""""""""
"
" call pathogen#runtime_append_all_bundles()
call pathogen#incubate()
call pathogen#helptags()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Formatting {
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
    autocmd FileType c,cpp,java,php,js,python,twig,xml,yml autocmd BufWritePre <buffer> :call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))
" }




"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General {
    " allow saving as sudo if opened not as sudo
    cmap w!! w !sudo tee > /dev/null %     

    set tags=./tags,tags,./TAGS,TAGS,~/tags,~/.tags     " Exuberent ctags
    " Move to a given tag " Note: C-t is for moving back in tagstack
    map <C-y> g<C-]>        

    set undofile
    set undodir=~/.vimundo
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



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Commenting blocks of code.
autocmd FileType c,cpp,java,scala       let b:comment_leader = '// '
autocmd FileType sh,ruby,python,perl    let b:comment_leader = '# '
autocmd FileType conf,fstab             let b:comment_leader = '# '
autocmd FileType tex                    let b:comment_leader = '% '
autocmd FileType mail                   let b:comment_leader = '> '
autocmd FileType vim                    let b:comment_leader = '" '
noremap <silent> ,cc :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
noremap <silent> ,cx :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{
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
    inoremap <expr><C-l>     neocomplcache#complete_common_string()
" }


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDtree Plugin {
    nmap <F9> :NERDTree<CR>
"}


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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
    inoremap <expr><C-y>  neocomplcache#close_popup()
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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tagbar Plugin {
    nmap <F8> :TagbarToggle<CR>
"}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Relative line numbers {
    function! NumberToggle()
      if(&relativenumber == 1)
        set number
      else
        set relativenumber
      endif
    endfunc

    nnoremap <C-l> :call NumberToggle()<cr>
    " autocmd InsertEnter * :set number
    " autocmd InsertLeave * :set relativenumber
"}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Lightline plugin {
"    let g:lightline = {
"          \ 'colorscheme': 'landscape',
"          \ 'mode_map': { 'c': 'NORMAL' },
"          \ 'active': {
"          \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ]
"          \ },
"          \ 'component_function': {
"          \   'modified': 'MyModified',
"          \   'readonly': 'MyReadonly',
"          \   'fugitive': 'MyFugitive',
"          \   'filename': 'MyFilename',
"          \   'fileformat': 'MyFileformat',
"          \   'filetype': 'MyFiletype',
"          \   'fileencoding': 'MyFileencoding',
"          \   'mode': 'MyMode',
"          \ },
"          \ 'separator': { 'left': '⮀', 'right': '⮂' },
"          \ 'subseparator': { 'left': '⮁', 'right': '⮃' }
"          \ }
"
"    function! MyModified()
"      return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
"    endfunction
"
"    function! MyReadonly()
"      return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? '⭤' : ''
"    endfunction
"
"    function! MyFilename()
"      return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
"            \ (&ft == 'vimfiler' ? vimfiler#get_status_string() : 
"            \  &ft == 'unite' ? unite#get_status_string() : 
"            \  &ft == 'vimshell' ? vimshell#get_status_string() :
"            \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
"            \ ('' != MyModified() ? ' ' . MyModified() : '')
"    endfunction
"
"    function! MyFugitive()
"      if &ft !~? 'vimfiler\|gundo' && exists("*fugitive#head")
"        let _ = fugitive#head()
"        return strlen(_) ? '⭠ '._ : ''
"      endif
"      return ''
"    endfunction
"
"    function! MyFileformat()
"      return winwidth(0) > 70 ? &fileformat : ''
"    endfunction
"
"    function! MyFiletype()
"      return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
"    endfunction
"
"    function! MyFileencoding()
"      return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
"    endfunction
"
"    function! MyMode()
"      return winwidth(0) > 60 ? lightline#mode() : ''
"    endfunction
"}
