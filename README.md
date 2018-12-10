# ProbabilisticTractography On Flux

The scripts in this folder will help to preprocess diffusion MRI data and to run a probabilistic tractography analysis on that data. All of the scripts here are written to be run on a gpu-capable computing cluster (specifically the Flux Cluster at the University of Michgian). This is by no means the only way to run a probabilistic tractography analysis and may not be the best fit for your question. 

### Script Order
1. A2_Convert (pbs/sh)
2. C_countoutliers (pbs/sh)
3. D_format (pbs/sh)
4. bet (pbs/sh)
5. dtifit(pbs/sh)
6. bedpostx_gpu (pbs/sh)
7. regisration (pbs/sh)
8. probtrackx_gpu (pbs/sh)
9. PostProbtrackX.sh
10. probtrackx_cluster.sh
11. Peak_Consolidator.sh

Note: You should not need to use the eddy_correct scripts in this folder if you run the version of data preprocessing in the script order; however, it is available if you use a different data cleaning procedure. 
