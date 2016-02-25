" Easy Colour:
"   Author:  A. S. Budden <abudden _at_ gmail _dot_ com>
" Copyright: Copyright (C) 2011 A. S. Budden
"            Permission is hereby granted to use and distribute this code,
"            with or without modifications, provided that this copyright
"            notice is copied with it. Like anything else that's free,
"            the EasyColour plugin is provided *as is* and comes with no
"            warranty of any kind, either expressed or implied. By using
"            this plugin, you agree that in no event will the copyright
"            holder be liable for any damages resulting from the use
"            of this software.

" ---------------------------------------------------------------------
syn clear

redir => highlights
silent hi
redir END

let lines = split(highlights, '\n')
let keywords = []
for line in lines
	let keyword = split(line)[0]
	let keywords += [keyword,]
endfor

try
	syn clear vimVar
catch
endtry

syn match Keyword /^\k\+:/me=e-1
syn match Comment /^\s*#.*/
syn region EasyColourBlock start=/^\(Dark\|Light\)\(Override\)\?:/ end=/^\k/me=s-1 contains=Keyword,Comment
syn region EasyColourDefs start=/^Colours:/ end=/^\k/me=s-1 contains=Keyword,Comment
syn region EasyColourSpecification start=/^\(\t\| \+\)#\@!/ end=/:/ containedin=EasyColourBlock contained
syn region EasyColourCustomColour start=/^\(\t\| \+\)#\@!/ end=/:/ containedin=EasyColourDefs contained
syn region EasyColourLink start=/@/ end=/$/
for keyword in keywords
	if keyword =~ '^\k*$'
		execute 'syn keyword '.keyword.' '.keyword.' containedin=EasyColourSpecification,EasyColourLink contained'
	endif
endfor

for custom_colour in keys(g:EasyColourCustomColours)
	execute 'syn keyword EasyColourCustom'.custom_colour.' '.custom_colour.' containedin=EasyColourCustomColour contained'
	execute 'hi EasyColourCustom'.custom_colour.' guifg='.g:EasyColourCustomColours[custom_colour].' guibg=NONE gui=NONE'
endfor

let b:current_syntax = "EasyColour"
