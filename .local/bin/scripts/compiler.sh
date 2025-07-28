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
    local compiler="$1"

    local cc_options=()
    # cc_options+=(-g -O0)
    cc_options+=(-O3)
    # cc_options+=(-m32)
    cc_options+=(-Wall)
    cc_options+=(-Wextra)
    cc_options+=(-pedantic)

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

    if [ "$compiler" = "gcc" ] || [ "$compiler" = "clang" ]; then
        "${compiler}" "${cc_options[@]}" -o "$file_base" "$file_name" "${c_libs[@]}"
    elif [ "$compiler" = "g++" ] || [ "$compiler" = "clang++" ]; then
        "${compiler}" "${cc_options[@]}" "${cpp_options[@]}" -o "$file_base" "$file_name" "${c_libs[@]}"
    fi
}

build_action() {
    case "$file_name" in
        *config\.h)     sudo make install clean ;;
        *\.c|*\.h)      run_c_cpp_build gcc ;;
        *\.cpp|*\.hpp)  run_c_cpp_build g++ ;;
        *\.tex)         get_tex_root ; pdflatex -draftmode "$file_name" ; bibtex "$file_base" ; pdflatex "$file_name" ; pdflatex "$file_name" ;;
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
        *\.c|*\.h)      run_c_cpp_build clang ;;
        *\.cpp|*\.hpp)  run_c_cpp_build clang++ ;;
        *\.md)          pandoc "$file_name" -t beamer --pdf-engine=xelatex -o "$file_base.pdf" ;;
        # *\.md)          pandoc "$file_name" --pdf-engine=pdfroff -o "$file_base.pdf" ;;
        *)              echo "No alt build for '$file_name'" 1>&2 && exit 1 ;;
    esac
}

run_action() {
    case "$file_name" in
        *\.py)          python3 "$file_name" ;;
        *\.tex|*\.md|*\.typ)    setsid xdg-open "$file_base.pdf" & ;;
        *\.go)          go run "$file_name" ;;
        *\.html)        $BROWSER "$file_name" ;;
        *[Xx]resources) xrdb -merge "$file_name" ;;
        *\.js)          node "$file_name" ;;
        *\.ledger)      ledger -f "$LEDGER" --strict --real balance asset ;;
        *\.1)           man -l "$file_name" ;;
        *)              "$file_base" ;;
    esac
}

run_alt_action() {
    case "$file_name" in
        *\.c|*\.h|*\.[ch]pp|*\.s)   test -f "$file_base" && objdump -Cd "$file_base" > "$file_base.s" ;;
        *\.tex)         get_tex_root ; xelatex "$file_name" ;;
        *[Xx]resources) xrdb -remove ;;
        *)              echo "No action for '$file_name'" 1>&2 && exit 1 ;;
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
