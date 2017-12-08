# app-conn-preprocessing
fMRI preprocessing via CONN

Lorenzo Pasquini PhD, December 2017 
lorenzo.pasquini@ucsf.edu, 
Memory and Aging Center UCSF

This script was derived from the CONN toolbox script
(conn_batch_workshop_nyudataset.m; https://sites.google.com/view/conn/resources/source) 
which was used for the NYU_CSC_TestRetest dataset 
(published in Shehzad et al., 2009, The Resting Brain: Unconstrained yet Reliable. Cerebral Cortex. doi:10.1093/cercor/bhn256).

This script can be used to preprocess resting-state fMRI data and performs following steps:
1. realignment
2. slice-timing correction
3. outlier identification
4. coregistration with structural scan
5. segmentation of structural MRI in grey matter, white matter and CSF
6. Normalization of structural and subsequently of functional files 
7. Spatial smoothing
8. Temporal filtering and the aCompCor method are subsequently used to control for residual physiological and motion artifacts (e.g. head movement, white-matter, CSF)
9. Finally, first level analyses are performed resulting in ROI-to-ROI and seed-to-voxel functional connectiviy estimates using the atlas implemented in CONN (a combination of FSL Harvard-Oxford atlas cortical & subcortical areas and AAL atlas cerebellar areas)

To perform this steps you need to have the CONN and SPM12 toolboxes installed in MATLAB. Repeatedly running the script for the same subject will overwrite the old data.

Needed INPUTS: 
1. Individual raw resting-state fMRI files, converted from DICOM to 4D nifti files 
2. Individual structural MRI files, also as nifti files

OUTPUTS:
1. Denoised resting-state fMRI files - to be found in output/results/preprocessing/niftiDATA_Sub*.nii
2. ROI-to-ROI connectivity matrix (resultsROI_Subject###_Condition###.mat) and seed-to-voxel functional connectiviy (BETA.*nii) estimates in output/results/firstlevel/ANALYSIS-01. The file _list_sources.mat gives the identity of the 168 sources used to perfrom the analysis (164 ROIs + conditions)
3. Time series of confounds and ROIs in output/DATA/ROI_Subject###_Condition###.mat
4. Output.mat and preprocess.m can be used to retrieve information on the performed preprocessing steps and used script

PARAMETERS:
The user needs to define several parameters when starting the preprocessing pipeline:
1. TR (in seconds, e.g. 2)
2. slice acquisition order (e.g. 'ascending','descending','interleaved (middle-top)','interleaved (bottom-up)','interleaved (top-down)', 'interleaved (Siemens)','BIDS')
3. smoothing kernel (fwhm, defualt is 8mm)
4. Choose template normalization (default is MNI)
5. Spatial filter range in Hz (default is 0.01 for min and 0.1 for max)
6. Whether to perform gobal signal regression or not

If you use this script, please cite the CONN functional connectivity toolbox (Whitfield-Gabrieli, S., and Nieto-Castanon, 2012; http://www.nitrc.org/projects/conn.)
Further information such as a the CONN manual and a description of the functions can be found here: https://sites.google.com/view/conn/resources/manuals. 
