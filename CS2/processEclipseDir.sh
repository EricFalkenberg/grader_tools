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
	cd "src"
	shopt -s nullglob
    for file in *; do
    	if [ -f "$file" ]; then
	    	mv "$file" ../../
	    else
	    	# if student included version control folder, ignore it.
	    	if [ "$file" != "CVS" ] && [ "$file" != "_MACOSX" ]; then
		    	mv "$file" ../../
		    fi
	    fi
    done
    foundSrc="True"
    cd ..
# if it was not the project folder, attempt to find and move into the project folder.
else
	shopt -s nullglob
    for thing in *; do
    	# if it is a directory, move into it and continue looking for "src".
    	if [ -d "$thing" ]; then
			cd "$thing"
			# if src folder successfully located, move into src folder and
			# move all source files up to student's main folder.
			if [ -d "src" ]; then
				cd "src"
				shopt -s nullglob
				for file in *; do
					if [ -f "$file" ]; then
						mv "$file" ../../../
					else
	    				# if student included version control folder, ignore it.
				    	if [ "$file" != "CVS" ] && [ "$file" != "_MACOSX" ]; then
				    		mv "$file" ../../../
						fi
				    fi
		        done
	        	foundSrc="True"
    			cd ..
	        fi
	        cd ..
	    else
	    	foundSrc="True"
	    	mv "$thing" ../
	    fi
    done
fi


cd ..

# if source files successfully extracted, remove subdirectory and mark submission.
if [ "$foundSrc" == "True" ]; then
	rm -r "$1"
	touch BAD_SUB.txt
fi