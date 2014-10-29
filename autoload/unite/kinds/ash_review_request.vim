let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#ash_review_request#define()
  return s:kind
endfunction

let s:kind = {
      \     'name' : 'ash_review_request',
      \     'default_action' : 'open',
      \     'action_table': {},
      \ }

let s:kind.action_table.open = {
      \     'description' : 'show that pull request',
      \ }

function! s:kind.action_table.open.func(candidate)
    execute "Unite ash_review:" . a:candidate.url
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

