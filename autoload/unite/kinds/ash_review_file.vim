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

function! s:kind.action_table.open.func(candidate)
    let fileToUse = system("ash " . a:candidate.url . " review " . a:candidate.file . " -e '' " . g:ash_review_file_flags)

    " todo: make this through :call unite#blah#blah()
    execute "autocmd BufDelete " . fileToUse . " !ash " . a:candidate.url . " review " . a:candidate.file . " --input=" . fileToUse
    execute "e " . fileToUse
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

