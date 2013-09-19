## This script will take a directory of zip/py files downloaded
## from mycourses and organize them into sub-directories by student
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
##
## <HOW TO USE>
## 1) Download all student files from mycourses
##    and extract them to your working directory
##
## 2) Move organize.sh into working directory
##
## 3) Run script with ./organize.sh
##    (NOTE: if this doesn't run, you will have to
##     run chmod u+r organize.sh to make it executable)
##
## 4) Sit back and look at all of the glorious time
##    time-saving that is being had.
##
## 5) That's it! you're done. Each student will now
##    have it's own sub-directory which will contain the neccessary
##    python files.
##
## NOTE: Make sure your working directory is void of any non-relevant
## .py / .zip files as they will be looked at and possibly risk
##  breaking the script.
##  To ensure nothing goes wrong, it is advised that you run
##  this script in a folder with nothing but student files.
##
FILES="*.*"

#for every file in current directory
for f in $FILES
do
    
    arrIN=${f//-/ }    #split file by -
    dirname=${f%-*}    #directory to be created
    fname=${arrIN[-1]} #name of file with the name cut off

    #if a directory does not exist for the student, create one
    if [ ! -d "$dirname" ];
    then
        if [ "${f: -3}" == ".py" ] || [ "${f: -4}" == ".zip" ];
	    then
            echo "Making directory: $dirname"
	    mkdir "$dirname"
	fi
    fi
    #move files to corresponding directory and unzip/rename
    if [ "${f: -4}" == ".zip" ];
    then
        mv "$f" ./"$dirname"/"$fname"
        echo "moving $f to $dirname"
        unzip ./"$dirname"/"$fname" -d ./"$dirname"
    fi
    if [ "${f: -3}" == ".py" ];
    then
        mv "$f" ./"$dirname"/"$fname"
        echo "moving .py to $dirname"
    fi
done
