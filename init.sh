#!/bin/bash

## This script will set up a folder with the specified name that will hold
## the information and student submissions used, modified, and processed by process.sh.
## 
## Desired resulting folder heirarchy:
##		./
##				feedback/
##				provided_files/
##					provided_files
##					test_files
##				tests/
##					correct_test_output_files
##				grading_guide.txt
##      
##      All test programs should be of the form "Test#.java".
##      The corresponding expected output files should be 
##          of the form "Test#-out.txt" where # is the same for the test program.
## 
## AUTHOR: Kaitlin Hipkin <kah5368@rit.edu>
##
## <HOW TO USE>
## 
## 1) Run script with
##    "/path/to/init.sh newFolderName"
##    (NOTE: if this doesn't run, you will have to
##     run chmod u+x init.sh to make it executable.)
## 
## 


mkdir "$1"
cd "$1"
mkdir "provided_files"
mkdir "tests"
mkdir "feedback"
touch "grading_guide.txt"
cd ..