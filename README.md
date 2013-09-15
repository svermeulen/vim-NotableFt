vim-extended-ft
================

This plugin adds the following behaviour to the default behaviour of the `f`, `F`, `t`, and `T` commands:
- Multiline - Can search across multiple lines or continue searching across multiple lines using `;` and `,` keys
- Smart Case - When the search character is lower case it matches both lower and upper case, and when the character is uppercase it matches only upper case.

###Customization###

If you have remapped any of the `f`/`F`/`t`/`T`/`;`/`,` keys you can still use the plugin without changing it, by including the following in your .vimrc:

`let g:ExtendedFTUseDefaults = 0`

And then remapping the desired keys to the `<plug>` mappings in your .vimrc (see the bottom of the file vim-extended-ft.vim for an example).
