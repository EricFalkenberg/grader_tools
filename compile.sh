#!/bin/bash

## This script will go through all student directories, process
## and organize provided, test, and student-written files,
## and compile them if possible.
##
## AUTHOR: Kaitlin Hipkin <kah5368@rit.edu>
##
## <HOW TO USE>
## 1) Run script from same folder as student directories with
##    "/path/to/compile.sh"
##    (NOTE: if this doesn't run, you will have to
##     run chmod u+x organize.sh to make it executable.)
##
## NOTE: Make sure you do not have any other folders at this directory level,
##          as the script will attempt to process them as student directories.
##          This would probably end badly.
##
## TODO:  Implement reading of files names for three categories either from
##          command line or from a .txt file.
## 

# Main program.

provided_files=( "BrowserUtil.java" "Diagnostics.java" "TextStyle.java" "BadChildException.java" )
test_files=( "Test1.java" "Test2.java" "Test3.java" "Test4.java" "Test5.java" "Test6.java" "TestObject.java" "TestParser.java" )
student_files=( "HeaderObject.java" "ListObject.java" "ParagraphObject.java" "RootObject.java" "Sequence.java" "StyleObject.java" "TextObject.java" )

shopt -s nullglob
for file in *; do
# for file in "Mingus_Zachary"; do
    if [ -d "$file" ]; then
        if [ "$file" != "tests" ]; then
            cd "$file"
            # process provided programs, test programs, and student-written programs
            
            for prov in "${provided_files[@]}"; do
                if [ -f "$prov" ]; then
                    echo "...removing $file's $prov..."
                    # rm "$prov"
                fi
                if [ ! -f "$prov" ]; then
                    echo "...copying $prov to $file's directory..."
                    # cp "../${prov}" .
                fi
            done

            missing_files="False"
            for prog in "${student_files[@]}"; do
                if [ ! -f "$prog" ]; then
                    echo "***Student $file is missing file $prog!!***"
                    missing_files="True"
                fi
            done

            for test in "${test_files[@]}"; do
                if [ -f "$test" ]; then
                    echo "...removing $file's $test..."
                    # rm "$test"
                fi
                if [ ! -f "$test" ]; then
                    echo "...copying $test to $file's directory..."
                    # cp "../${test}" .
                fi
            done

            # if student submitted all of the required files, compile the code.
            if [ "$missing_files" == "False" ]; then
                echo "compiling $file's code......................"
                javac "${provided_files[@]}" "${student_files[@]}" "${test_files[@]}"
                echo ".................................................. DONE! "
            else
                echo "ERROR:  CANNOT COMPILE $file's CODE. SRC FILES MISSING."
            fi

            cd ..
        fi
            
    fi
done