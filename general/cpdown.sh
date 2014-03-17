##
##   Name: cpdown.sh
##   Description: Program that will take a set of files as input
##   and recursively copy them down into all sub-directories.
##
##   This program is useful in the case where all student submissions
##   require the addition of a faculty written module to be present
##   in the student directory.
##
##   Usage: cpdown <file1> <file2> ... <file[n]>
##   NOTE: Make sure to run in the working directory and none other.
##   I accidentally ran this on root once and I cried forever.
##
if [ $# -ge 1 ]
then
    find ./*/ -type d -exec cp $@ {} \;
else
    echo "Usage: cpdown <file1> <file2> ... <file[n]>"
fi
