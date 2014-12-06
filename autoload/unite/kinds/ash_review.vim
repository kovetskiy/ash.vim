let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#ash_review#define()
  return s:kind
endfunction

let s:kind = {
      \     'name' : 'ash_review',
      \     'default_action' : 'open',
      \     'action_table': {},
      \ }

let s:kind.action_table.open = {
      \     'description' : 'show that pull request',
      \ }

function! s:kind.action_table.open.func(candidate)
    execute "Unite ash_review:" . a:candidate.url
endfunction


let s:kind.action_table.ls = {
      \     'description' : 'list files in the request',
      \ }


function! s:kind.action_table.ls.func(candidate)
    let fileToUse = system("ash " . a:candidate.url . " review -e ''")

    " todo: make this through :call unite#blah#blah()
    execute "autocmd BufDelete " . fileToUse . " !ash " . a:candidate.url . " review --input=" . fileToUse
    execute "e " . fileToUse
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
