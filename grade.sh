#!/bin/bash

## This script will go through all student directories, run all
## test programs, and compare output to expected output.
## All diffs will be appended to that student's "feedback.txt" file.
## 
## AUTHOR: Kaitlin Hipkin <kah5368@rit.edu>
##
## <HOW TO USE>
## 
## 1) Run script with
##    "/path/to/grade.sh zipFileName newFolderName {filesToKeepPerSub ..}"
##    (NOTE: if this doesn't run, you will have to
##     run chmod u+x organize.sh to make it executable.)
## 
## TODO:  Alter test.sh and compile.sh so that only submissions that compile
##          are tested.
## 



# Main program.
path_to_graderTools="${0//grade.sh/}"

# run script to organize student submissions
bash "${path_to_graderTools}organize.sh" "${@}"

# run script to (compile and) test all student submissions
bash "${path_to_graderTools}CS2/test.sh"