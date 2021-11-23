#!/bin/bash
shopt -s globstar

# ref: https://stackoverflow.com/questions/45703760/testing-multiple-ltl-formulae-with-spin

function set_trail_name()
{
    sed -i "s/^\\(char \\*TrailFile =\\)\\(.*\\)$/\\1 \"${1}\";/" "${2}";
}

function check_property()
{
    set_trail_name "${2}" pan.c
    gcc -w -o pan pan.c
    result=$(./pan -a -n -i -N "${2}")

    if [[ $result == *"errors: 0"* ]]; then
        echo -e "\e[32mCorrect!\e[m"
    else
        echo -e "\e[31mFailed\e[m\\n"
        echo "$result" | grep -E "pan:[0-9]:"
        echo ""
        echo -e "\e[31mtraceback\e[m\\n"
        [ -f ${2}.trail ] && cp ${2}.trail ${1%.pml}.trail
        spin -p -t "${1#./}"
        echo ""
        clean
        exit 1
    fi
}

function check_properties()
{
    set -e

    spin -a "${1}"

    # Cのプリプロセスを書けたのちltl文を抽出する
    cp ${1} ${1%.pml}.c
    gcc -E ${1%.pml}.c -o ${1%.pml}.expanded.pml
    mapfile -t properties < <(gawk 'match($0, /^ltl ([^{]+) .*$/, a) { print a[1] }' "${1%.pml}.expanded.pml")
    rm ${1%.pml}.expanded.pml
    rm ${1%.pml}.c

    if [[ ! $properties ]]; then
        echo -e "\\n>>>>>> Run\\n"
        check_property "${1}" "run"
    fi

    for prop in "${properties[@]}"
    do
        echo -e "\\n>>>>>> Property ${prop}\\n"
        check_property "${1}" "${prop}"
    done

    set +e
}

function clean()
{
    rm pan && rm pan.* 2> /dev/null
    rm _spin_*.tmp 2> /dev/null
    rm -r ./**/*.trail 2> /dev/null
}

if [[ $1 == "" ]]; then
    echo "No file selected."
fi

for I in ${1}; do
    echo ">>> Testing file $I ..."
    check_properties "$I"
    clean
done
exit 0
