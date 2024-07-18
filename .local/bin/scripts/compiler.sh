#!/bin/bash

mode=
if [ "$#" -gt 1 ]; then
    mode="$1"
    shift
fi

file=$(readlink -f "$1")
dir=$(dirname "$file")
base="${file%.*}"

cd "$dir" || exit

get_root() {
    grep -q '% !TeX root = ' "$file" || return
    root_file=$(sed -n 's/^% !TeX root = \(.\+\)$/\1/p' "$file")
    file=$(readlink -f "$root_file")
    dir=$(dirname "$file")
    cd "$dir" || return
    file=$(realpath --relative-to="$PWD" "$file")
    base="${file%.*}"
}

run_c_cpp_build() {
    local lang="$1"

    local cc=gcc
    # local cc=clang
    local cpp=g++
    # local cpp=clang++

    local cc_options=()
    cc_options+=(-g -O0)
    # cc_options+=(-m32)
    cc_options+=(-Wall)
    cc_options+=(-Wextra)
    # cc_options+=(-pedantic)

    local cpp_options=()
    cpp_options+=(--std=c++20)
    # cpp_options+=(--std=c++17)
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
        "${cc}" "${cc_options[@]}" -o "$base" "$file" "${c_libs[@]}"
    elif [ "$lang" = "cpp" ]; then
        "${cpp}" "${cc_options[@]}" "${cpp_options[@]}" -o "$base" "$file" "${c_libs[@]}"
    fi
}

if [ -z "$mode" ]; then
    case "$file" in
        *config\.h)         sudo make install clean ;;
        *\.c|*\.h)          run_c_cpp_build c ;;
        *\.cpp|*\.hpp)      run_c_cpp_build cpp ;;
        *\.py)              python3 "$file" ;;
        *\.tex)             get_root ; pdflatex -draftmode "$file" ; bibtex "$base" ; pdflatex "$file" ; pdflatex "$file" ;;
        *\.md)              lowdown --parse-no-intraemph "$file" -Tms | groff -mpdfmark -ms -kept -T pdf > "$base.pdf" ;;
        *\.go)              go build . ;;
        *\.html)            $BROWSER "$file" ;;
        *[Xx]resources)     xrdb -merge "$file" ;;
        *CMakeLists\.txt)   cd ./build && cmake .. && make ;;
        *\.js)              node "$file" ;;
        *)                  sed 1q "$file" | grep "^#!/" | sed "s/^#!//" | xargs -r -I % "$file" ;;
    esac
elif [ "$mode" == "run" ]; then
    case "$file" in
        *\.tex|*\.md)       setsid xdg-open "$base.pdf" & disown ;;
        *\.go)              go run "$file" ;;
        *)                  "$base" ;;
    esac
elif [ "$mode" == "other" ]; then
    case "$file" in
        *\.c|*\.h|*\.[ch]pp|*\.s)   test -f "$base" && objdump -Cd "$base" > "$base.s" ;;
        *\.tex)             get_root ; xelatex "$file" ;;
        *\.md)              pandoc "$file" -t beamer --pdf-engine=xelatex -o "$base.pdf" ;;
        *[Xx]resources)     xrdb -remove ;;
        *)                  echo "Not found: $file" ;;
    esac
elif [ "$mode" == "old" ]; then
    case "$file" in
        *\.md)              pandoc "$file" --pdf-engine=pdfroff -o "$base.pdf" ;;
        *)                  echo "Not found: $file" ;;
    esac
fi
