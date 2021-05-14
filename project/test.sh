#!/usr/bin/env bash
read -r -d '' usage <<EOF
Usage: $(basename $0) [OPTION] [TEST]...
Run analysis on test contracts.
By default runs on all contracts.

    -h, --help      Display help and exit
EOF

TESTS=(
    '0,Tainted'
    '1,Tainted'
    '2,Safe'
    '3,Safe'
    '4,Tainted'
    '5,Safe'
    '6,Tainted'
    '7,Tainted'
    '7_1,Safe'
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
    '12_1,Safe'
    '12_2,Safe'
    '13,Safe'
    '14,Safe'
    '15,Safe'
    '16,Safe'
    '17,Safe'
    '18,Tainted'
    '19,Safe'
    '20,Safe'
    '21,Safe'
    '22_1,Safe'
    '22_2,Safe'
    '22_3,Tainted' # Contract is safe, but should be tainted due to depth
    '23_1,Tainted'
    '23_2,Tainted'
    '23_3,Tainted'
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

clean=0
failed=0
imprecise=0
unsound=0
unknown=0
total=0

for i in "${TESTS[@]}"; do
    while IFS=, read -r num expected; do
        should_run $num || continue
        out=$(python analyze.py test_contracts/$num.sol)
        if [[ $out != $expected ]]; then
            echo "${num}.sol failed: Got $out, expected $expected"
            ((failed+=1))

            if [[ $out == "Safe" ]]; then
                # out=Safe, expected=Tainted --> Unsound!
                ((unsound+=1))
            elif [[ $out == "Tainted" ]]; then
                # out=Tainted, expected=Safe --> Imprecise!
                ((imprecise+=1))
            else
                # Unknown output!
                ((unknown+=1))
            fi
        else
            echo "${num}.sol worked"
            ((clean+=1))
        fi
        ((total+=1))
    done <<< $i
done

# Summary
echo ""
echo "=================================================="
echo ""
echo "Test summary"
echo ""
echo "${total} test(s) run"
echo "- ${clean} test(s) worked"
echo "- ${failed} test(s) failed"
echo "  - ${unsound} unsound"
echo "  - ${imprecise} imprecise"
echo "  - ${unknown} unknown"
echo ""
echo "=================================================="
echo ""
echo "Conclusion:"

# Conclusion
if (( failed == 0 )); then
    echo "All tests passed"
    exit 0
fi

if (( unsound > 0 )); then
    echo "The analyzer is unsound!"
fi
if (( imprecise > 0 )); then
    echo "The analyzer is imprecise!"
fi
if (( unknown > 0 )); then
    echo "The analyzer has unknown output!"
fi

exit 1
