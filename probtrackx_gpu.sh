########################### Make Targets.txt, ProbtrackX2 ###############################
## Created by Leigh Goetschius and Bennet Fauber
## June 2017

# The purpose of this script is to create the targets.txt file that is
# called by probtrackx, transform the necessary files to diffusion space,  and then actually run probtrackx2. It should then transform them back to standard space.  This should be run via pbs job on the
# flux cluster using the ptx2.pbs script.

if [ -z "$1" ] ; then
    echo "No argument given.  Bye bye"
    exit 1
fi

subject=$1
echo "Running subject $subject"

# Set the subject directory here as a variable to make the subsequent
# commands shorter and easier to read (we hope)
subject_dir="/scratch/lsa_flux/lcgayle/${subject}.bedpostX_gpu"
scratch_dir="/scratch/lsa_flux/lcgayle"
output_dir="RAmySeed_BA11Target"
home_dir="/home/lcgayle"

# Set your mask variables.
seed="RAmy_aal.nii"
terminator="none"
lowres4matrix2="none"

# Make the targets.txt file for probtrackx
echo /scratch/lsa_flux/lcgayle/masks/R_BA11.nii \
 > ${subject_dir}/targets.txt
# echo /scratch/lsa_flux/lcgayle/masks/BA24_L_121516.nii >> $subject_dir/targets.txt

# Create the list of image files for flirt
#img="LAmy_aal.nii RAmy_aal.nii L_BAsRZ.nii R_BAsRZ.nii"
#img="$img l_corpus_callosum_aal.nii r_corpus_callosum_aal.nii"

# Can enter in additional targets to print to the subjects.txt file,
# but make sure there are two > so that it appends the text rather than
# overwrites


####################### THE COMMANDS ##################################
# **Some commands have been commented out below. They can be used if you want to transform your masks into diffusion space and then transform all of the data back into MNI space at the end.** #

# Run flirt on each of the files to be used in the analysis.
# for i in $img ; do
#     echo "${i}"
#     flirt -in $subject_dir/../masks/${i} -applyxfm                \
#           -init ${subject_dir}/xfms/standard2diff.mat \
#           -out ${subject_dir}/${i}                               \
#           -paddingsize 0.0 -interp trilinear                       \
#           -ref ${scratch_dir}/${subject}/data.nii
# done

# Create a private, local folder to work from; for things that do
# a lot of reading/writing of files, this will speed things up by
# a factor of about three.
TMP_DIR=$(mktemp -d)

# Move into that directory
cd $TMP_DIR

# Copy all the files we will need into that tmp dir
# cp -R ${subject_dir}/ ./
cp -R ${subject_dir}/ ./
cp -R ${scratch_dir}/masks/ ./
cp -R ${scratch_dir}/${subject}/ ./
# List all of the files we've copies over in the tmp dir
echo "File Listing"
ls -l

# Do the probtrackx2!
probtrackx2_gpu -x $TMP_DIR/masks/${seed}                   \
                -l --onewaycondition -c 0.2 -S 2000 --steplength=0.5        \
                -P 5000 --fibthresh=0.01 --distthresh=0.1 --sampvox=0.0     \
		--xfm=/$TMP_DIR/${subject}.bedpostX_gpu/xfms/standard2diff.mat   \
		--opd  \
                --forcedir --opd -s $TMP_DIR/${subject}.bedpostX_gpu/merged \
                -m $TMP_DIR/${subject}.bedpostX_gpu/nodif_brain_mask        \
                --dir=$TMP_DIR/${output_dir}                 \
                --targetmasks=$TMP_DIR/${subject}.bedpostX_gpu/targets.txt               \
                --os2t --s2tastext 

# Transform the Seed_to_Target files back to standard space.
# cd ${output_dir}

#  for output in $(ls seeds_to_*) ; do
#        echo "${output}"
#        flirt -in $TMP_DIR/${subject}.bedpostX_gpu/${output_dir}/${output}.nii -applyxfm \
#        -init $TMP_DIR/${subject}.bedpostX_gpu/xfms/diff2standard.mat \
#        -out $TMP_DIR/${subject}.bedpostX_gpu/${output_dir}/standard_${output}.nii     \
#        -paddingsize 0.0 -interp trilinear                       \
#        -ref ${home_dir}/MNI152_T1_2mm_brain.nii.gz
# done

#  Move the output back to scratch
cp -rp $TMP_DIR/${output_dir} ${subject_dir}

# Check to see if it worked
rc=$?

if [ $rc -eq 0 ] ; then
    cd /tmp
    #  Remove temporary copies
    rm -rf $TMP_DIR
else
    echo "The copy did not work.  Grab the files from"
    echo "$(hostname -s):/$TMP_DIR"
fi

