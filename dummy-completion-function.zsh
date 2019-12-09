#compdef dummy

__dummy_bash_source() {
	alias shopt=':'
	alias _expand=_bash_expand
	alias _complete=_bash_comp
	emulate -L sh
	setopt kshglob noshglob braceexpand

	source "$@"
}

__dummy_compgen() {
	local completions w
	completions=( $(compgen "$@") ) || return $?

	for w in "${completions[@]}"; do
		if [[ "${w}" = "$1"* ]]; then
			echo "${w}"
		fi
	done
}

__dummy_compopt() {
	true
}

__dummy_get_comp_words_by_ref() {
	cur="${COMP_WORDS[COMP_CWORD]}"
	prev="${COMP_WORDS[${COMP_CWORD}-1]}"
	words=("${COMP_WORDS[@]}")
	cword=("${COMP_CWORD[@]}")
}

autoload -U +X bashcompinit && bashcompinit

LWORD='[[:<:]]'
RWORD='[[:>:]]'
if sed --help 2>&1 | grep -q GNU; then
	LWORD='\<'
	RWORD='\>'
fi

__dummy_convert_bash_to_zsh() {
	sed \
	-e 's/declare -F/whence -w/' \
	-e 's/_get_comp_words_by_ref "\$@"/_get_comp_words_by_ref "\$*"/' \
	-e 's/local \([a-zA-Z0-9_]*\)=/local \1; \1=/' \
	-e "s/${LWORD}_get_comp_words_by_ref${RWORD}/__dummy_get_comp_words_by_ref/g" \
	-e "s/${LWORD}compgen${RWORD}/__dummy_compgen/g" \
	-e "s/${LWORD}compopt${RWORD}/__dummy_compopt/g" \
	-e "s/${LWORD}declare${RWORD}/builtin declare/g" \
	<<'BASH_COMPLETION_EOF'

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

# ex: ts=4 sw=4 et filetype=sh

BASH_COMPLETION_EOF
}

__dummy_bash_source <(__dummy_convert_bash_to_zsh)

_complete dummy  2>/dev/null