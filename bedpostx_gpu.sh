#!/bin/bash

if [ -z "$1" ] ; then
    echo "No argument given.  Bye bye"
    exit 1
fi

subject=$1
echo "Running subject $subject"

# Make sure that we load the needed modules
# module load cuda6.5 fsl
module purge
module --ignore_cache load cuda/6.5 fsl

# Create a private, local folder which will be faster
TMP_DIR=$(mktemp -d)

# Go there
cd $TMP_DIR

# Copy the input folder to here
cp -R /scratch/lsa_flux/lcgayle/$subject ./

echo "File listing"
ls -l

# check where stuff is
echo "Got the right bedpostx_gpu?"
which bedpostx_gpu

# Run bedpost.
bedpostx_gpu $TMP_DIR/$subject/ --nf=2 --fudge=1  --bi=1000

#  Copy just the output file back to the original
mv $TMP_DIR/${subject}.bedpostX  /scratch/lsa_flux/lcgayle/

#  Did the directory copy?
rc=$?

if [ $rc -eq 0 ] ; then
    #  Remove temporary copies
    rm -rf $TMP_DIR
else
    echo "The copy did not work.  Grab the files from"
    echo "$(hostname -s):/$TMP_DIR"
fi

