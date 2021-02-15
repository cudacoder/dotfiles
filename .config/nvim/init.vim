"""""""""""""""""""""""""
"       Plugins         "
"""""""""""""""""""""""""

if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif

call plug#begin(split(&rtp, ',')[0] . '/plugins')
Plug 'ap/vim-css-color'
Plug 'mattn/emmet-vim'
Plug 'dense-analysis/ale'
Plug 'preservim/nerdtree'
Plug 'jpalardy/vim-slime'
Plug 'ruanyl/vim-gh-line'
Plug 'sheerun/vim-polyglot'
Plug 'danilo-augusto/vim-afterglow'
Plug 'christoomey/vim-tmux-navigator'
Plug 'airblade/vim-rooter'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

"""""""""""""""""""""""""
"       Settings        "
"""""""""""""""""""""""""

syntax on                 " Syntax highlighting
filetype plugin indent on " Turn on filetype detections
runtime snippets.vim      " Load snippets

set number                " Show line numbers
set nowrap                " Disable line wrapping
set noswapfile            " No swap files
set nobackup              " No backup files
set nohlsearch            " Disable search highlight
set noshowmode            " Don't show current mode in status line
set incsearch             " Sets incremental search
set autoindent            " New lines will be indented as well
set smartcase             " No ignore case when pattern has uppercase
set hidden                " Hide abandoned buffers instead of unloading them
set pyx=3                 " Set Python version to 3
set shortmess+=I          " Supress startup message
set shortmess+=c          " Don't give in-completion-menu messages
set updatetime=250        " Set CursorHold delay time
set encoding=utf-8        " Encoding for files
set signcolumn=yes        " Always show signcolumn
set foldmethod=manual     " Set foldmethod to be manual
set clipboard=unnamedplus " Enables OS clipboard support

"""""""""""""""""""""""""
"        Colors         "
"""""""""""""""""""""""""

set termguicolors
colorscheme afterglow

" Remove background
hi Normal guibg=none
hi LineNr guibg=none
hi SignColumn guibg=none

" User1 - Default base color
" User2 - Inactive pane
" User3 - Insert
" User4 - Command
" User5 - Visual

" guifg in User highlights is for *text* color
hi User1 guifg=orange guibg=#4b4b4b
hi User2 guifg=grey30 guibg=#4b4b4b
hi User3 guifg=violet guibg=#4b4b4b
hi User4 guifg=lime   guibg=#4b4b4b
hi User5 guifg=yellow guibg=#4b4b4b

" guifg in StatusLine highlights is for *its* color
hi StatusLine   guifg=#4b4b4b guibg=white
hi StatusLineNC guifg=#4b4b4b guibg=grey30

"""""""""""""""""""""""""
"       Variables       "
"""""""""""""""""""""""""

" <SPC> as leader
let mapleader = " "
let maplocalleader = " "

" ALE
let g:ale_sign_error = '• '
let g:ale_sign_warning = '• '
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_insert_leave = 0
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%] [%code%]'
let g:ale_linters_explicit = 1
let g:ale_linters = { 
\ 'cpp': ['ccls'],
\ 'javascript': ['eslint'],
\ 'javascriptreact': ['eslint'],
\ 'typescript': ['eslint'],
\ 'typescriptreact': ['eslint'],
\}
let g:ale_fixers = { 
\ 'go': ['gofmt'],
\ 'javascript': ['eslint'],
\ 'javascriptreact': ['eslint'],
\ 'typescript': ['eslint'],
\ 'typescriptreact': ['eslint'],
\}
let g:ale_pattern_options = {
\ '\.min\.js$': {'ale_linters': [], 'ale_fixers': []},
\ '\.min\.css$': {'ale_linters': [], 'ale_fixers': []},
\}

" Slime
let g:slime_target = "tmux"
let g:slime_paste_file = $XDG_CACHE_HOME . "/.slime_paste"
let g:slime_default_config = {"socket_name": get(split($TMUX, ","), 0), "target_pane": ":.2"}

" Rooter
let g:rooter_silent_chdir = 1
let g:rooter_patterns = ['.git', 'Makefile', 'package.json']
let g:rooter_change_directory_for_non_project_files = 'current'

" vim-gh-line
let g:gh_line_map_default = 0
let g:gh_line_blame_map_default = 0

" Goyo
let g:goyo_width = 85

" Nerd tree
let NERDTreeShowHidden = 1
let NERDTreeBookmarksFile = stdpath('data') . '/NERDTreeBookmarks'
map <silent> <leader>n :exe g:NERDTree.IsOpen() ? 'NERDTreeClose' : bufexists(expand('%')) ? 'NERDTreeFind' : 'NERDTree'<CR>

"""""""""""""""""""""""""
"       Functions       "
"""""""""""""""""""""""""

function! NewZettel()
	let l:zid = strftime("%Y%m%d%H%M%S")
	let l:title = input('Title: ')
	let l:dash_separated = substitute(l:title, ' ', '-', 'g')
	let l:capitalized = substitute(l:title, '\<.', '\u&', 'g')
	let l:first_line = '# ' . l:zid . ' ' . l:capitalized
	call setline(1, l:first_line)
	exe 'silent w ' . l:zid . '-' . l:dash_separated . '.md'
	exe 'Goyo'
	filetype detect
	exe "normal! 2o\<Esc>"
endfunction

function! AgRange(type, ...)
	let sel_save = &selection
	let &selection = "inclusive"
	let reg_save = @@
	if a:0
		silent exe "normal! gvy"
	elseif a:type == 'line'
		silent exe "normal! '[V']y"
	else
		silent exe "normal! `[v`]y"
	endif
	exe "Ag " . @@
	let &selection = sel_save
	let @@ = reg_save
endfunction

"""""""""""""""""""""""
"      Mappings       "
"""""""""""""""""""""""

imap jk <Esc>

nmap <silent> ]g <Plug>(ale_next)
nmap <silent> [g <Plug>(ale_previous)
nmap <silent> ]h <Plug>(GitGutterNextHunk)
nmap <silent> [h <Plug>(GitGutterPrevHunk)
nmap <silent> sh <Plug>(GitGutterStageHunk)

" Start interactive EasyAlign in visual mode
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object
nmap ga <Plug>(EasyAlign)

nnoremap S :%s//g<Left><Left>
nnoremap <silent> <Leader>w :w<CR>
nnoremap <silent> <Leader>q :q<CR>
nnoremap <silent> <Leader>g :G<CR>
nnoremap <silent> <Leader>/ :Ag<CR>
nnoremap <silent> <Leader>J :sp<CR>
nnoremap <silent> <Leader>L :vsp<CR>
nnoremap <silent> <Leader>p :Files<CR>
nnoremap <silent> <Leader>. :GFiles<CR>
nnoremap <silent> <Leader>b :Buffers<CR>
nnoremap <silent> <leader>o :setlocal spell! spelllang=en_us<CR>
nnoremap <silent> <leader>sc :!clear && shellcheck -x %<CR>
nnoremap <silent> <leader>ss :set operatorfunc=AgRange<cr>g@
vnoremap <silent> <leader>ss :<c-u>call AgRange(visualmode(), 1)<cr>

nnoremap <silent> <Leader>yf :let @*=expand("%:p")<CR>
nnoremap <silent> <Leader>zc :e ~/.config/zsh/.zshrc<CR>
nnoremap <silent> <Leader>ec :e ~/.config/nvim/init.vim<CR>
nnoremap <silent> <Leader>so :so ~/.config/nvim/init.vim<CR>

nnoremap <silent> <Leader>=h :exe "resize +5"<CR>
nnoremap <silent> <Leader>-h :exe "resize -5"<CR>
nnoremap <silent> <Leader>=v :exe "vertical resize +5"<CR>
nnoremap <silent> <Leader>-v :exe "vertical resize -5"<CR>

"""""""""""""""""""""""""
"       Commands        "
"""""""""""""""""""""""""

command! NewZettel :call NewZettel()

" Show only changed files
command! Fzfc :call fzf#run(fzf#wrap({'source': 'git ls-files --exclude-standard --others --modified'}))

" hack for making js watchers pickup changes inside docker containers
command! DockerRefresh exe
            \ 'silent !docker-compose -f ~/Projects/box/docker-compose.yml exec -T '
            \ . fnamemodify(getcwd(), ':t')
            \ . ' touch '
            \ . expand('%')
            \ . ' & '

"""""""""""""""""""""""""
"     Autocommands      "
"""""""""""""""""""""""""

autocmd BufWritePost * GitGutter
autocmd BufWritePost */box/projects/* DockerRefresh
autocmd BufRead $XDG_CONFIG_HOME/* let g:gitgutter_git_args = '--git-dir="$HOME/.dotfiles" --work-tree="$HOME"'

"""""""""""""""""""""""""
"      Statusline       "
"""""""""""""""""""""""""

let g:statusline_mode_color_map = {
			\ 'i'  : '%3*',
			\ 'c'  : '%4*', 'cv' : '%4*', 'ce' : '%4*',
			\ 'v'  : '%5*',  'V'  : '%5*',  "\<C-V>" : '%5*',
			\ }

let g:statusline_mode_map = {
			\ 'i'  : 'I',
			\ '!'  : '!',
			\ 't'  : 'B',
			\ 'R'  : 'R', 'Rv' : 'R',
			\ 'n'  : 'N',  'no' : 'N',
			\ 'v'  : 'V',  'V'  : 'V',  "\<C-V>" : 'V',
			\ 's'  : 'S',  'S'  : 'S',  "<\C-S>" : 'S',
			\ 'c'  : 'C', 'cv' : 'C', 'ce' : 'C',
			\ 'r'  : 'PROMPT',  'rm' : 'PROMPT',  'r?' : 'PROMPT',
			\ }

function! StatusLine(active)
	let l:clear = '%*'
	let l:icon = a:active ? '(•◡•)' : '(ᴗ˳ᴗ)'
	let l:mode_color = a:active ? get(g:statusline_mode_color_map, mode(), '%1*') : '%2*'
	let l:filetype = empty(&filetype) ? '?' : '%{&filetype}'
	let l:fugitive = a:active && FugitiveHead() != '' ? '%3*●%* %{FugitiveHead()}' : ''
	let l:coc_status = get(g:, 'coc_status', '') != '' ? '｜%{tolower(coc#status())}' : ''
	let l:statusline_segments = [
				\ l:mode_color . '(%{g:statusline_mode_map[mode()]})' . l:clear,
				\ '   ',
				\ fnamemodify(getcwd(), ':t'),
				\ '   ',
				\ '%{expand("%")} %m %r %h',
				\ '%=',
				\ l:fugitive,
				\ '   ',
				\ l:filetype . l:coc_status,
				\ '   ',
				\ l:icon 
				\]
	return join(l:statusline_segments)
endfunction

set statusline=%!StatusLine(1)

augroup statusline_commands
    autocmd!
    autocmd WinEnter * setlocal statusline=%!StatusLine(1)
    autocmd WinLeave * setlocal statusline=%!StatusLine(0)
augroup END

" Function for toggling the statusline
let s:hidden_all = 0
function! ToggleStatusline()
    if s:hidden_all  == 0
        let s:hidden_all = 1
        set noshowmode
        set noruler
        set laststatus=0
        set noshowcmd
    else
        let s:hidden_all = 0
        set showmode
        set ruler
        set laststatus=2
        set showcmd
    endif
endfunction
nnoremap <silent> <leader>hh :call ToggleStatusline()<CR>

call ToggleStatusline()

"""""""""""""""""""""""""
"        Coc.vim        "
"""""""""""""""""""""""""

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use K to show documentation in preview window
function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        exe 'h '.expand('<cword>')
    else
        call CocAction('doHover')
    endif
endfunction

nnoremap <silent> K :call <SID>show_documentation()<CR>

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at 
" current position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
    inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
    inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use tab for trigger completion with characters ahead and navigate.
function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Add function text object
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Rename symbol
nmap <leader>rn <Plug>(coc-rename)

" GoTo code navigation
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gy <Plug>(coc-type-definition)

" Format selected code
xmap <leader>f <Plug>(coc-format-selected)
nmap <leader>f <Plug>(coc-format-selected)
