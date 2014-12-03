let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#ash_inbox#define()
  return s:source
endfunction

let s:source = {
      \     'name' : 'ash_inbox',
      \     'description' : 'candidates from ash inbox',
      \     'syntax' : '',
      \     'hooks' : {},
      \     'default_kind' : 'ash_review',
      \ }

function! ash_inbox#get_list()
    let plain = system("ash inbox | sed -e \"s/[[:space:]]\+/ /g\"")
    let list = split(plain, "\n")

    let candidates = []

    for line in list
        let title = line
        let url = substitute(line, " .*", "", "")

        call add(candidates, {
            \   'word' : title,
            \   'url': url,
            \ })
    endfor

    return candidates
endfunction


function! s:source.gather_candidates(args, context)
    let candidates = ash_inbox#get_list()

    return candidates
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

