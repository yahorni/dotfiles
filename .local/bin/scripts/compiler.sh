#!/usr/bin/env bash

set -euo pipefail

build_c_cpp() {
    local compiler="$1"

    local cc_options=()
    # cc_options+=(-g -O0)
    cc_options+=(-O3)
    cc_options+=(-Wall)
    cc_options+=(-Wextra)
    cc_options+=(-Wpedantic)
    cc_options+=(-Wconversion)
    cc_options+=(-Werror)
    # cc_options+=(-m32)

    local cpp_options=()
    # cpp_options+=(--std=c++17)
    # cpp_options+=(--std=c++20)
    cpp_options+=(--std=c++23)
    cpp_options+=(-fsanitize=undefined)
    cpp_options+=(-fsanitize=address)
    cpp_options+=(-fsanitize=signed-integer-overflow)
    # cpp_options+=(-static)

    local c_libs=()
    # c_libs+=(-lpthread)
    # c_libs+=(-lncurses)
    # c_libs+=(-lX11)
    # c_libs+=(-lexplain)
    # c_libs+=($(pkg-config --cflags --libs cairomm-1.0))

    if [ "$compiler" = "gcc" ] || [ "$compiler" = "clang" ]; then
        "${compiler}" "${cc_options[@]}" -o "$file_base" "$file_name" "${c_libs[@]}"
    elif [ "$compiler" = "g++" ] || [ "$compiler" = "clang++" ]; then
        "${compiler}" "${cc_options[@]}" "${cpp_options[@]}" -o "$file_base" "$file_name" "${c_libs[@]}"
    fi
}

build_action() {
    case "$file_name" in
        *config\.h)     sudo make install clean ;;
        *\.c|*\.h)      build_c_cpp gcc ;;
        *\.cpp|*\.hpp)  build_c_cpp g++ ;;
        *\.md)          lowdown --parse-no-intraemph "$file_name" -Tms | groff -mpdfmark -ms -kept -T pdf > "$file_base.pdf" ;;
        *\.go)          go build . ;;
        *\.typ)         typst compile "$file_base.typ" ;;
        *CMakeLists\.txt)   cd ./build && cmake .. && make ;;
        *)              sed 1q "$file_name" | grep "^#!/" | sed "s/^#!//" | xargs -r -I % "$file_name" ;;
    esac
}

build_alt_action() {
    case "$file_name" in
        *config\.h)     make PREFIX=~/.local clean install ;;
        *\.c|*\.h)      build_c_cpp clang ;;
        *\.cpp|*\.hpp)  build_c_cpp clang++ ;;
        *\.md)          pandoc "$file_name" -t beamer --pdf-engine=xelatex -o "$file_base.pdf" ;;
        # *\.md)          pandoc "$file_name" --pdf-engine=pdfroff -o "$file_base.pdf" ;;
        *)              echo "No alt build for '$file_name'" 1>&2 && exit 1 ;;
    esac
}

run_action() {
    case "$file_name" in
        *\.py)          python3 "$file_name" ;;
        *\.md|*\.typ)   setsid xdg-open "$file_base.pdf" & ;;
        *\.go)          go run "$file_name" ;;
        *\.html)        $BROWSER "$file_name" ;;
        *[Xx]resources) xrdb -merge "$file_name" ;;
        *\.js)          node "$file_name" ;;
        *\.ledger)      ledger -f "$LEDGER" --strict --real balance asset ;;
        *\.1)           man -l "$file_name" ;;
        *)  if [ -f "$file_base" ]; then
                "$file_base"
            else
                "$file_name"
            fi
            ;;
    esac
}

run_alt_action() {
    case "$file_name" in
        *\.c|*\.h|*\.[ch]pp|*\.s)
            test -f "$file_base" && objdump -Cd "$file_base" > "$file_base.s" ;;
        *[Xx]resources) xrdb -remove ;;
        *)  echo "No alt run for '$file_name'" 1>&2 && exit 1 ;;
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
    elif [ "$mode" = "build-alt" ]; then
        build_alt_action
    elif [ "$mode" == "run" ]; then
        run_action
    elif [ "$mode" == "run-alt" ]; then
        run_alt_action
    else
        echo "No such mode: $mode" 1>&2 && exit 1
    fi
}

main "$@"
