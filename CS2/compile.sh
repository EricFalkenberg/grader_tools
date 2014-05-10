#!/bin/bash

## This script will go through all student directories, process
## and organize provided, test, and student-written files,
## and compile them if possible.  Puts all issues/error messages
## into each student's directiory in a "feedback" file.
##
## AUTHOR: Kaitlin Hipkin <kah5368@rit.edu>
##
## <HOW TO USE>
## 
## 1) The script expects the following file directory layout:
##      ./
##              student_one/
##                      student_files
##              student_two/
##                      student_files
##              {...}
##              student_n/
##                      student_files
##              feedback/
##                      student_one_feedback
##                      student_two_feedback
##                      {...}
##                      student_n_feedback
##              provided_files/
##                      provided_files
##                      test_files
##              tests/
##                      correct_test_output_files
##              grading_guide.txt
##      
##      All test programs should be of the form "Test#.java".
##      The corresponding expected output files should be 
##          of the form "Test#-out.txt" where # is the same for the test program.
## 
## 2) Run script from same folder as student directories with
##    "/path/to/compile.sh {required_files ...}"
##    (NOTE: if this doesn't run, you will have to
##     run chmod u+x compile.sh to make it executable.)
##
## 
## NOTE: Make sure you do not have any other folders at this directory level,
##          as the script will attempt to process them as student directories.
##          This would potentially end badly.
## 

# Main program.

cd provided_files
provided_files=""
shopt -s nullglob
for prov in *; do
    provided_files="${provided_files} $prov"
done
provided_files=( $provided_files )
cd ..

shopt -s nullglob
for file in *; do
# for file in "Lipp_Aaron"; do
    if [ -d "$file" ]; then
        if [[ "$file" != "tests" && "$file" != "provided_files" && "$file" != "feedback" ]]; then
            cd "$file"

            student_files=${@}

            # process provided programs, test programs, and student-written programs
            feedback_file="../feedback/${file}_feedback.txt"
            if [ -f "$feedback_file" ]; then
                # echo "...removing $feedback_file..."
                rm "$feedback_file"
            fi

            # create file that will collect all error messages/test diffs for each student.
            # append the grading skeleton for this assignment to the beginning of the file.
            touch "$feedback_file"
            cat ../grading_guide.txt >> "$feedback_file"

            # Replaces any provided files (including Test programs) that
            # the student included in the submission with the equivalent provided
            # (solution) programs.  
            shopt -s nullglob
            for given in "${provided_files[@]}"; do
                if [ -f "$given" ]; then
                    # echo "...removing $file's $given..."
                    rm "$given"
                fi
                if [ ! -f "$given" ]; then
                    # echo "...copying $given to $file's directory..."
                    given_src="../provided_files/${given}"
                    if [ -f "$given_src" ]; then
                        cp "$given_src" .
                    fi
                fi
            done

            missing_files="False"
            shopt -s nullglob
            for prog in $student_files; do
                if [ ! -f "$prog" ]; then
                    echo "***Student $file is missing file $prog!!***"
                    echo "MISSING REQUIRED FILE $prog" >> "$feedback_file"
                    missing_files="True"
                fi
            done

            # if student submitted all of the required files, compile and test the code.
            if [ "$missing_files" == "False" ]; then
                find *.java 2>/dev/null 1>dev/null
                if $?; then
                    echo "compiling $file's code......................"
                    javac *.java >> "$feedback_file" 2>&1
                    echo ".................................................. DONE! "
                    bash ../"${0//compile/test}" "$feedback_file"
                fi
            else
                compile_error="ERROR:  CANNOT COMPILE $file's CODE. SRC FILES MISSING"
                echo "$compile_error" | tee -a "$feedback_file"
                echo "" >> "$feedback_file"
                echo "NO TESTS PERFORMED." >> "$feedback_file"
                echo "" >> "$feedback_file"
            fi

            # Remove provided files again, now that compilation and testing are finished.
            # Also remove any .class files that were created during compilation and used for testing.
            shopt -s nullglob
            for given in "${provided_files[@]}"; do
                if [ -f "$given" ]; then
                    # echo "...removing $file's $given..."
                    rm "$given"
                fi
            done
            shopt -s nullglob
            for class in *.class; do
                rm "$class"
            done

            cd ..
        fi
            
    fi
done