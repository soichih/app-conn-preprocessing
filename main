#!/bin/bash

#PBS -l nodes=1:ppn=12
#PBS -l walltime=01:00:00

#export MATLABPATH=/usr/local/matlab-libs

#clean up previous run
rm -rf output
rm output.mat

module load matlab
module load spm8
module load conn

export MATLABPATH=$MATLABPATH:/usr/local/matlab-libs/spm8
export MATLABPATH=$MATLABPATH:/usr/local/matlab-libs/conn17f
export MATLABPATH=$MATLABPATH:/usr/local/jsonlab

time matlab -nodisplay -nosplash -r preprocess


