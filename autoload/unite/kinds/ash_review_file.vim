let s:save_cpo = &cpo
set cpo&vim

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

function! s:ash_save_changes_single_file(inputFile)
    let l:bufferData = s:unite_ash_buffers[a:inputFile]
    let l:command = 'ash ' . l:bufferData['url'] . ' review ' . l:bufferData['file'] . ' --input=' . a:inputFile

    execute '!' . l:command

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
        let l:bufCount = bufnr('$')
        let l:bufNumber = l:bufCount + 1

        let s:unite_ash_reviews[a:candidate.url][a:candidate.file] = {
            \ 'bufNumber'   : l:bufNumber,
            \ 'inputFile'   : l:inputFile,
            \ 'review'      : a:candidate.url,
            \ 'file'        : a:candidate.file,
        \ }

        let s:unite_ash_buffers[l:inputFile] = {
            \   'url'   : a:candidate.url,
            \   'file'  : a:candidate.file,
            \   'input' : l:inputFile,
        \ }

        execute "autocmd BufDelete " . l:inputFile . " call s:ash_save_changes_single_file('" . l:inputFile . "')"
        execute "edit " . l:inputFile
    endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

