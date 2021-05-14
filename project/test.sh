#!/usr/bin/env bash
read -r -d '' usage <<EOS
Usage: $(basename $0) [OPTION] [TEST]...
Run analysis on test contracts.
By default runs on all contracts.

    -h, --help      Display help and exit
    -c, --colour    Force coloured output
EOS

TESTS=(
    'globals,0,Tainted'
    'locals,1,Tainted'
    'globals,2,Safe'
    'globals,3,Safe'
    'globals,4,Tainted'
    'locals,5,Safe'
    'locals,6,Tainted'
    'functions,7,Tainted'
    'functions,7_1,Safe'
    'globals,8_1,Safe'
    'globals,8_2,Safe'
    'globals,8_3,Safe'
    'globals,8_4,Tainted'
    'globals,8_5,Safe'
    'globals,8_6,Tainted'
    'globals,8_7,Tainted'
    'locals,9_1,Safe'
    'locals,9_1,Safe'
    'locals,10,Tainted'
    'locals,10_1,Tainted'
    'locals,10_2,Safe'
    'locals,10_3,Safe'
    'locals,10_4,Tainted'
    'locals,11,Safe'
    'locals,12,Safe'
    'locals,12_1,Safe'
    'locals,12_2,Safe'
    'locals,13,Safe'
    'locals,14,Safe'
    'locals,15,Safe'
    'locals,16,Safe'
    'globals,17,Safe'
    'globals,18,Tainted'
    'functions,19,Safe'
    'functions,20,Safe'
    'functions,21,Safe'
    'functions,22_1,Safe'
    'functions,22_2,Safe'
    'functions,22_3,Tainted' # Contract is safe, but should be tainted due to depth
    'functions,23_1,Tainted'
    'functions,23_2,Tainted'
    'functions,23_3,Tainted'
)

if [ -t 1 ]; then
    is_terminal=true
else
    is_terminal=false
fi

force_colour=false
declare -a to_run
while [ ! -z "$1" ]; do
    case "$1" in
        -h|--help)
            echo "$usage"
            exit 0
            ;;
        -c|--colour)
            force_color=true
            ;;
        *)
            to_run+=("$1")
    esac
    shift
done

colour ()
{
    local colour_name="$1"
    shift
    local text="$*"

    if [ $is_terminal = false ] && [ $force_colour = false ]; then
        colour_name=""
    fi

    if [[ "$colour_name" == "green" ]]; then
        echo -e "\e[32m${text}\e[0m"
    elif [[ "$colour_name" == "red" ]]; then
        echo -e "\e[31m${text}\e[0m"
    else
        echo "$text"
    fi
}

should_run ()
{
    local folder="$1"
    local num="$2"

    if (( ${#to_run} == 0 )); then
        return 0;
    fi

    for i in "${to_run[@]}"; do
        if [[ "$i" == "$folder" ]] || [[ "$i" == "$num" ]]; then
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

score=0
max_score=0

for i in "${TESTS[@]}"; do
    while IFS=, read -r folder num expected; do
        should_run "$folder" "$num" || continue

        ((total+=1))
        if [[ "$expected" == "Safe" ]]; then
            ((max_score+=1))
        fi

        out="$(python analyze.py "test_contracts/$folder/$num.sol")"
        if [[ "$out" != "$expected" ]]; then
            echo "$folder/$num.sol $(colour red failed): Got $out, expected $expected"
            ((failed+=1))

            if [[ "$out" == "Safe" ]]; then
                # out=Safe, expected=Tainted --> Unsound!
                ((unsound+=1))
                ((score-=2))
            elif [[ "$out" == "Tainted" ]]; then
                # out=Tainted, expected=Safe --> Imprecise!
                ((imprecise+=1))
            else
                # Unknown output!
                ((unknown+=1))
            fi
        else
            echo "$folder/$num.sol $(colour green worked)"
            ((clean+=1))
            if [[ "$out" == "Safe" ]]; then
                ((score+=1))
            fi
        fi
    done <<< "$i"
done

# Summary
read -r -d '' summary <<EOS
==================================================

Test summary

${total} test(s) run
- ${clean} test(s) worked
- ${failed} test(s) failed
  - ${unsound} unsound
  - ${imprecise} imprecise
  - ${unknown} unknown

Total score: ${score}/${max_score}

==================================================

Conclusion:
EOS
echo "$summary"

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
