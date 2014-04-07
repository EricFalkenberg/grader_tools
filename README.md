graderTools
===========

A set of shell scripts and general grader tools for CS lab instructors at
Rochester Institute of Technology.

<INSTRUCTIONS>
	1.  Run init.sh with the name of the new skeleton folder heirarchy into
		which the students' submissions will be unzipped and processed:
			"/path/to/init.sh newFolderName"
	2.  Move into the new folder and:
		a) Put all provided files (including test programs) in the
			"provided_files" directory.
		b) Put all expected test output text files in the "tests" directory.
		c) If there is any text that should be appended to all student
			feedback files, put it in grading_guide.txt.
	3.  Move out of the new folder and run grade.sh with:
			"/path/to/grade.sh zipFileName destinationFolderName {required_files ..}"
		where destinationFolderName is the folder created in step 1 and
		required_files is a list of files expected from each student,
		separated by spaces.
