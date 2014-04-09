#!/bin/bash

## This script will take a zip of zip/py/java files
## and organize them into sub-directories for each student.
## It will also rename directly submitted python files to their appropriate
## name once moved into a sub-direcotry.
##
## Feel free to improve upon this in any way.
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
## 2) Run init.sh and populate the resulting directory with necessary provided files 
##      (including tests), expected output for each test, and a grading_guide.txt.
##
## 3) Run script with 
##    "/path/to/process.sh zipFileName destinationFolderName {required_files ...}"
##    (NOTE: if this doesn't run, you will have to
##     run chmod u+x process.sh to make it executable.)
##
## 4) Sit back and look at all of the glorious
##    time-saving that is being had.
##
## 5) That's it! you're done. Each student will now have his/her own sub-directory
##      containing the appropriate files.
##
## 

ALL_FILES=*.*

# Main program.
if [ $# -gt 2 ]
then
    # if specified main zip file can be unzipped into the specified destination folder
    if unzip "$1" -d "$2"; then

        cd "$2"
        echo "******MOVING INTO $2******"

        # delete the incredibly annoying index.html file that MyCourses gives you.
        if [ -f "index.html" ]; then
            rm "index.html"
        fi

        path_to_graderTools=../"${0//process.sh/}"

        # Clean all .zip file names to work with CheatChecker software.
        bash "${path_to_graderTools}general/rename.sh"

        #for every student's zip file
        shopt -s nullglob
        for zip_name in *.zip; do
            echo "PROCESSING SUBMISSION $zip_name"
            # chop off .zip file ending.
            new_name=${zip_name//.zip/}

            # Create a cleanly-named directory for each student.
            if [ ! -d "$new_name" ]; then
                mkdir "$new_name"
            fi

            # unzip each student's submission.zip into the new directory.
            temp="${new_name}_temp"
            if unzip "$zip_name" -d "$temp" > "temp.txt" 2>&1; then
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
                # if the student has a weird directory, attempt to process it as an
                # eclipse directory. 
                for student_file in *; do
                    if [ -d "$student_file" ]; then
                        echo "** Student $new_name has bad directory $student_file..."
                        echo "TRYING TO EXTRACT FILES FROM ECLIPSE DIRECTORY...."
                        bash ../"${path_to_graderTools}CS2/processEclipseDir.sh" "$student_file"
                    fi
                done
                cd ..
                echo "******BACKING UP******"
            else
                echo "FAILED TO UNZIP $zip_name"
            fi
            if [ -f "temp.txt" ]; then
                rm "temp.txt"
            fi
        done
        # run script to compile (and test) the submissions.
        bash "${path_to_graderTools}CS2/compile.sh" "${@:3}"
        cd ..
        echo "******BACKING UP******"
    else
        echo "FAILED TO UNZIP $1"
    fi
else
    echo "Usage: process <zipFileName> <newFolderName> {required_files ...}"
fi

