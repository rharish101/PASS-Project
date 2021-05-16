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
    'functions,guard-func-call,Safe'
    'globals,8_1,Safe'
    'globals,8_2,Safe'
    'globals,global-temp-taint,Safe'
    'globals,perma-taint-passing,Tainted'
    'globals,global-temp-perma-taint,Safe'
    'globals,guard-perma-taints,Tainted'
    'globals,local-var-perma-taint-global-clean,Tainted'
    'locals,9_1,Safe'
    'locals,9_1,Safe'
    'locals,10,Tainted'
    'locals,assign-outside-guard,Tainted'
    'locals,assign-inside-guard,Safe'
    'locals,taint-used-in-good-blk,Safe'
    'locals,taint-used-in-bad-blk,Tainted'
    'locals,11,Safe'
    'locals,12,Safe'
    'locals,bool-var-guard,Safe'
    'locals,bool-var-notguard,Tainted'
    'locals,args-inside-guard,Safe'
    'locals,13,Safe'
    'locals,14,Safe'
    'locals,good-blk-taint-plus-bad-blk-clean,Safe'
    'locals,notguard-inside-guard,Safe'
    'globals,perma-taint-local-clean,Safe'
    'globals,return-inside-empty-blk,Tainted'
    'functions,infinite-recursion-safe-global,Safe'
    'functions,infinite-recursion-safe-local,Safe'
    'functions,infinite-recursion-vulnerable-global,Tainted'
    'functions,infinite-recursion-vulnerable-local,Tainted'
    'functions,infinite-recursion-fake-vulnerable-global,Tainted' # Contract is safe, but should be tainted due to depth
    'functions,infinite-recursion-fake-vulnerable-local,Tainted' # Contract is safe, but should be tainted due to depth
    'functions,mutual-recursion-safe-global,Safe'
    'functions,mutual-recursion-safe-local,Safe'
    'functions,mutual-recursion-vulnerable-global,Tainted'
    'functions,mutual-recursion-vulnerable-local,Tainted'
    'functions,mutual-recursion-fake-vulnerable-global,Tainted' # Contract is safe, but should be tainted due to depth
    'functions,mutual-recursion-fake-vulnerable-local,Tainted' # Contract is safe, but should be tainted due to depth
    'functions,clean-function-clean-inside,Safe'
    'functions,clean-function-clean-on-return,Safe'
    'functions,dirty-function-clean-outside,Safe'
    'functions,dirty-function-guard-outside,Safe'
    'functions,nested-guard-recursive,Tainted' # Contract is safe, but should be tainted due to depth
    'functions,nested-guard-1-level,Safe'
    'functions,nested-guard-2-levels,Safe'
    'functions,nested-guard-3-levels,Tainted' # Contract is safe, but should be tainted due to depth
    'functions,nested-notguard-1-level,Tainted'
    'functions,nested-notguard-2-levels,Tainted'
    'functions,nested-notguard-3-levels,Tainted'
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
    local test_path="$1"

    if (( ${#to_run} == 0 )); then
        return 0;
    fi

    for i in "${to_run[@]}"; do
        if [[ "$test_path" == *"$i"* ]]; then
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
        test_path="test_contracts/$folder/$num.sol"
        should_run "$test_path" || continue

        ((total+=1))
        if [[ "$expected" == "Safe" ]]; then
            ((max_score+=1))
        fi

        out="$(python analyze.py "$test_path")"
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
