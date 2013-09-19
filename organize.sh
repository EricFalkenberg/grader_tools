#This script will take a directory of zip/py files downloaded
#from mycourses and organize them into sub-directories by student
#It will also rename directly submitted python files to their appropriate
#name once moved into a sub-direcotry.
#
#Feel free to improve upon this in any way
#
#Written for the purpose of making the grading process
#easier for lab instructors / graders at the Rochester 
#Institute of Technology.
#AUTHOR: Eric Falkenberg <exf4789@rit.edu>

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
