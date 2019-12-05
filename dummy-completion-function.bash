#!/bin/bash

_dummy_root_command()
{
    last_command="root"

    commands=()
    commands+=("exec")
	commands+=("edit")
    commands+=("get")
}

_root_edit()
{
    last_command="edit"

    commands=()
    commands+=("config")
	commands+=("credential")
}

_edit_config()
{
    last_command=""

    commands=()
}

_edit_credential()
{
    last_command=""

    commands=()
}

_root_exec()
{
    last_command=""

    commands=()
}

_root_get()
{
    last_command=""

    commands=()
}

__dummy_init_completion()
{
    COMPREPLY=()
    _get_comp_words_by_ref "$@" cur prev words cword
}

__dummy_index_of_word()
{
    local w word=$1
    shift
    index=0
    for w in "$@"; do
        [[ $w = "$word" ]] && return
        index=$((index+1))
    done
    index=-1
}

__dummy_contains_word()
{
    local w word=$1; shift
    for w in "$@"; do
        [[ $w = "$word" ]] && return
    done
    return 1
}

__dummy_handle_command()
{

    local next_command
    if [[ -n ${last_command} ]]; then
        next_command="_${last_command}_${words[c]//:/__}"
    else
        if [[ $c -eq 0 ]]; then
            next_command="_dummy_root_command"
        else
            next_command="_${words[c]//:/__}"
        fi
    fi
    c=$((c+1))
    declare -F "$next_command" >/dev/null && $next_command
}


__dummy_handle_reply()
{
    local completions
    completions=("${commands[@]}")
    COMPREPLY=( $(compgen -W "${completions[*]}" -- "$cur") )

}

__dummy_handle_word()
{
    if [[ $c -ge $cword ]]; then
        __dummy_handle_reply
        return
    fi
    if __dummy_contains_word "${words[c]}" "${commands[@]}"; then
        __dummy_handle_command
	fi
	
    __dummy_handle_word
}

__start_dummy()
{
    local cur prev words cword
    __dummy_init_completion -n "=" || return

    local c=0
    local commands=("dummy")
    local last_command

    __dummy_handle_word
}

complete -F __start_dummy dummy
