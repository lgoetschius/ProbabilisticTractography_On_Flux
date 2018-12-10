
#!/bin/bash

########################## A2 Convert Script ##########################

# Purpose: The purpose of this script is to convert the compiled
# NII file to a mrtrix file and then run eddy correction/preprocessing
# on the data. The data at this point have NOT undergone any artifact
# rejection/correction.

# Set Variables Here
subject=$1
data_dir=/scratch/lsa_flux/lcgayle

###################### Do Not Edit Below This Line #######################
# make sure loaded modules match this list
# $ module load gcc/5.4.0 fftw/3.3.4/gcc/5.4.0
# $ module load  mrtrix/3.0_RC3 fsl/5.0.10 cuda/7.5
# Currently Loaded Modules:
#   1) gcc/5.4.0              3) mrtrix/3.0_RC3   5) cuda/7.5
#   2) fftw/3.3.4/gcc/5.4.0   4) fsl/5.0.10

module list

echo "Running Subject ${subject}"

cd ${data_dir}

mkdir ${data_dir}/${subject}/preproc
	
subFolder=${data_dir}/${subject}/raw
saveFolder=${data_dir}/${subject}/preproc

cd $subFolder

# Convert NII file to MIF format.
mrconvert -fslgrad ${subject}.bvec ${subject}.bval ${subFolder}/${subject}.nii ${saveFolder}/${subject}.mif

# Denoise the subject data.
dwidenoise ${saveFolder}/${subject}.mif ${saveFolder}/${subject}_denoised.mif -noise ${saveFolder}/${subject}_noise.mif

# Run the real, actual preprocessing
dwipreproc ${saveFolder}/${subject}_denoised.mif \
    ${saveFolder}/${subject}_preproc.mif \
    -rpe_none -pe_dir j -eddy_options \
    '--niter=8 --fwhm=10,6,4,2,0,0,0,0 --repol --ol_type=both --mporder=8 --s2v_niter=8 --dont_peas --ol_type=both --mporder=8 --s2v_niter=8 --slspec=/home/lcgayle/slspec.txt' \
    -nocleanup -force

