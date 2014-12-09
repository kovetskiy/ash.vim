let s:save_cpo = &cpo
set cpo&vim

let g:ash_review_file_loaded = 1

call unite#util#set_default(
    \    'g:ash_review_file_flags', '-w'
    \ )

function! unite#kinds#ash_review_file#define()
  return s:kind
endfunction

let s:kind = {
      \     'name' : 'ash_review_file',
      \     'default_action' : 'open',
      \     'action_table': {},
      \ }

let s:kind.action_table.open = {
      \     'description' : 'review that file',
      \ }

let s:unite_ash_reviews = {}
let s:unite_ash_buffers = {}
let s:unite_ash_vimleave_handled = 0

function! s:ash_mark_changed(inputFile)
    let s:unite_ash_buffers[a:inputFile]['changed'] = 1
endfunction

function! s:ash_save_changes_single_file(inputFile)
    let l:bufferData = s:unite_ash_buffers[a:inputFile]

    let l:changed = l:bufferData["changed"]

    if l:changed
        let l:command = 'ash ' . l:bufferData['url'] . ' review ' . l:bufferData['file'] . ' --input=' . a:inputFile

        execute '!' . l:command
    endif

    " @todo check for exit status...
    unlet s:unite_ash_buffers[a:inputFile]
endfunction

function! s:ash_save_changes_all_files()
    let l:buffers = keys(s:unite_ash_buffers)
    for l:iBuffer in l:buffers
        call s:ash_save_changes_single_file(l:iBuffer)
    endfor
endfunction

function! s:kind.action_table.open.func(candidate)
    if s:unite_ash_vimleave_handled == 0 
        " @todo try make this through 'augroup' and 'au!'
        execute "autocmd VimLeave * call s:ash_save_changes_all_files()"
        echo "handled!"

        let s:unite_ash_vimleave_handled = 1
    endif

    if !has_key(s:unite_ash_reviews, a:candidate.url) 
        let s:unite_ash_reviews[a:candidate.url] = {}
    endif

    if has_key(s:unite_ash_reviews[a:candidate.url], a:candidate.file)
        let l:fileData = s:unite_ash_reviews[a:candidate.url][a:candidate.file]
        let l:bufNumber = l:fileData['bufNumber']

        execute 'buffer ' . l:bufNumber
    else
        let l:inputFile = system("ash " . a:candidate.url . " review " . a:candidate.file . " -e '' " . g:ash_review_file_flags)

        execute "autocmd BufDelete " . l:inputFile . " call s:ash_save_changes_single_file(expand('%'))"
        execute "autocmd BufWritePost " . l:inputFile . " call s:ash_mark_changed(expand('%'))"
        execute "edit " . l:inputFile

        let l:bufNumber = bufnr('%')

        let s:unite_ash_buffers[l:inputFile] = {
            \ 'bufNumber'   : l:bufNumber,
            \ 'url'   : a:candidate.url,
            \ 'file'  : a:candidate.file,
            \ 'input' : l:inputFile,
            \ 'changed' : 0,
        \ }

        let s:unite_ash_reviews[a:candidate.url][a:candidate.file] = {
            \ 'bufNumber'   : l:bufNumber,
            \ 'inputFile'   : l:inputFile,
            \ 'review'      : a:candidate.url,
            \ 'file'        : a:candidate.file,
        \ }

    endif
endfunction

function! Ash_airline_section_b()
    return [Ash_get_context_var('url')]
endfunction

function! Ash_airline_section_c()
    return [Ash_get_context_var('file')]
endfunction

function! Ash_get_context_var(name)
    let l:inputFile = expand('%p')
    if !has_key(s:unite_ash_buffers, l:inputFile)
        return ""
    endif

    let l:fileData  = s:unite_ash_buffers[l:inputFile]
    return l:fileData[a:name]
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
