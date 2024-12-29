# toofar

A set of programming suggestions that might indication you've gone too far.

## Never Nesting
toofar will warn about code that is nested to deeply.

Specify the max nesting indent by changing g:toofar_max_indent. The default is 3.
You can also tell toofar to ignore certain filetypes with the g:toofar_ignore_filetypes variable.
For example, you might want to exclude markdown and json files simply add this line to your vimrc.
`g:toofar_ignore_filetypes = ['markdown', 'json']`
