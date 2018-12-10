#!/bin/bash

########################## Eddy Correct Script ##########################

# Purpose: The purpose of this script is to correct your 4D DTI data file to remove eddy currents and small 
# head motion. The data shoudl have already been checked for artifacts and have had them removed.

# Set Variables Here
subject=$1
data_dir=/scratch/lsa_flux/lcgayle
eddyid=${subject:2:5}_edited

###################### Do Not Edit Below This Line #######################

if [ -z "$1" ] ; then
    echo "No argument given.  Bye bye"
    exit 1
fi

echo "Running subject $subject"

#  Make sure that we load fsl
module load fsl

#  Working from /tmp is much faster
cd /tmp

#  Create a private, local folder which will be faster
TMP_DIR=$(mktemp -d)

#  Go there
cd $TMP_DIR

#  Copy the folder to here
cp -r ${data_dir}/$subject/ ./

#  Go there
cd ${subject}

#  Do the work
eddy_correct ${eddyid}.nii data.nii.gz 0

#  Copy just the output file back to the origin
cp data.* ${data_dir}/$subject/

#  Remove temporary copies
rm -rf $TMP_DIR

cd ${data_dir}/${subject}
cp ${eddy_id}.bvec bvecs
cp ${eddy_id}.bval bvals
rm ${eddy_id}.nii
rm ${eddy_id}.bval
rm ${eddy_id}.bvec

rm -r old
rm -r raw
rm -r old_080717 
