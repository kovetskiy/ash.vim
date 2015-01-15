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
      \     'default_kind' : 'ash_review_file',
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
    let args = unite#helper#parse_project_bang(a:args)

    let url = get(args, 0, '')
    if url == ''
        let url = unite#util#input('URL: ')
    endif

    if url == ''
        call unite#util#print_error('ash.vim: Invalid url')
    endif

    let candidates = ash_review#ls(url)

    return candidates
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
