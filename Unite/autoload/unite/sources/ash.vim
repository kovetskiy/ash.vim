let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#ash#define() "{{{
  return s:source
endfunction"}}}

let s:source = {
      \     'name' : 'ash',
      \     'description' : 'candidates from ash ls',
      \     'syntax' : '',
      \     'hooks' : {},
      \     'default_kind' : 'ash',
      \ }

function! s:source.gather_candidates(args, context) "{{{
    let review = unite#util#input('URL: ')
    let slist = system("ash " . review . " ls | awk {'print $1\" \"$2'}")
    let list = split(slist, "\n")
   
    let candidates = []

    for line in list
        let title = line
        let file = substitute(line, "^.* ", "", "")
        call add(candidates, {
            \   'word' : title,
            \   'file' : file,
            \   'review': review,
            \ })
    endfor

    return candidates
endfunction "}}}

let &cpo = s:save_cpo
unlet s:save_cpo

