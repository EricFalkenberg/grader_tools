#!/bin/bash

## This script will take a zip of zip/py/java files
## and organize them into sub-directories for each student.
## It will also rename directly submitted python files to their appropriate
## name once moved into a sub-direcotry.
##
## Feel free to improve upon this in any way
##
## Written for the purpose of making the grading process
## easier for lab instructors / graders at the Rochester 
## Institute of Technology.
## 
## AUTHOR: Eric Falkenberg <exf4789@rit.edu>
## AUTHOR: Kaitlin Hipkin <kah5368@rit.edu>
##
## <HOW TO USE>
## 1) Download all student submissions in a zip file.
##
## 3) Run script with "/path/to/organize.sh outer.zip"
##    (NOTE: if this doesn't run, you will have to
##     run chmod u+x organize.sh to make it executable.)
##
## 4) Sit back and look at all of the glorious
##    time-saving that is being had.
##
## 5) That's it! you're done. Each student will now
##    have his own sub-directory which will contain the appropriate
##    files.
##
## NOTE: Make sure your working directory is void of any non-relevant
## .py / .zip files as they will be looked at and possibly risk
##  breaking the script.
##  To ensure nothing goes wrong, it is advised that you run
##  this script in a folder with nothing but student files.
##

new_main_folder="submissions"
#if successfully unzipped main zip file
if unzip "$1" -d "$new_main_folder"/; then
    cd "$new_main_folder"

    #for every student's zip file
    for old_student_zip in *.zip; do

        if [ -f "$old_student_zip" ]; then
            # unzip each student's zip into a new directory.
            # (directory to be created should be student's name with
            # no numbers, -'s, or spaces.)
            dirname=${old_student_zip//[0-9]/}
            dirname=${dirname//-/}
            dirname=${dirname// /}
            # chop off .zip file extension
            dirname=${dirname//.zip/}
            dirname=${dirname//[Ll][Aa][Bb]/}

            #if such a directory does not exist for the student, create it.
            if [ ! -d "$dirname" ]; then
                echo "Making student directory: $dirname"
                mkdir "$dirname"
            fi

            # unzip into new directory and delete old zip archive.
            echo "unzipping $old_student_zip in $dirname"
            unzip "$old_student_zip" -d "$dirname"
            echo "deleting $old_student_zip"
            rm "$old_student_zip"
        fi
    done

    cd ..
fi