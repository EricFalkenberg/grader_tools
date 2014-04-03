#!/bin/bash

## This script will go through all student directories, run all
## test programs, and compare output to expected output.
## All diffs will be appended to that student's "feedback.txt" file.
## 
## AUTHOR: Kaitlin Hipkin <kah5368@rit.edu>
##
## <HOW TO USE>
## 
## 1) This script expects the following file directory layout:
##      student_n/
##              student_files
##              provided_files
##              test_files
##      tests/
##              correct_test_output_files
##      
##      All test programs should be of the form "Test#.java".
##      The corresponding expected output files should be 
##          of the form "Test#-out.txt" where # is the same for the test program.
## 
## 2) Run script from each student directory **after successful compilation** with
##    "/path/to/test.sh"
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
    if [[ "$prog" =~ Test[0-9]*.java ]]; then
        toPrint="============found test file $prog============"
        echo "$toPrint"
        echo "$toPrint" >> feedback.txt
        java "${prog//.java/}" > "${student}_out.txt" 2>&1
        diff -w -c "${student}_out.txt" "../tests/${prog//.java/-out.txt}" >> feedback.txt
        echo $'\n\n' >> feedback.txt
        rm "${student}_out.txt"
    fi
done
    