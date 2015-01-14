if exists('g:loaded_ash') || &cp 
    finish
endif

let g:loaded_ash = 1

fun! Ash_apply_diff_syntax()
    syn match DiffCommentIgnore "^###.*" containedin=ALL
    syn match DiffComment "^#.*" containedin=ALL
    syn match DiffComment "^---.*" containedin=ALL
    syn match DiffComment "^+++.*" containedin=ALL
    syn match DiffComment "^@@ .*" containedin=ALL
    syn match DiffAdded "^+" containedin=ALL
    syn match DiffRemoved "^-" containedin=ALL
    syn match DiffContext "^ " containedin=ALL

    hi DiffCommentIgnore ctermfg=249 ctermbg=none
    hi DiffComment ctermfg=15 ctermbg=237
endfun

augroup ash_syntax_hacks
    au!
    au FileType diff set nolist
    au FileType diff call Ash_apply_diff_syntax()
augroup end

fun! Ash_experimental_highlightion()
    let ext=substitute(Ash_get_context_var('file'), '.*\.', '', 'g')
    execute 'set ft=' . ext

    call Ash_apply_diff_syntax()
endfun

command! -b AshExperimentalHighglightion call Ash_experimental_highlightion()
