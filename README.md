
vim-NotableFt
================

This plugin changes the behaviour of the `f`, `F`, `t`, `T`, `;` and `,` commands to only match on characters that are considered 'notable'. This includes:
- The 'humps' of camel case words
- The beginning and end of words
- Any non-word characters like `. , : ( !`

Note that these rules only apply when the given search character is lower case.  This is because while this behaviour is what you want almost all the time, sometimes you still want to be able to search for characters that are not 'notable'.  You can do this using upper case search.

For example, given this line:

`this is a test line`

With your cursor at the beginning, if you search `fi`, your cursor will move to the word 'is' (^ represents cursor)

`this ^s a test line`

Whereas, if you search `fI` instead, your cursor will move to:

`th^s is a test line`

This plugin also adds the following behaviour:
- Multiline - Can search across multiple lines or continue searching across multiple lines using `;` and `,` keys
- Highlighting - Highlights all matching characters on current line, previous matching line, and next matching line
- Allows repeating `t` and `T` commands using `;` or `,` commands

It's also worth noting that it only adds the new position to the jumplist if you've changed lines

###Customization###

If you have remapped any of the `f`/`F`/`t`/`T`/`;`/`,` keys you can still use the plugin without changing it, by including the following in your .vimrc:

`let g:NotableFtUseDefaults = 0`

With this set, NotableFT will not remap anything.  You can then remap whatever keys you want to the following `<plug>NotableFt` mappings:

    <plug>NotableFtRepeatSearchForward
    <plug>NotableFtRepeatSearchBackward
    <plug>NotableFtSearchFForward
    <plug>NotableFtSearchFBackward
    <plug>NotableFtSearchTForward
    <plug>NotableFtSearchTBackward

See the file `NotableFt.vim` for an example of how to map to these.

