#!/usr/bin/env bash
read -r -d '' usage <<EOF
Usage: $(basename $0) [OPTION] [TEST]...
Run analysis on test contracts.
By default runs on all contracts.

    -h, --help      Display help and exit
EOF

TESTS=(
    # '0,Tainted'
    '1,Tainted'
    '2,Safe'
    '3,Safe'
    # '4,Tainted'
    '5,Safe'
    '6,Tainted'
    # '7,Tainted'
    '8_1,Safe'
    '8_2,Safe'
    '8_3,Safe'
    '8_4,Tainted'
    '8_5,Safe'
    '8_6,Tainted'
    '8_7,Tainted'
    '9_1,Safe'
    '9_1,Safe'
    '10,Tainted'
    '10_1,Tainted'
    '10_2,Safe'
    '10_3,Safe'
    '10_4,Tainted'
    '11,Safe'
    '12,Safe'
    '12_1,Tainted'
    '13,Safe'
    '14,Safe'
    '15,Safe'
    '16,Safe'
    '17,Safe'
    '18,Tainted'
)

declare -a to_run
while [ ! -z "$1" ]; do
    case "$1" in
        -h|--help)
            echo "$usage"
            exit 0
            ;;
        *)
            to_run+=("$1")
    esac
    shift
done

should_run ()
{
    local arg=$1

    if (( ${#to_run} == 0 )); then
        return 0;
    fi

    for i in "${to_run[@]}"; do
        if [[ $i == $arg ]]; then
            return 0;
        fi
    done
    return 1
}

return_val=0
for i in "${TESTS[@]}"; do
    while IFS=, read -r num expected; do
        should_run $num || continue
        out=$(python analyze.py test_contracts/$num.sol)
        if [[ $out != $expected ]]; then
            echo "${num}.sol failed: Got $out, expected $expected"
            return_val=1
        fi
    done <<< $i
done

if (( return_val == 0 )); then
    echo "All test(s) passed"
fi
exit $return_val
