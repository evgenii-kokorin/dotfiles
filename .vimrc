set nocompatible              " be iMproved, required
set autoindent "автоотступ
"В .py файлах включаем умные отступы после ключевых слов
autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
set shellslash
set rtp+=~/.vim/bundle/Vundle.vim
set nu "нумерация строк
set relativenumber  "относительная нумерация
set guioptions-=m "скрываю меню
set guioptions-=T "скрываю тулбар
"set clipboard=unnamedplus
syntax on
"filetype on
set guifont=Hack:h12
" let g:loaded_python3_provider = 1  " Игнорировать отсутствие Python-провайдера
call vundle#begin()
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'
" Plugin 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop'}
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'mhinz/vim-startify'
" Plugin 'jupyter-vim/jupyter-vim'
Plugin 'markonm/traces.vim'
call vundle#end()            " required
filetype plugin indent on    " required

" Установка темы
colo desert

" Копирование Windows
" set nocompatible
" source $VIMRUNTIME/mswin.vim
" behave mswin

" NERDTree Settings
" autocmd VimEnter * NERDTree
map <F2> :NERDTreeToggle<CR>

" Активация внутреннего переключателя раскладок
set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0
highlight lCursor guifg=NONE guibg=Cyan

" Чтобы можно было так же нажимать Ctrl-l для переключения, помимо Ctrl+^
inoremap <C-l> <C-^>
" set spell spelllang=en_us,ru

" Комбинация для компиляции python
map <F5> :w<CR>:!python %<CR>
" let g:python3_host_prog = '/usr/bin/python3'
" Поддержка виртуальных окружений python
" python with virtualenv support
" python3 << EOF
" import os
" import subprocess
" 
" if "VIRTUAL_ENV" in os.environ:
"     project_base_dir = os.environ["VIRTUAL_ENV"]
"     script = os.path.join(project_base_dir, "bin/activate")
"     pipe = subprocess.Popen(". %s; env" % script, stdout=subprocess.PIPE, shell=True)
"     output = pipe.communicate()[0].decode('utf8').splitlines()
"     env = dict((line.split("=", 1) for line in output))
"     os.environ.update(env)
" EOF

function! DetectVenv()
  if exists('$VIRTUAL_ENV')
    let venv_python = $VIRTUAL_ENV . '/bin/python'
    if executable(venv_python)
      let g:python3_host_prog = venv_python
      echom "Python venv activated: " . $VIRTUAL_ENV
    endif
  endif
endfunction
" local function setup_venv()
"   local venv_path = os.getenv("VIRTUAL_ENV")
"   if venv_path then
"     local python_path = venv_path .. "/bin/python"
"     if vim.fn.executable(python_path) == 1 then
"       vim.g.python3_host_prog = python_path
"       vim.notify("Python venv activated: " .. venv_path, vim.log.levels.INFO)
"     end
"   end
" end
" 
" setup_venv()

call DetectVenv()
" Выделение лишних пробелов красным цветом
" также настраиваются типы файлов к которым выделение применяется
highlight BadWhitespace ctermbg=red guibg=red
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

"Python-mode
" let g:pymode_virtualenv_path = $VIRTUAL_ENV     " Путь к venv
" let g:pymode_python = 'python3'
" " let g:pymode_lint = 1
" let g:pymode_lint_checker = "pyflakes,pep8"
" " let g:pymode_rope = 0
" let g:pymode_rope_complete_on_dot = 0
" let g:pymode_virtualenv = 1
" let g:pymode_syntax = 1
" let g:pymode_rope_extract_method_bind = '<C-c>rm'
" let g:pymode_lint = 1          " Отключает проверку кода (требует Python)
" let g:pymode_rope = 1          " Отключает автодополнение (требует Python)
" " Основные настройки
" let g:pymode_rope_completion = 1              " Включить автодополнение
" let g:pymode_rope_complete_on_dot = 1         " Автодополнение после точки
" let g:pymode_rope_autoimport = 1              " Автоматически добавлять импорты
" let g:pymode_rope_goto_definition_cmd = 'e'   " Открывать определение в текущем буфере
" let g:ropevim_extended_complete = 1
" let g:pymode_virtualenv = 0    " Отключает интеграцию с venv
" "highlight Normal guibg=NONE ctermbg=NONE
" Для заметок
let g:note= "~/Sync/5.Notes/"
command! -nargs=0 IndexNote :execute ":e" note . "Index.md"
command! -nargs=1 NewNote :execute ":e" note . strftime("%Y%m%d%H%M") . "-<args>.md"
command! -nargs=0 CDNotes :execute ":cd" note
"новая заметка 
nnoremap <leader>nn :NewNote 
"переход к индексу
nnoremap <leader>ni :IndexNote<CR> :CDNotes<CR>  
" set grepprg=rg\ --vimgrep
set grepprg=rg\ --vimgrep\ --smart-case
set grepformat=%f:%l:%c:%m
command! -nargs=1 Ngrep grep <args> -g "*.md"
" command! -nargs=1 Ngrep grep -i "<args>" -g "*.md"
"поиск с grep, cn, cp - навигация
nnoremap <leader>ns :CDNotes<CR> :Ngrep 

"CtrlP function for inserting a markdown link with Ctrl-X
function! CtrlPOpenFunc(action, line)
   if a:action =~ '^h$'    
      " Get the filename
      let filename = fnameescape(fnamemodify(a:line, ':t'))
      let l:filename_wo_timestamp = fnameescape(fnamemodify(a:line, ':t:s/\(^\d\+-\)\?\(.*\)\..\{1,3\}/\2/'))
      let l:filename_wo_timestamp = substitute(l:filename_wo_timestamp, "_", " ", "g")

      " Close CtrlP
      call ctrlp#exit()
      call ctrlp#mrufiles#add(filename)

      " Insert the markdown link to the file in the current buffer
	  let mdlink = "[".filename_wo_timestamp."]( ".filename." )"
      put=mdlink
  else    
      " Use CtrlP's default file opening function
      call call('ctrlp#acceptfile', [a:action, a:line])
   endif
endfunction

let g:ctrlp_open_func = { 
         \ 'files': 'CtrlPOpenFunc',
         \ 'mru files': 'CtrlPOpenFunc' 
         \ }
nnoremap <F6> "=strftime("%c")<CR>P
inoremap <F6> <C-R>=strftime("%c")<CR>

" Фолдинг
" Включаем фолдинг (сворачивание участков кода)
"set showtabline=0
set foldenable
"set foldcolumn=1
set foldminlines=4
" Работа с XML
autocmd BufNewFile,BufRead *.icd,*.scd,*.ssd,*.cid set filetype=xml
let g:xml_syntax_folding=1
autocmd FileType XML setlocal foldmethod=syntax foldlevelstart=999 foldminlines=0 foldlevel=1
" Сворачивание по отступам для python
autocmd FileType python setlocal foldmethod=indent
" Сворачивание markdown
let g:markdown_folding=1
" Автоматическое открытие сверток при заходе в них
"set foldopen=all

" Make Ctrlp use ripgrep
if executable('rg')
    let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
    let g:ctrlp_user_caching = 0
    set grepprg=rg\ --color=never\ --vimgrep
endif


"Автоматическое переключение рабочей папки
set autochdir

"Jupyter connect
nnoremap <buffer> <silent> <localleader>T :JupyterConnect<CR>

" Run current file
nnoremap <buffer> <silent> <localleader>R :JupyterRunFile<CR>
nnoremap <buffer> <silent> <localleader>I :PythonImportThisFile<CR>

" Change to directory of current file
nnoremap <buffer> <silent> <localleader>d :JupyterCd %:p:h<CR>

" Send a selection of lines
nnoremap <buffer> <silent> <localleader>X :JupyterSendCell<CR>
nnoremap <buffer> <silent> <localleader>E :JupyterSendRange<CR>
nmap     <buffer> <silent> <localleader>e <Plug>JupyterRunTextObj
vmap     <buffer> <silent> <localleader>e <Plug>JupyterRunVisual

" Debugging maps
nnoremap <buffer> <silent> <localleader>b :PythonSetBreak<CR>
