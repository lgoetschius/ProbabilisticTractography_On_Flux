#!/bin/bash

########################## C Count Outliers Script ##########################

# Purpose: The purose of this script is to count the number of outliers in a dMRI file.

# Set Variables Here
subject=$1
data_dir=/scratch/lsa_flux/lcgayle

###################### Do Not Edit Below This Line #######################
# make sure that both fsl and mrtrix are loaded together
module list

echo "Running Subject ${subject}"

cd ${data_dir}

subFolder=${data_dir}/${subject}/raw

cd ${subFolder}/dwipreproc-tmp-*

#awk '{ for(i=1;i<=NF;i++)sum+=$i } END { print sum }' dwi_post_eddy.eddy_outlier_map

wc -l dwi_post_eddy.eddy_outlier_report

