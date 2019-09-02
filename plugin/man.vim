" File:         man.vim
" Type:         utility
" Version:      1.0
" Date:         02.09.19
" Author:       MyRequiem <mrvladislavovich@gmail.com>
" License:      MIT
" Description:  Opening man pages for the word under cursor or command :Man

scriptencoding utf-8

if exists('g:loaded_man') && g:loaded_man
    finish
endif

let g:loaded_man = 1
let g:man_hotkey = get(g:, 'man_hotkey', '<leader>K')
let g:man_open_vert = get(g:, 'man_open_vert', 0)

command! -nargs=* -complete=shellcmd Man call man#ShowManPage(<f-args>)
execute 'nnoremap <silent>' . g:man_hotkey . ' :call man#ShowManPage()<cr>'
