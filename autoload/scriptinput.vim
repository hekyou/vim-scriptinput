" Script input command
" Version: 0.0.1
" Author: hekyou <hekyolabs+vim@gmail.com>

scriptencoding utf-8

let s:scriptinput_default_filetype_local = 'vim'

function! scriptinput#run()
  if !exists('s:bufnr')
    let s:bufnr = -1
  endif
  if bufexists(s:bufnr)
    if empty(s:arg)
      execute 'QuickRun -outputter scriptinput'
    else
      execute 'QuickRun -args "' . s:arg . '" -outputter scriptinput'
    endif
  endif
endfunction

function! scriptinput#input(opt, count, line1, line2)
  let type = input("enter file type: ")
  let opts = a:opt
  if !empty(a:opt)
    let opts = opts . " "
  endif
  let opts = opts . type
  call scriptinput#main(opts, a:count, a:line1, a:line2)
endfunction

function! scriptinput#main(opt, count, line1, line2)
  let s:mode = 'v'
  let s:arg = ''
  let s:line1 = 0
  let s:line2 = 0

  let s:opts = split(a:opt, ' ')

  if a:count
    let s:line1 = a:line1
    let s:line2 = a:line2
    let s:arg = s:getArg(s:line1, s:line2)
  elseif len(s:opts) > 0 && s:opts[0] ==# '-mode-v'
    call remove(s:opts, 0)
    let s:line1 = getpos("'<")[1]
    let s:line2 = getpos("'>")[1]
    let s:arg = s:getArg(s:line1, s:line2)
  else
    let s:mode = 'n'
    let s:line1 = getpos('.')[1]
  endif

  let s:filetype = s:getFileType(s:opts)
  call s:boot(s:arg)
endfunction

function! s:getFileType(opts)
  let type = s:scriptinput_default_filetype_local

  if len(a:opts) == 1
    let type = a:opts[0]
  elseif exists('g:scriptinput_default_filetype') && !empty(g:scriptinput_default_filetype)
    let type = g:scriptinput_default_filetype
  endif

  return type
endfunction

function! s:getArg(line1, line2)
  let arg = ''
  let str_list = []
  let line_cnt = abs(a:line2 - a:line1) + 1
  let i = 0
  while i < line_cnt
    let str_list = add(str_list, escape(escape(getline(a:line1 + i), ' '), ' '))
    let i += 1
  endwhile
  if len(str_list) > 0
    let arg = join(str_list, ' ')
  endif

  return arg
endfunction

function! s:boot(arg)
  if exists('s:bufnr') && bufexists(s:bufnr)
    execute 'bd! '.s:bufnr
    unlet s:bufnr
  endif
  setlocal bufhidden=hide buftype=nofile noswapfile
  execute 'split'
  execute 'edit [ScriptInput]['.s:filetype.']'
  let s:bufnr = bufnr('%')
  execute 'setlocal filetype='.s:filetype
endfunction

function! s:input(result)
  if s:mode ==# 'v'
    execute s:line1.','.s:line2.'delete'
  endif

  let data = split(a:result, '\n')

  let i = -1
  for line in data
    call append(s:line1 + i, line)
    let i += 1
  endfor
  call cursor(s:line1, 0)
endfunction

" quickrun outputter
let s:outputter = {}

function! s:outputter.init(session)
  let self._size = 0
  let self._result = ''
endfunction

function! s:outputter.output(data, session)
  let self._result .= a:data
  let self._size += len(a:data)
endfunction

function! s:outputter.finish(session)
  if a:session.exit_code
    echo self._result
  else
    execute 'bd! '.s:bufnr
    unlet s:bufnr
    call s:input(self._result)
  endif
endfunction

call quickrun#register_outputter('scriptinput', s:outputter)

