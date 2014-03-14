#!/bin/bash

## This script will take go into a folder assuming that it contains
## the student's entire eclipse directory.
## It will attempt to navigate to the student's source folder and
## extract the actual source files.
## It will then move all source files up to the student's main folder
## and delete the rest of the eclipse directory.
## 
## AUTHOR: Kaitlin Hipkin <kah5368@rit.edu>
##
## TODO: What to do if the directory is not actually an eclipse directory?
##
## <HOW TO USE>
## 1) Run script with 
##    "/path/to/processEclipseDir.sh <directory>"
##    (NOTE: if this doesn't run, you will have to
##     run chmod u+x processEclipseDir.sh to make it executable.)
##

# move into suspected eclipse directory.
cd "$1"

# if suspected directory is actually the project folder, move into
# the src folder to fetch files.
if cd "src"; then
	shopt -s nullglob
    for file in *; do
    	mv "$file" ../../
    	echo "Moving file $file up to main folder...."
    done
    cd ..
# if suspected directory is not the project folder, move into the project folder.
# NOTE: bash will ignore extra arguments after "cd <folder>",
# BUT THIS IS NOT GUARANTEED FOR ALL SHELLS.  Exercise caution.
elif cd *; then
	# move into src folder and move all files up to student's main folder.
	if cd "src"; then
		shopt -s nullglob
        for file in *; do
        	mv "$file" ../../../
        	echo "Moving file $file up to main folder...."
        done
        cd ..
	else 
		echo "ERROR: No src folder found!"
	fi
	cd ..
else
	echo "ERROR: Could not find project folder??!!"
fi

cd ..