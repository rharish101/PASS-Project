#!/usr/bin/env bash
read -r -d '' usage <<EOS
Usage: $(basename $0) [OPTION] [TEST]...
Run analysis on test contracts.
By default runs on all contracts.

    -h, --help      Display help and exit
    -c, --colour    Force coloured output
EOS

TESTS_DIR="test_contracts"

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
        if [[ "$test_path" =~ $i ]]; then
            return 0;
        fi
    done
    return 1
}

ns_to_s ()
{
    local duration="$1"
    printf "%.3f" $(echo "$duration / 1000000000" | bc -l)
}

clean=0
failed=0
imprecise=0
unsound=0
unknown=0
total=0

score=0
max_score=0

min_time=$(echo "120 * 10^9" | bc -l)
max_time=0
total_time=0

shopt -s globstar
test_paths="$(ls "$TESTS_DIR"/**/*.sol | sort -V)"

IFS=$'\n'
for test_path in $test_paths; do
    should_run "$test_path" || continue
    expected="$(awk 'NR==4 {print $NF}' < "$test_path")"

    ((total+=1))
    if [[ "$expected" == "Safe" ]]; then
        ((max_score+=1))
    fi

    name="$(realpath --relative-to="$TESTS_DIR" "$test_path")"

    start_time=$(date +"%s%N")
    out="$(python analyze.py "$test_path" | sed 's/^\s*//;s/\s*$//')"
    end_time=$(date +"%s%N")
    curr_time=$((end_time - start_time))

    ((total_time+=$curr_time))
    if (( curr_time < min_time )); then
        min_time=$curr_time
    fi
    if (( curr_time > max_time )); then
        max_time=$curr_time
    fi

    if [[ "$out" != "$expected" ]]; then
        echo "$name $(colour red failed): Got $out, expected $expected - $(ns_to_s $curr_time)s"
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
        echo "$name $(colour green worked) - $(ns_to_s $curr_time)s"
        ((clean+=1))
        if [[ "$out" == "Safe" ]]; then
            ((score+=1))
        fi
    fi
done
unset IFS

if (( total == 0 )); then
    echo "No tests run"
    exit 0
fi

# Summary
echo "\
==================================================

Test summary

${total} test(s) run
- ${clean} test(s) worked
- ${failed} test(s) failed
  - ${unsound} unsound
  - ${imprecise} imprecise
  - ${unknown} unknown

Total score: ${score}/${max_score}

Minimum test time - $(ns_to_s $min_time)s
Maximum test time - $(ns_to_s $max_time)s
Average test time - $(ns_to_s $((total_time / total)))s
Total test time - $(ns_to_s $total_time)s

==================================================

Conclusion:"

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
