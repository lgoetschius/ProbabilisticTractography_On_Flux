#!/bin/bash

########################### FDT Registration ############################
## Created by Leigh Goetschius and Bennet Fauber
## May 2017

# This script runs FDT registration following bedpostX and before probtrackx2. It should be run using a pbs job command from the reg_array.pbs script. In that script, modify the number of subjects you are running and the subject list. In this script, only modify the filepaths depending on where the data is kept. The commands themselves should not need to change. 

if [ -z "$1" ] ; then
    echo "No argument given.  Bye bye"
    exit 1
fi

subject=$1
echo "Running subject $subject"

#  Make sure that we load fsl
module load fsl

#  Do the work

flirt -in /scratch/lsa_flux/lcgayle/${subject}.bedpostX_gpu/nodif_brain -ref /scratch/lsa_flux/lcgayle/${subject}/T1_acpc.nii.gz -omat /scratch/lsa_flux/lcgayle/${subject}.bedpostX_gpu/xfms/diff2str.mat -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6 -cost corratio

convert_xfm -omat /scratch/lsa_flux/lcgayle/${subject}.bedpostX_gpu/xfms/str2diff.mat -inverse /scratch/lsa_flux/lcgayle/${subject}.bedpostX_gpu/xfms/diff2str.mat

flirt -in /scratch/lsa_flux/lcgayle/${subject}/T1_acpc.nii -ref /home/lcgayle/MNI152_T1_2mm_brain.nii.gz -omat /scratch/lsa_flux/lcgayle/${subject}.bedpostX_gpu/xfms/str2standard.mat -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12 -cost corratio

convert_xfm -omat /scratch/lsa_flux/lcgayle/${subject}.bedpostX_gpu/xfms/standard2str.mat -inverse /scratch/lsa_flux/lcgayle/${subject}.bedpostX_gpu/xfms/str2standard.mat

convert_xfm -omat /scratch/lsa_flux/lcgayle/${subject}.bedpostX_gpu/xfms/diff2standard.mat -concat /scratch/lsa_flux/lcgayle/${subject}.bedpostX_gpu/xfms/str2standard.mat /scratch/lsa_flux/lcgayle/${subject}.bedpostX_gpu/xfms/diff2str.mat

convert_xfm -omat /scratch/lsa_flux/lcgayle/${subject}.bedpostX_gpu/xfms/standard2diff.mat -inverse /scratch/lsa_flux/lcgayle/${subject}.bedpostX_gpu/xfms/diff2standard.mat

