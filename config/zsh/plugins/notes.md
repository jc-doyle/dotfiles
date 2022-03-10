## Replace CUTBUFFER in zvm_vi_yank()

```
   printf %s "${CUTBUFFER}" | xclip -sel c
```

## Remove Pure newline

```
	if [[ $1 == precmd ]]; then
   > remove 'print'
		# Initial newline, for spaciousness.
```
