#!/bin/bash

########################## C Count Outliers Script ##########################

# Purpose: The purose of this script is to count the number of outliers in a dMRI file.

# Set Variables Here
subject=$1
data_dir=/scratch/lsa_flux/lcgayle

###################### Do Not Edit Below This Line #######################
# make sure that both fsl and mrtrix are loaded together
module list

subFolder=${data_dir}/${subject}/preproc/
cd $subFolder
mrcat $(dwiextract -bzero ${subject}_preproc.mif -) $(dwiextract -no_bzero ${subject}_preproc.mif -)  - | mrconvert - data.nii -export_grad_mrtrix ${subject}_grad_table -export_grad_fsl bvecs bvals
