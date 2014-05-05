#!/bin/bash

## This script will go through all student directories, run all
## test programs, and compare output to expected output.
## All diffs will be appended to that student's feedback file.
## 
## AUTHOR: Kaitlin Hipkin <kah5368@rit.edu>
##
## <HOW TO USE>
## 
## 1) This script expects the following file directory layout:
## 		feedback/
##         		current_student_feedback
##      CURRENT_STUDENT_DIRECTORY/
##              student_files
##              provided_files
##              test_files
##      tests/
##              correct_test_output_files
##      
##      All test programs should be of the form "Test*.java".
##      The corresponding expected output files should be 
##          of the form "Test*-out.txt" where * is the same for the test program.
## 
## 2) Run script from each student directory **after successful compilation** with
##    "/path/to/test.sh feedback_file"
##    (NOTE: if this doesn't run, you will have to
##     run chmod u+x test.sh to make it executable.)
##
## 



# Main program.

shopt -s nullglob

student="${PWD##*/}"
echo "TESTING STUDENT $student's SUBMISSION"

# for each program in student directory, if it is a test program, run it.
for prog in *; do
    if [[ "$prog" =~ [Tt]est[0-9a-zA-Z]* ]]; then

        toPrint="============ test file $prog ============"
        echo "$toPrint"
        echo "$toPrint" >> "$1"
        outfile="${student}_out.txt"

        touch "${outfile}"

        # if it is a .java test file
        if [ "${prog: -5}" == ".java" ]; then
            java "${prog//.java/}" > "$outfile" 2>&1
            expected_out="../tests/${prog//.java/-out.txt}"
        # if it is a shell script
        elif  [ "${prog: -3}" == ".sh" ];then
            bash "${prog}" > "$outfile" 2>&1
            expected_out="../tests/${prog//.sh/-out.txt}"
        # if it is a python test
        elif  [ "${prog: -3}" == ".py" ];then
            python ./"${prog}" > "$outfile" 2>&1
            expected_out="../tests/${prog//.py/-out.txt}"
        fi

        alternate_out="${expected_out//-out/Output}"
        # if file containing expected test output is provided,
        # append diff to feedback file.
        if [ -f "$expected_out" ]; then
            diff -w -c "$outfile" "$expected_out" >> "$1"
        elif [ -f "$alternate_out" ]; then
            diff -w -c "$outfile" "$alternate_out" >> "$1"
        # if no expected output provided, append all output to feedback file.
        else
            cat "$outfile" >> "$1"
        fi
        echo $'\n\n' >> "$1"
        rm "$outfile"
    fi
done
    