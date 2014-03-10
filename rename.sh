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
##     run chmod u+x organize.sh to make it executable.)
##
## 

ALL_FILES="*.zip"
for old_name in $ALL_FILES; do
	# Clean the file name for each student submission.
	# (should be student's name with no #s, -'s, or spaces.)
	new_name=${old_name//[0-9]/}
	new_name=${new_name//-/}
	new_name=${new_name//_/}
	new_name=${new_name//,/_}
	# chop off "Lab"/"Project"/"Submission" descriptors.
	new_name=${new_name//[Ll][Aa][Bb]/}
	new_name=${new_name//[Pp][Rr][Oo][Jj][Ee][Cc][Tt]/}
	new_name=${new_name//[Ss][Uu][Bb][Mm][Ii][Ss][Ss][Ii][Oo][Nn]/}

	if [ ! "$old_name"=="$new_name" ]; then
		mv "$old_name" "$new_name"
	fi

	echo "$old_name renamed to $new_name"
	
done