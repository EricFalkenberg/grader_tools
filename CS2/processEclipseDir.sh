#!/bin/bash

## This script will take go into a folder assuming that it contains
## the student's entire eclipse directory.
## It will attempt to navigate to the student's source folder and
## extract the actual source files.
## It will then move all source files up to the student's main folder
## and delete the rest of the eclipse directory if the extraction was successful.
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

foundSrc="False"

# move into suspected eclipse directory.
cd "$1"

# if suspected directory is actually the project folder, move into
# the src folder to fetch files.
if [ -d "src" ]; then
	echo "***MOVING INTO SRC FOLDER***"
	cd "src"
	shopt -s nullglob
    for file in *; do
    	if [ -f "$file" ]; then
	    	mv "$file" ../../
	    	echo "Moving file $file up two levels to main folder...."
	    else
	    	# if student included version control folder, ignore it.
	    	if [ "$file" != "CVS" ]; then
		    	mv "$file" ../../
		    	echo "Moving folder $file up two levels to main folder...."
		    fi
	    fi
    done
    foundSrc="True"
    cd ..
# if it was not the project folder, attempt to find and move into the project folder.
else
	shopt -s nullglob
    for thing in *; do
    	if [ -d "$thing" ]; then
    		echo "Looking in folder $thing...."
			cd "$thing"
			# if src folder successfully located, move into src folder and
			# move all source files up to student's main folder.
			if [ -d "src" ]; then
				echo "***MOVING INTO SRC FOLDER***"
				cd "src"
				shopt -s nullglob
				for file in *; do
					if [ -f "$file" ]; then
						mv "$file" ../../../
						echo "Moving file $file up three levels to main folder...."
					else
				    	if [ "$file" != "CVS" ]; then
				    		mv "$file" ../../../
							echo "Moving folder $file up three levels to main folder...."
						fi
				    fi
		        done
				echo "***BACKING UP***"
	        	foundSrc="True"
    			cd ..
	        else
	        	echo "No src folder found in $thing!"
	        fi
	        echo "***BACKING UP***"
	        cd ..
	    else
	    	echo "Found file $thing instead of src folder. Processing as src file......"
	    	foundSrc="True"
	    	mv "$thing" ../
	    	echo "Moving file $thing up one level to main folder...."
	    fi
    done
fi


echo "***BACKING UP***"
cd ..

if [ "$foundSrc" == "True" ]; then
	echo "Source files successfully extracted. Removing directory $1..."
	rm -r "$1"
	touch BAD_SUB.txt
fi