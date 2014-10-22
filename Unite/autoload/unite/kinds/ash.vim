let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#ash#define() "{{{
  return s:kind
endfunction"}}}

let s:kind = {
      \     'name' : 'ash',
      \     'default_action' : 'open',
      \     'action_table': {},
      \ }

let s:kind.action_table.open = {
      \     'description' : 'review this file',
      \ }

function! s:kind.action_table.open.func(candidate) "{{{
    let fileToUse = system("ash " . a:candidate.review . " review " . a:candidate.file . " -e ''")

    " todo: make this through :call unite#blah#blah()
    execute "autocmd BufDelete " . fileToUse . " !ash " . a:candidate.review . " review " . a:candidate.file . " --input=" . fileToUse
    execute "e " . fileToUse
endfunction "}}}

let &cpo = s:save_cpo
unlet s:save_cpo

