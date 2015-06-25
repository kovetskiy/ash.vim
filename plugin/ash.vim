if exists('g:loaded_ash') || &cp 
    finish
endif

let g:loaded_ash = 1

fun! AshApplyDiffSyntax()
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

fun! AshExperimentalHighlighting()
    let ext = substitute(AshGetContextVar('file'), '.*\.', '', 'g')
    execute 'set ft=' . ext

    call AshApplyDiffSyntax()
endfun

command! -b AshExperimentalHighlighting call AshExperimentalHighlighting()
