" man#ShowManPage(...) abort {{{1
function! man#ShowManPage(...) abort
    if len(a:000)
        " function call by :Man command
        let l:page = a:1
    else
        " hotkey pressed for word under cursor
        let l:page = expand('<cword>')
    endif

    if empty(l:page)
        return
    endif

    " 'man -w' - print the location of the source file for manpage if exists
    let l:where = system('man -w ' . l:page)
    if l:where !~# '^/' && matchstr(l:where, ' [^ ]*$') !~# '^ /'
        echo "Manual page for '" . l:page . "' not found"
        return
    endif

    " opening a new window if the current buffer does not have a manual page
    if &filetype !=# 'man'
        let l:thisWinNum = winnr()
        " go to the last open window
        execute "normal! \<C-w>b"

        if winnr() > 1
            " go to the window from which the function was called
            execute 'normal! ' . l:thisWinNum . "\<C-w>w"

            while 1
                if &filetype ==# 'man'
                    break
                endif

                " go to the next window
                execute "normal! \<C-w>w"

                " walked through all the windows
                if winnr() == l:thisWinNum
                    break
                endif
            endwhile
        endif

        if &filetype !=# 'man'
            if g:man_open_vert
                vnew
            else
                new
            endif
        endif
    endif

    " open buffer
    silent execute 'edit /tmp/__man_'. l:page . '__'
    setlocal buftype=nofile noswapfile modifiable nonumber norelativenumber
    setlocal bufhidden=unload nofoldenable filetype=man tabstop=4 nobuflisted
    " clear buffer
    silent execute 'norm! 1GdG'
    silent execute 'r !man ' . l:page . ' | col -b'

    " go to the beginning of the buffer and delete the first empty line, if any
    execute 'normal! gg'
    if empty(getline('.'))
        silent execute 'normal! dd'
    endif

    setlocal nomodified nomodifiable
endfunction " 1}}}
