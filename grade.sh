#!/bin/bash

## This script will go through all student directories, compile the code,
## run all test programs, and compare output to expected output.
## All diffs will be appended to that student's "feedback.txt" file.
## 
## AUTHOR: Kaitlin Hipkin <kah5368@rit.edu>
##
## <HOW TO USE>
## 
## 1) Run script with
##    "/path/to/grade.sh zipFileName destinationFolderName {required_files ..}"
##    (NOTE: if this doesn't run, you will have to
##     run chmod u+x grade.sh to make it executable.)
## 
## 



# Main program.
path_to_graderTools="${0//grade.sh/}"

# run script to process student submissions
bash "${path_to_graderTools}process.sh" "${@}"