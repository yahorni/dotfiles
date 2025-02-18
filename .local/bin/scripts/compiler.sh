#!/bin/bash

get_tex_root() {
    grep -q '% !TeX root = ' "$file_name" || return
    root_file=$(sed -n 's/^% !TeX root = \(.\+\)$/\1/p' "$file_name")
    file_name=$(readlink -f "$root_file")
    dir_name=$(dirname "$file_name")
    cd "$dir_name" || return
    file_name=$(realpath --relative-to="$PWD" "$file_name")
    file_base="${file_name%.*}"
}

run_c_cpp_build() {
    local lang="$1"

    local cc=gcc
    # local cc=clang
    local cpp=g++
    # local cpp=clang++

    local cc_options=()
    cc_options+=(-g -O0)
    # cc_options+=(-O3)
    # cc_options+=(-m32)
    cc_options+=(-Wall)
    cc_options+=(-Wextra)
    # cc_options+=(-pedantic)

    local cpp_options=()
    # cpp_options+=(-static)
    # cpp_options+=(--std=c++17)
    # cpp_options+=(--std=c++20)
    cpp_options+=(--std=c++23)
    cpp_options+=(-fsanitize=undefined)
    cpp_options+=(-fsanitize=address)
    cpp_options+=(-fsanitize=signed-integer-overflow)

    local c_libs=()
    # c_libs+=(-lpthread)
    # c_libs+=(-lncurses)
    # c_libs+=(-lX11)
    # c_libs+=(-lexplain)
    # c_libs+=($(pkg-config --cflags --libs cairomm-1.0))

    if [ "$lang" = "c" ]; then
        "${cc}" "${cc_options[@]}" -o "$file_base" "$file_name" "${c_libs[@]}"
    elif [ "$lang" = "cpp" ]; then
        "${cpp}" "${cc_options[@]}" "${cpp_options[@]}" -o "$file_base" "$file_name" "${c_libs[@]}"
    fi
}

build_action() {
    case "$file_name" in
        *config\.h)     sudo make install clean ;;
        *\.c|*\.h)      run_c_cpp_build c ;;
        *\.cpp|*\.hpp)  run_c_cpp_build cpp ;;
        *\.tex)         get_tex_root ; pdflatex -draftmode "$file_name" ; bibtex "$file_base" ; pdflatex "$file_name" ; pdflatex "$file_name" ;;
        *\.md)          lowdown --parse-no-intraemph "$file_name" -Tms | groff -mpdfmark -ms -kept -T pdf > "$file_base.pdf" ;;
        *\.go)          go build . ;;
        *CMakeLists\.txt)   cd ./build && cmake .. && make ;;
        *)              sed 1q "$file_name" | grep "^#!/" | sed "s/^#!//" | xargs -r -I % "$file_name" ;;
    esac
}

run_action() {
    case "$file_name" in
        *\.py)          python3 "$file_name" ;;
        *\.tex|*\.md)   setsid xdg-open "$file_base.pdf" & disown ;;
        *\.go)          go run "$file_name" ;;
        *\.html)        $BROWSER "$file_name" ;;
        *[Xx]resources) xrdb -merge "$file_name" ;;
        *\.js)          node "$file_name" ;;
        *\.ledger)      ledger -f "$LEDGER" --strict --real balance asset ;;
        *\.1)           man -l "$file_name" ;;
        *)              "$file_base" ;;
    esac
}

other_action() {
    case "$file_name" in
        *\.c|*\.h|*\.[ch]pp|*\.s)   test -f "$file_base" && objdump -Cd "$file_base" > "$file_base.s" ;;
        *\.tex)         get_tex_root ; xelatex "$file_name" ;;
        *\.md)          pandoc "$file_name" -t beamer --pdf-engine=xelatex -o "$file_base.pdf" ;;
        *[Xx]resources) xrdb -remove ;;
        *)              echo "No action for '$file_name'" ;;
    esac
}

deprecated_action() {
    case "$file_name" in
        *\.md)              pandoc "$file_name" --pdf-engine=pdfroff -o "$file_base.pdf" ;;
        *)                  echo "No action for '$file_name'" ;;
    esac
}

mode=
file_name=
dir_name=
file_base=

main() {
    if [ "$#" -lt 1 ]; then
        echo "Not enough arguments"
        exit 1
    fi
    mode="$1"
    shift

    file_name=$(readlink -f "$1")
    dir_name=$(dirname "$file_name")
    file_base="${file_name%.*}"

    if ! cd "$dir_name" ; then
        echo "Failed to cd to $dir_name"
        exit 1
    fi

    if [ "$mode" = "build" ]; then
        build_action
    elif [ "$mode" == "run" ]; then
        run_action
    elif [ "$mode" == "other" ]; then
        other_action
    elif [ "$mode" == "deprecated" ]; then
        deprecated_action
    fi
}

main "$@"
