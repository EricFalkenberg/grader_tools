#!/bin/bash

## This script will take all zip files
## and rename them to work with the CheatChecker software.
## 
## AUTHOR: Kaitlin Hipkin <kah5368@rit.edu>
##
## <HOW TO USE>
## 1) Run script with 
##    "/path/to/rename.sh"
##    (NOTE: if this doesn't run, you will have to
##     run chmod u+x rename.sh to make it executable.)
##

shopt -s nullglob
ALL_FILES="*"
for old_name in $ALL_FILES; do
	if [[ "$old_name" != "grading_guide.txt" && "$old_name" != "feedback" && "$old_name" != "provided_files" && "$old_name" != "tests" ]]; then
		
		# chop off "Lab"/"Project"/"Submission" descriptors.
		new_name=${old_name//[Ll][Aa][Bb]/}
		new_name=${new_name//[Pp][Rr][Oo][Jj][Ee][Cc][Tt]/}
		new_name=${new_name//[Pp][Rr][Oo][Jj]/}
		new_name=${new_name//[Pp][Aa][Rr][Tt]/}
		new_name=${new_name//[Ss][Uu][Bb][Mm][Ii][Ss][Ss][Ii][Oo][Nn]/}

		# Remove the student's username, if present.
		new_name=${new_name//[a-zA-Z][a-zA-Z][a-zA-Z][0-9][0-9][0-9][0-9]/}
		new_name=${new_name//[a-zA-Z][a-zA-Z][0-9][0-9][0-9][0-9]/}
		
		# Clean the file name for each student submission.
		# (should be student's name with no #s, -'s, or spaces.)
		new_name=${new_name//[0-9]/}
		new_name=${new_name//-/}
		new_name=${new_name// /}
		new_name=${new_name//,/_}

		# Copy file and contents into new file and delete old file.\
		if [ -f "$old_name" ]; then
			cp "$old_name" "$new_name"
			rm "$old_name"
		fi
		if [ -d "$old_name" ]; then
			mv "$old_name" "$new_name"
		fi

	fi
done