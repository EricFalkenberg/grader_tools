if [ $# -ge 1 ]
then
    find ./*/ -type d -exec cp $@ {} \;
else
    echo "Usage: cpdown <file1> <file2> ... <file[n]>"
fi
