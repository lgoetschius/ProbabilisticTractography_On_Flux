#!/bin/bash

############################### ProbtrackX Peak Consolidator Script ################################### 
# Created by Leigh Goetschius
# Date of Last Edit: 07.21.2017
# Initials of Last Editor: LG

# Purpose: The purpose of this script is to combine all of the peak files created using 
# the previous scripts into one file. 

peak=RAmy_peak_BA9_29_62_30

subjectlist=/Volumes/csmonk/csmonk-lab/Data/Fragile_Families/probtrackx_analysis/group_data_newclean/${peak}/included_subjects.txt
data_dir=/Volumes/csmonk/csmonk-lab/Data/Fragile_Families/probtrackx_analysis/group_data_newclean/${peak}
output_dir=/Volumes/csmonk/csmonk-lab/Data/Fragile_Families/probtrackx_analysis/group_data_newclean/peak_outputs
output_file=${peak}_all.txt

########################### Do Not Edit Below This Line #################################
# State which peak we're currently working with.
echo "Compiling data from " ${peak}
# Read in the subject list to a variable.
subjectlist=$(<${subjectlist})

# Write the data from each of the individual text files into one text file. 
for subject in ${subjectlist} ; do
	echo ${subject}
	
	data=$(<${data_dir}/${subject}.txt)
	echo ${data} >> ${output_dir}/${output_file}
	
	echo "Data from " ${subject} "has been added to the" ${peak} " list."
	
done
