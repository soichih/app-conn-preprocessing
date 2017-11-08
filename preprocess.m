%% Conn batch 4Soichi
% Lorenzo Pasquini, October 31 2017, UCSF

function [] = preprocess()

clear all; clc;

%switch getenv('ENV')
%case 'IUHPC'
%    disp('loading paths (HPC)')
%    addpath(genpath('/N/u/brlife/git/jsonlab'))
%otherwise
%    disp('loading paths')
%    addpath(genpath('/usr/local/jsonlab'))
%end

% load my own config.json
config = loadjson('config.json')

%% FIND functional/structural files
cwd=pwd;
FUNCTIONAL_FILE=cellstr(conn_dir(config.t1)); %UI
STRUCTURAL_FILE=cellstr(conn_dir(config.bold)); %UI
nsubjects=1;
if rem(length(FUNCTIONAL_FILE),nsubjects),error('mismatch number of functionalfiles');
end
if rem(length(STRUCTURAL_FILE),nsubjects),error('mismatch number of anatomical files');
end
nsessions=length(FUNCTIONAL_FILE)/nsubjects;
FUNCTIONAL_FILE=reshape(FUNCTIONAL_FILE,[nsubjects,nsessions]);
STRUCTURAL_FILE={STRUCTURAL_FILE{1:nsubjects}};
disp([num2str(size(FUNCTIONAL_FILE,1)),' subjects']);
disp([num2str(size(FUNCTIONAL_FILE,2)),' sessions']);
TR=2; % Repetition time = 2 seconds

%% PREPARES connectivity analyses (using default values for all parameters, see help conn_batch to define non-default values)
clear batch;

%% CONN New experiment
%(realignment/coregistration/segmentation/normalization/smoothing)

batch.filename=fullfile(cwd,'output.mat'); 

batch.New.FWHM=config.fwhm; 
batch.New.VOX=config.vox; 
batch.New.sliceorder=[2:2:36,1:2:35];  % UI  
batch.New.steps='default_mni'; 
batch.New.art_thresholds=[5,0.6];

batch.New.functionals=repmat({{}},[nsubjects,1]); % Point to functional volumes for each subject/session
for nsub=1:nsubjects
    for nses=1:nsessions
        batch.New.functionals{nsub}{nses}{1}=FUNCTIONAL_FILE{nsub,nses};
    end
end %note: each subject's data is defined by three sessions and one single(4d) file per session

batch.New.structurals=STRUCTURAL_FILE; % Point to anatomical volumes for each subject

%% CONN Setup % Default options (uses all ROIs in conn/rois/ directory); see conn_batch for additional options
batch.Setup.RT=TR; % TR (seconds)
nconditions=nsessions; % treats each session as a different condition (comment the following three lines and lines 84-86 below if you do not wish to analyze between-session differences)
batch.Setup.conditions.names=cellstr([repmat('Session',[nconditions,1]),num2str((1:nconditions)')]);
for ncond=1:nconditions
    for nsub=1:nsubjects
        for nses=1:nsessions
            batch.Setup.conditions.onsets{ncond}{nsub}{nses}=[];
            batch.Setup.conditions.durations{ncond}{nsub}{nses}=[];
        end
    end
end
for ncond=1:nconditions
    for nsub=1:nsubjects
        for nses=ncond
            batch.Setup.conditions.onsets{ncond}{nsub}{nses}=0;
            batch.Setup.conditions.durations{ncond}{nsub}{nses}=inf;
        end
    end
end
batch.Setup.outputfiles=[0,1,0];
batch.Setup.overwrite='Yes';
batch.Setup.done=1;

%% CONN Preprocessing 
% Default options (uses White Matter+CSF+realignment+conditions as confound regressors); see conn_batch for additional options
batch.Denoising.filter=[config.filter_bandpass_min, config.filter_bandpass_max]; % UI, frequency filter (bandpassvalues, in Hz)
batch.Denoising.done=1;
batch.Denoising.overwrite='Yes';

%% RUNS analyses
conn_batch(batch);

