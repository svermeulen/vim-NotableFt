vim-extended-ft
================

This plugin adds the following behaviour to the default behaviour of the `f`, `F`, `t`, and `T` commands:
- Multiline - Can search across multiple lines or continue searching across multiple lines using `;` and `,` keys
- Smart Case - When the search character is lower case it matches both lower and upper case, and when the character is uppercase it matches only upper case.
- Allow repeating `t` and `T` commands using `;` or `,` commands
- Highlighting - Which is disabled automatically when moving your cursor afterwards

It's also worth noting that it only adds the new position to the jumplist if you've changed lines.

###Seek Operator###

vim-extended-ft also includes an option to use a version of the `f` and `F` operator with two characters instead of one.  This is disabled by default but can be enabled easily by including extra mappings in your vimrc.  See the bottom of the file `extended-ft.vim` for an example (commented out) of what those mappings would look like.

###Customization###

If you have remapped any of the `f`/`F`/`t`/`T`/`;`/`,` keys you can still use the plugin without changing it, by including the following in your .vimrc:

`let g:ExtendedFTUseDefaults = 0`

And then remapping the desired keys to the `<plug>` mappings in your .vimrc (see the bottom of the file vim-extended-ft.vim for an example).

To disable smartcase matching, and either force case-sensitive or case-insensitive, use this option in your .vimrc:

`let g:ExtendedFT_caseOption = `

Possible values:

* '\c' - Forces `ignorecase`
* '\C' - Forces `noignorecase`


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/svermeulen/vim-extended-ft/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

