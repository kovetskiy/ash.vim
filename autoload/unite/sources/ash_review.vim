let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#ash_review#define()
  return s:source
endfunction

let s:source = {
      \     'name' : 'ash_review',
      \     'description' : 'candidates from ash ls',
      \     'syntax' : '',
      \     'hooks' : {},
      \     'default_kind' : 'ash_review',
      \ }

function! ash_review#ls(url)
    let url = a:url
    let plain = system("ash " . url . " ls | awk {'print $1\" \"$2'}")
    let list = split(plain, "\n")

    let candidates = []

    for line in list
        let title = line
        let file = substitute(line, "^.* ", "", "")

        call add(candidates, {
            \   'word' : title,
            \   'file' : file,
            \   'url': url,
            \ })
    endfor

    return candidates
endfunction

function! s:source.gather_candidates(args, context)
    let url = unite#util#input('URL: ')
    let candidates = ash_review#ls(url)

    return candidates
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

