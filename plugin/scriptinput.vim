" Script input command
" Version: 0.0.1
" Author: hekyou <hekyolabs+vim@gmail.com>

if exists('g:loaded_scriptinput')
  finish
endif
let g:loaded_scriptinput = 1

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=? -range=0 ScriptInput call scriptinput#main(<q-args>, <count>, <line1>, <line2>)
command! -nargs=? -range=0 ScriptInputInput call scriptinput#input(<q-args>, <count>, <line1>, <line2>)

command! ScriptInputRun call scriptinput#run()
"command! ScriptInputRunRectInsert call scriptinput#runRectInsert()

nnoremap <silent> <Plug>(scriptinput_run) :<C-u>ScriptInputRun<CR>
"nnoremap <silent> <Plug>(scriptinput_run_rectinsert) :<C-u>ScriptInputRunRectInsert<CR>
nnoremap <silent> <Plug>(scriptinput_default) :<C-u>ScriptInput<CR>
nnoremap <silent> <Plug>(scriptinput_select) :<C-u>ScriptInput 
nnoremap <silent> <Plug>(scriptinput_input) :<C-u>ScriptInputInput<CR>
vnoremap <silent> <Plug>(scriptinput_default) :<C-u>ScriptInput -mode-v<CR>
vnoremap <silent> <Plug>(scriptinput_select) :<C-u>ScriptInput -mode-v 
vnoremap <silent> <Plug>(scriptinput_input) :<C-u>ScriptInputInput -mode-v<CR>

let &cpo = s:save_cpo
unlet s:save_cpo

