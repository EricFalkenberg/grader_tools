#!/bin/bash

## This script will go through all student directories, run all
## test programs, and compare output to expected output.
## All diffs will be appended to that student's "feedback.txt" file.
## 
## AUTHOR: Kaitlin Hipkin <kah5368@rit.edu>
##
## <HOW TO USE>
## 
## 1) Run compile.sh as directed to ensure the file directory adheres to
##      the expected layout.
## 
## 2) For reference, this script expects the following file directory layout:
##      ./
##              student_one/
##                      student_files
##                      provided_files
##                      test_files
##              student_two/
##                      student_files
##                      provided_files
##                      test_files
##              {...}
##              student_n/
##                      student_files
##                      provided_files
##                      test_files
##              tests/
##                      expected_test_output_files
##      
##      All test programs should be of the form "Test#.java".
##      The corresponding expected output files should be 
##          of the form "Test#-out.txt" where # is the same for the test program.
## 
## 2) Run script from same folder as student directories with
##    "/path/to/test.sh"
##    (NOTE: if this doesn't run, you will have to
##     run chmod u+x organize.sh to make it executable.)
##
## 
## NOTE: Make sure you do not have any other folders at this directory level,
##          as the script will attempt to process them as student directories.
##          This would probably end badly.
##
## TODO:  Implement reading of files names for three categories either from
##          command line or from a .txt file.
## 



# Main program.

# run script to compile everything as directed.
bash "${0//test/compile}"

shopt -s nullglob
for file in *; do
# for file in "Bao_Feifei"; do
    if [ -d "$file" ]; then
        if [ "$file" != "tests" ]; then
            cd "$file"
            echo "TESTING STUDENT $file's SUBMISSION"
            # for each program in student directory, if it is a test program, run it.
            for prog in *; do
                if [[ "$prog" =~ Test[0-9]*.java ]]; then
                    toPrint="============found test file $prog============"
                    echo "$toPrint"
                    echo "$toPrint" >> feedback.txt
                    java "${prog//.java/}" > "student_out.txt" 2>&1
                    diff -w -c "student_out.txt" "../tests/${prog//.java/-out.txt}" >> feedback.txt
                    echo $'\n\n' >> feedback.txt
                    rm student_out.txt
                fi
            done
            cd ..
        fi
            
    fi
done