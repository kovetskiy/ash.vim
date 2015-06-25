let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#ash_lsreviews#define()
  return s:source
endfunction

let s:source = {
      \     'name' : 'ash_lsreviews',
      \     'description' : 'candidates from ash ls-reviews',
      \     'syntax' : '',
      \     'hooks' : {},
      \     'default_kind' : 'ash_review_request',
      \ }

function! ash_lsreviews#get_list(url, type)
    let url = a:url
    let type = a:type

    let plain = system("ash " . url . " ls-reviews " . type .
        \ " | sed -e \"s/[[:space:]]\+/ /g\"")

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
    let url = get(a:args, 0, '')
    let type = get(a:args, 1, '')

    if url == ''
        let url = unite#util#input('URL: ')
    endif

    if url == ''
        call unite#util#print_error('ash.vim: Invalid url')
        throw 'ash.vim: Invalid url'
    endif

    if type == ''
        let type = unite#util#input('Type [(open|merged|declined)]: ')
    endif

    if type != 'open' && type != 'merged' && type != 'declined'
        call unite#util#print_error('ash.vim: Invalid type')
        throw 'ash.vim: Invalid type'
    endif

    let candidates = ash_lsreviews#get_list(url, type)

    return candidates
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
