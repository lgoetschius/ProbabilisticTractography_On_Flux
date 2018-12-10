#!/bin/bash

############################### DTI Fit loop script ################################### 
# Created by Leigh Goetschius
# Date of Last Edit: 6/5/2017
# Initials of Last Editor: LG

# Purpose: This script runs the DTIfit script. The purpose of this script is to fit a 
# diffusion tensor model at each voxel. You run this on data that has been pre-processed 
# and eddy current corrected. This isn't necessary to do in order to run probtrackx2, but 
# it is a QC check to make sure that the tensor bvecs and bvals are in the correct direction.

### At this point, the files should have been artifact rejected and eddy current corrected. 
### BET should have also been run. 
subjectdir=/FILEPATH/
cd ${subjectdir}
sublist=$(ls -d)



for sub in ${sublist} ; do

	# Print which subject you're working with.
	echo ${sub}
	# This command will switch into the subject's directory if the subject exists.
	
		# Run the DTIfit command.
		dtifit --data=/FILEPATH/${sub}/data.nii.gz --out=/FILEPATH/${sub}/dtifit --mask=/FILEPATH/${sub}/nodif_brain_mask.nii.gz --bvecs=/FILEPATH/${sub}/bvecs --bvals=/FILEPATH/${sub}/bvals
		cd .. ;
done

