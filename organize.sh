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
## 

ALL_FILES=*.*

# Helper function to check if given file name is in the list of
# desired files.
# 
# Usage: contains element arrayOfElements
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
if [ $# -gt 2 ]
then
    # if specified main zip file can be unzipped
    if unzip "$1" -d "$2"; then

        cd "$2"
        echo "******MOVING INTO $2******"

        # Clean all .zip file names to work with CheatChecker software.
        bash ../"${0//organize/rename}"

        #for every student's zip file
        shopt -s nullglob
        for zip_name in *.zip; do
            echo "PROCESSING SUBMISSION $zip_name"
            # chop off .zip file ending.
            new_name=${zip_name//.zip/}

            # Create a cleanly-named directory for each student.
            if [ ! -d "$new_name" ]; then
                # echo "Making student directory: $new_name"
                mkdir "$new_name"
            fi

            # unzip each student's submission.zip into the new directory.
            temp="${new_name}_temp"
            if unzip "$zip_name" -d "$temp"; then
                # unzip into new directory and move to correct directory level,
                # then delete old zip archive.

                echo "Successfully unzipped $zip_name"

                shopt -s nullglob
                for student_file in "$temp"/*; do
                    mv "$student_file" "$new_name"/
                    # echo "moved $temp/$student_file into ../$new_name"
                done

                rm -r "$zip_name"
                rm -r "$temp"

                # look through all student files and process them.
                cd "$new_name"
                echo "******MOVING INTO $new_name******"

                shopt -s nullglob
                for student_file in *; do
                    # if this file should be kept, keep it. otherwise, delete it.
                    if [ $(contains "${@:2}" "$student_file") == "n" ]; then
                        if [ -f "$student_file" ]; then
                            echo "** Student $new_name has bad file $student_file..."
                            # rm "$student_file"
                        elif [ -d "$student_file" ]; then
                            echo "** Student $new_name has bad directory $student_file..."
                            # touch BAD_SUB.txt
                            # rm -r "$student_file"
                            echo "TRYING TO EXTRACT FILES FROM ECLIPSE DIRECTORY...."
                            bash ../../"${0//organize/processEclipseDir}" "$student_file"
                        else
                            echo "ERROR. $student_file neither file nor directory!"
                        fi
                    fi
                done
                cd ..
                echo "******BACKING UP******"
            else
                echo "FAILED TO UNZIP $zip_name"
            fi
        done
        cd ..
        echo "******BACKING UP******"
    else
        echo "FAILED TO UNZIP $1"
    fi
else
    echo "Usage: organize <zipFileName> <newFolderName> <goodFile1>... <goodFile[n]>"
fi

