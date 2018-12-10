#!/bin/bash

############################### ProbtrackX Cluster script ################################### 
# Created by Leigh Goetschius
# Date of Last Edit: 06.29.2017
# Initials of Last Editor: LG

# Purpose: The purpose of this script is to make a mask of the peak coordinates identified
# in the PostProbtrackX script and extract the individual values from that mask. You will
# need to enter the version number and the subject list created from that version from the
# previous script. 

# A note about the peak coordinates used in this script. They will NOT be exactly what
# is exported in the txt file created in the PostProbtrackX script.Those coordinates are
# in tract space (I think), so you need to look in fsleyes where they line up in MNI space.
# See section about this in manual if you have questions.


# Set which version of the subject list we're working with and the seed. Make sure it matches the peak
# coordinates you're working with. Set output name as well. Output should be description of
# peak coordinates to keep the folders straight later.
version=LVS_BA9_092718
seed=LVSSeed_BA9Target
target=L_BA9
output=LVS_peak_BA9_49_73_29

# Set the directories we're working from. 
group_dir=/Volumes/csmonk/csmonk-lab/Data/Fragile_Families/probtrackx_analysis/group_data_newclean
output_dir=/Volumes/csmonk/csmonk-lab/Data/Fragile_Families/probtrackx_analysis/group_data_newclean/${output}
subject_dir=/Volumes/csmonk/csmonk-lab/Data/Fragile_Families/probtrackx_analysis/subject_data_newclean

# Enter the coordinates peak coordinates.
# The format of these coordinates should be: coords="X 1 Y 1 Z 1 0 1" Enter in your X Y and Z
# Do not change anything else. 
coords="49 1 73 1 29 1 0 1" 

# Specify your sphere radius.
rad=3


############################### Do not edit below this line ################################### 

# Make output directory.
cd ${group_dir}

if [ -d "$output" ]; then
	echo "${output} already exists"
	exit
else
	mkdir ${output_dir}
	echo "Working on extracting data for" ${output}
fi

# Make a NII file with specified peak coordinate
fslmaths ${FSLDIR}/data/standard/avg152T1_brain.nii.gz -mul 0 -add 1 -roi ${coords} ${output_dir}/peak -odt float

# Make a sphere around that point.
fslmaths ${output_dir}/peak -kernel sphere ${rad} -fmean ${output_dir}/sphere -odt float

# Binarize that sphere.
fslmaths ${output_dir}/sphere.nii.gz -bin ${output_dir}/sphere_bin.nii.gz

# Extract the mask value for your subject list.
subjectlist=$(<${subject_dir}/${version}.txt)
cp ${subject_dir}/${version}.txt ${output_dir}/included_subjects.txt

for subject in ${subjectlist} ; do
	fslmeants -i ${subject_dir}/${subject}/${seed}/seeds_to_${target}_waytotal.nii.gz \
	-o ${output_dir}/${subject}.txt -m ${output_dir}/sphere_bin.nii.gz
done

echo "Mean values from the sphere have been extracted and saved in the specified directory."
