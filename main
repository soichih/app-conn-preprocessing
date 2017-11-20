#!/bin/bash

#PBS -l nodes=1:ppn=12
#PBS -l walltime=01:00:00

#export MATLABPATH=/usr/local/matlab-libs

#clean up previous run
rm -rf output
rm output.mat

#for hpc
module load matlab
module load conn
export MATLABPATH=$MATLABPATH:/N/u/brlife/git/spm12
export MATLABPATH=$MATLABPATH:/N/u/brlife/git/jsonlab

#for vm
export MATLABPATH=$MATLABPATH:/usr/local/spm12
export MATLABPATH=$MATLABPATH:/usr/local/conn17f
export MATLABPATH=$MATLABPATH:/usr/local/jsonlab

time matlab -nodisplay -nosplash -r preprocess

#matlab doesn't return proper exit code I need to check output myself
if [ ! -d output ]; then
	echo "missing output"
	exit 1
fi
