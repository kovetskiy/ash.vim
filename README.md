Installation
============

```
Bundle 'kovetskiy/ash.vim'
```

Usage
=====

## Inbox

```
:Unite ash_inbox
```

## List reviews

```
:Unite ash_lsreviews:repo/project[:type]
" or just type
:Unite ash_lsreviews
```

## Review single file

```
:Unite ash_review:repo/project/pr
" or just type
:Unite ash_review
```

## Automatic highlighting

```viml
au User UniteAshLoaded call AshExperimentalHighlighing()
```
