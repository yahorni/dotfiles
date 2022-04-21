#!/bin/bash
# vim: ts=2 sw=2 sts=2

# NOTE: +R (fields) and +r (extras) comes together

print_usage() {
    echo "usage $(basename "$0") [--help] [--system] <output> <positional_args>..."
    echo "    output - 'tags' by default"
    echo "    positional_args - current directory '.' by default"
    echo
    echo "example:"
    echo "    updtags.sh ~/.local/share/tags /usr/include"
}

set_system_vars() {
    output_file="$HOME/.local/share/tags"
    positional_args=(
        "/usr/include"
        $(find /usr/lib/ -maxdepth 1 -name "python*")
        $(find /usr/local/lib/ -maxdepth 1 -name "python*")
    )
}

check_args() {
    if [ "$1" = "--help" ]; then
        print_usage
        exit
    elif [ "$1" = "--system" ]; then
        set_system_vars
        shift
    else
        output_file=${1:-tags}
        shift
        positional_args=("${@:-.}")
    fi
}

select_binary() {
    if command -v ctags-universal 1>/dev/null ; then
      ctags_exec="ctags-universal"
    elif command -v universal-ctags 1>/dev/null ; then
      ctags_exec="universal-ctags"
    elif command -v ctags 1>/dev/null ; then
      ctags_exec="ctags"
    else
      echo "ctags not found" 1>&2
      exit 1
    fi
}

run_ctags() {
    $ctags_exec --options="$options_path" -f "${output_file}" "${positional_args[@]}"
}

# =================================================================================================================== #

options_path="${XDG_CONFIG_HOME:-$HOME/.config}/ctags/options.ctags"

ctags_exec=
output_file=
positional_args=

# =================================================================================================================== #

check_args "$@"
select_binary
run_ctags
