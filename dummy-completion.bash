#!/bin/bash

_dummy_completions(){
	#COMPREPLY=($(compgen -W "now tomorrow never" "${COMP_WORDS[1]}"))
	if [ "${#COMP_WORDS[@]}" != "2" ]; then
	  return
  	fi
	COMPREPLY=($(compgen -W "$(fc -l -50 | sed 's/\t//')" -- "${COMP_WORDS[1]}"))
}

#complete -W "now tomorrow never" dummy

complete -F _dummy_completions dummy
