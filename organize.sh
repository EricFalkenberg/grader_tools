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
## 3) Run script with 
##    "/path/to/organize.sh zipFileName newFolderName {filesToKeepPerSub ..}"
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



# Helper function to check if given file name is in the list of
# desired files.
# 
# Usage: contains "element" arrayOfElements
function contains() {
    local n=$#
    local value=${!n}
    for ((i=1;i < $#;i++)) {
        if [ "${!i}" == "${value}" ]; then
            echo "y"
            return 0
        fi
    }
    echo "n"
    return 1
}


# Main program.

# if successfully unzipped main zip file
if unzip "$1" -d "$2"; then

    cd "$2"

    ALL_FILES="*.*"

    #for every student's zip file
    for old_name in $ALL_FILES; do
        # Clean the file name for each student submission.
        # (should be student's name with no #s, -'s, or spaces.)
        new_name=${old_name//[0-9]/}
        new_name=${new_name// - /}
        new_name=${new_name// /_}
        # chop off .zip file ending and any "Lab"/"Project" descriptors.
        new_name=${new_name//.zip/}
        new_name=${new_name//[Ll][Aa][Bb]/}
        new_name=${new_name//[Pp][Rr][Oo][Jj][Ee][Cc][Tt]/}

        # Create a cleanly-named directory for each student.
        if [ ! -d "$new_name" ]; then
            # echo "Making student directory: $new_name"
            mkdir "$new_name"
        fi

        # unzip each student's submission.zip into the new directory.
        temp="${old_name//.zip/}"
        if unzip "$old_name" -d "$temp"; then
            # unzip into new directory and move to correct directory level,
            # then delete old zip archive.

            # echo "Successfully unzipped $old_name into $temp"

            for student_file in "$temp"/$ALL_FILES; do
                mv "$student_file" "$new_name"/
            done

            rm -r "${temp}"

            rm -r "${old_name}"

            # look through all student files and process them.
            cd "$new_name"
            for student_file in $ALL_FILES; do
                # if this file should be kept, keep it. otherwise, delete it.
                if [ $(contains "${@:2}" "$student_file") == "n" ]; then
                    if [ -f "$student_file" ]; then
                        # echo "deleting bad file $student_file..."
                        rm "$student_file"
                    elif [ -d "$student_file" ]; then
                        # echo "deleting bad directory $student_file..."
                        rm -r "$student_file"
                    else
                        echo "ERROR. $student_file neither file nor directory!"
                    fi
                fi
            done
            cd ..
        else
            echo "FAILED TO UNZIP $old_name"
        fi
    done

    cd ..
else
    echo "FAILED TO UNZIP $1"
fi