#!/bin/bash

############################### Post ProbtrackX loop script ################################### 
# Created by Leigh Goetschius
# Date of Last Edit: 06.26.2017
# Initials of Last Editor: LG

# Purpose: The purpose of this script is to transform the seeds_to_TARGET nii file back to 
# standard space. Additionally, we'll divide it by the waytotal to standardize the samples
# in the probtrackx output. After that, we'll create a way to average over the individuals
# to create a composite image and then locate the peaks of that image. 

# Set the directory where your subject data is.
subject_dir=/Volumes/csmonk/csmonk-lab/Data/Fragile_Families/probtrackx_analysis/subject_data_newclean
group_dir=/Volumes/csmonk/csmonk-lab/Data/Fragile_Families/probtrackx_analysis/group_data_newclean


# Create a list of subjects to use in this analysis and count how many there are.
subjectlist=$(cd ${subject_dir}; ls -d 0* | cut -d'.' -f1)
subject_count=$(echo $subjectlist | wc -w | awk '{print $1}')

# What is the bedpostX target you're interested in working with?
version=RAmy_BA9_071618
seed=RAmySeed_BA9Target
targetfile=seeds_to_R_BA9

# Origin subject
originsub=0001


############################### Do not edit below this line ################################### 

echo "Identifying peaks for ${seed}"

for subject in ${subjectlist} ; do
	
	# Confirm which subject we're working with.
	echo "${subject}"
	
	# Print the subject you ran to a subject list txt file whose name is specified by the
	# version above.
	echo "${subject}" >> ${subject_dir}/${version}.txt
	
	# Divide the standard_seeds_to_TARGET image by the waytotal.
	 fslmaths ${subject_dir}/${subject}/${seed}/${targetfile}.nii.gz \
	 -div 5000 ${subject_dir}/${subject}/${seed}/${targetfile}_waytotal
	
done	

echo "Individual seeds_to_target images have been transformed to standard space and divided by the waytotal."

# Use the origin subject set above to begin a file to be added with all subjects. This file will be subtracted later.
fslmaths ${subject_dir}/${originsub}/${seed}/${targetfile}_waytotal.nii.gz \
-add 0 ${group_dir}/${version}.nii.gz

# Add all the standard_waytotal files
for subject in ${subjectlist} ; do
	fslmaths ${group_dir}/${version}.nii.gz -add \
	${subject_dir}/${subject}/${seed}/${targetfile}_waytotal \
	${group_dir}/${version}.nii.gz
done

# Subtract the Origin Subject
fslmaths ${group_dir}/${version}.nii.gz -sub \
${subject_dir}/${originsub}/${seed}/${targetfile}_waytotal.nii.gz \
${group_dir}/${version}_suborigin.nii.gz

# Divide by number of subjects in subject list.
fslmaths ${group_dir}/${version}_suborigin.nii.gz -div ${subject_count} ${group_dir}/${version}_avg.nii.gz

echo "Composite image has been created for the entered subjects."

# Identify peaks in the composite image.
${FSLDIR}/bin/cluster --in=${group_dir}/${version}_avg.nii --thresh=0 --olmax=${group_dir}/${version}_peak.txt

##### From here, move on to the probtrackx_cluster script. #####
echo "Peaks have been identified. Move on to the probtrackx_cluster script."
