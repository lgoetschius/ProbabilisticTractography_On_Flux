#!/bin/bash

############################### BET loop script ################################### 
# Created by Leigh Goetschius
# Date of Last Edit: 5/4/2017
# Initials of Last Editor: LG

# Purpose: This script runs the BET command to extract only brain matter and make a mask of
# the brain material. What we need from this is the mask to use for the bedpostX script.
# It operates on the b0 no diffusion weights file that is created using the DTI_dicom_nifti_script.

###################################################################################
subjectdir=/FILEPATH/
cd ${subjectdir}
sublist=$(ls -d)

for sub in ${sublist} ; do
	echo ${sub}
	bet /FILEPATH/nodif /FILEPATH/nodif_brain -f 0.25 -g 0 -m
done


