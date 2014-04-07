graderTools
===========

A set of shell scripts and general grader tools for CS lab instructors at
Rochester Institute of Technology.

*Kaitlin Hipkin (kah5368@rit.edu)* && *Eric Falkenberg (exf4789@rit.edu)*


These scripts will unzip a zip file of compressed student submissions,
and for each student:
* compile the code
* run all test programs
* compare output to expected output
* generate a "feedback.txt" file of any error messages or diffs

####INSTRUCTIONS
1.  Run init.sh with the name of the new skeleton folder heirarchy into which the students' submissions will be unzipped and processed: ```/path/to/init.sh newFolder```
2.  Move into the new folder and:
	* Put all provided files (including test programs) in the provided_files" directory.
	* Put all expected test output text files in the "tests" directory.
	* If there is any text that should be appended to all student feedback files, put it in grading_guide.txt.

3.  Move out of the new folder and run grade.sh with: ```/path/to/grade.sh zipFileName destFolder {required_files ..}```
where destFolder is the folder created in step 1 and required_files is a list of files expected from each student, separated by spaces.

######Note!
If any scripts do not run, you will have to fix each problematic script with: ```chmod u+x <script>.sh```
