function! airline#extensions#ash#apply(...)
    if get(g:, 'ash_review_file_loaded', 0)
        if substitute(expand('%'), '.*\.', '', 'g') == 'diff'
            call a:1.add_section('airline_a', ' ash ')

            call a:1.add_section('airline_b',
                \ ' %{get(Ash_airline_section_b(), "buffer_name", "")} ')

            call a:1.add_section('airline_c',
                \ ' %{get(Ash_airline_section_c(), "buffer_name", "")} ')

            call a:1.split()

            return 1
        endif
    endif
endfunction

function! airline#extensions#ash#init(ext)
    let g:ash_force_overwrite_statusline = 0
    call a:ext.add_statusline_func('airline#extensions#ash#apply')
endfunction
