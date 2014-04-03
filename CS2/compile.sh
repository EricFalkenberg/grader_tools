#!/bin/bash

## This script will go through all student directories, process
## and organize provided, test, and student-written files,
## and compile them if possible.  Puts all issues/error messages
## into each student's directiory in the file "feedback.txt".
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
##          This would probably end badly.
##
## TODO:  Figure out best way to handle the inclusion of a grading_guide
##          in students' feedback files.
## 

# Main program.

# provided_files=( "BrowserUtil.java" "Diagnostics.java" "TextStyle.java" "BadChildException.java" )
cd provided_files
echo "PROVIDED FILES:"
provided_files=""
for file in *; do
    provided_files="${provided_files} $file"
done
provided_files=( $provided_files )
cd ..

# student_files=( "HeaderObject.java" "ListObject.java" "ParagraphObject.java" "RootObject.java" "Sequence.java" "StyleObject.java" "TextObject.java" )
student_files="${@}"

shopt -s nullglob
for file in *; do
# for file in "Lipp_Aaron"; do
    if [ -d "$file" ]; then
        if [[ "$file" != "tests" && "$file" != "provided_files" ]]; then
            cd "$file"
            # process provided programs, test programs, and student-written programs
            
            if [ -f "feedback.txt" ]; then
                # echo "...removing $file's feedback.txt..."
                rm "feedback.txt"
            fi

            # create file that will collect all error messages/test diffs for each student.
            # append the grading skeleton for this assignment to the beginning of the file.
            touch "feedback.txt"
            cat ../grading_guide.txt >> feedback.txt

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
                    cp "../provided_files/${given}" .
                fi
            done

            missing_files="False"
            for prog in $student_files; do
                if [ ! -f "$prog" ]; then
                    echo "***Student $file is missing file $prog!!***"
                    echo "MISSING REQUIRED FILE $prog" >> feedback.txt
                    missing_files="True"
                fi
            done

            # if student submitted all of the required files, compile and test the code.
            if [ "$missing_files" == "False" ]; then
                echo "compiling $file's code......................"
                javac *.java >> feedback.txt 2>&1
                echo ".................................................. DONE! "
                bash ../"${0//compile/test}"
            else
                compile_error="ERROR:  CANNOT COMPILE $file's CODE. SRC FILES MISSING"
                echo "$compile_error"
                echo "$compile_error" >> feedback.txt
                echo "" >> feedback.txt
                echo "NO TESTS PERFORMED." >> feedback.txt
                echo "" >> feedback.txt
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