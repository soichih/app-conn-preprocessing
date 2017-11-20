% batch processing script derived from the CONN toolbox script (conn_batch_workshop_nyudataset.m; https://sites.google.com/view/conn/resources/source) for the NYU_CSC_TestRetest dataset (published in Shehzad et al., 2009, The Resting Brain: Unconstrained yet Reliable. Cerebral Cortex. doi:10.1093/cercor/bhn256)
% 
% Lorenzo Pasquini PhD, November 2017 
% lorenzo.pasquini@ucsf.edu, 
% Memory and Aging Center UCSF
%
% Steps:
% 1. Run conn_batch_workshop_nyudataset. The script will:
%       
%       a) Preprocessing of the anatomical and functional volumes
%         (normalization & segmentation of anatomical volumes; realignment,
%         coregistration, normalization, outlier detection, and smooting of the 
%         functional volumes)
%       b) Estimate first-level seed-to-voxel connectivity maps for each of 
%         the default seeds (located in the conn/rois folder), separately 
%         for each subject and for each of the three test-retest sessions.
%

function [] = preprocess()

clear all; clc;

%doesn't revent all dialog prompt but...
set(0,'DefaultFigureVisible','off');

% load my own config.json
config = loadjson('config.json')

%% FIND functional/structural files
cwd=pwd;
FUNCTIONAL_FILE=cellstr(conn_dir(config.bold)); %UI
STRUCTURAL_FILE=cellstr(conn_dir(config.t1)); %UI
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

%% CONN-SPECIFIC SECTION: RUNS PREPROCESSING/SETUP/DENOISING/ANALYSIS STEPS
%% Prepares batch structure
clear batch;
batch.filename=fullfile(cwd,'output.mat'); 

%% SETUP & PREPROCESSING step (using default values for most parameters, see help conn_batch to define non-default values)
% CONN Setup                                            % Default options (uses all ROIs in conn/rois/ directory); see conn_batch for additional options 
% CONN Setup.preprocessing                               (realignment/coregistration/segmentation/normalization/smoothing)
batch.Setup.isnew=1;
batch.Setup.nsubjects=1;
batch.Setup.RT=config.tr;                               % UI TR (seconds)
batch.Setup.functionals=repmat({{}},[1,1]);       % Point to functional volumes for each subject/session
for nsub=1:1,
    for nses=1:nsessions,
        batch.Setup.functionals{nsub}{nses}{1}=FUNCTIONAL_FILE{nsub,nses}; 
    end
end %note: each subject's data is defined by three sessions and one single (4d) file per session
batch.Setup.structurals=STRUCTURAL_FILE;                  % Point to anatomical volumes for each subject
nconditions=nsessions;                                  % treats each session as a different condition (comment the following three lines and lines 84-86 below if you do not wish to analyze between-session differences)
if nconditions==1
    batch.Setup.conditions.names={'rest'};
    for ncond=1,for nsub=1:1,for nses=1:nsessions,              batch.Setup.conditions.onsets{ncond}{nsub}{nses}=0; batch.Setup.conditions.durations{ncond}{nsub}{nses}=inf;end;end;end     % rest condition (all sessions)
else
    batch.Setup.conditions.names=[{'rest'}, arrayfun(@(n)sprintf('Session%d',n),1:nconditions,'uni',0)];
    for ncond=1,for nsub=1:1,for nses=1:nsessions,              batch.Setup.conditions.onsets{ncond}{nsub}{nses}=0; batch.Setup.conditions.durations{ncond}{nsub}{nses}=inf;end;end;end     % rest condition (all sessions)
    for ncond=1:nconditions,for nsub=1:1,for nses=1:nsessions,  batch.Setup.conditions.onsets{1+ncond}{nsub}{nses}=[];batch.Setup.conditions.durations{1+ncond}{nsub}{nses}=[]; end;end;end
    for ncond=1:nconditions,for nsub=1:1,for nses=ncond,        batch.Setup.conditions.onsets{1+ncond}{nsub}{nses}=0; batch.Setup.conditions.durations{1+ncond}{nsub}{nses}=inf;end;end;end % session-specific conditions
end
batch.Setup.preprocessing.steps=config.steps;
batch.Setup.preprocessing.sliceorder=[2:2:config.sliceorder_a,1:2:config.sliceorder_b]; % UI, slice order acquisition
batch.Setup.preprocessing.fwhm=config.fwhm; % UI, smoothing kernel
batch.Setup.preprocessing.art_thresholds=[5,0.9]; % outlier detector, set to default
batch.Setup.outputfiles=[0,1,0]; % writing of denoised data as nifti 
batch.Setup.done=1;
batch.Setup.overwrite='Yes';                            

% uncomment the following 3 lines if you prefer to run one step at a time:
% conn_batch(batch); % runs Preprocessing and Setup steps only
% clear batch;
% batch.filename=fullfile(cwd,'conn_NYU.mat');            % Existing conn_*.mat experiment name

%% DENOISING step
% CONN Denoising                                    % Default options (uses White Matter+CSF+realignment+scrubbing+conditions as confound regressors); see conn_batch for additional options 
for thispart = 1
    if config.do_global_signal_regression
        batch.Denoising.confounds.names={'Grey Matter','White Matter','CSF','realignment','scrubbing','Effect of rest'};
    else
        batch.Denoising.confounds.names={'White Matter','CSF','realignment','scrubbing','Effect of rest'};
    end
end
batch.Denoising.filter=[config.filter_bandpass_min, config.filter_bandpass_max];                 % UI, frequency filter (band-pass values, in Hz)
batch.Denoising.done=1;
batch.Denoising.overwrite='Yes';

% uncomment the following 3 lines if you prefer to run one step at a time:
% conn_batch(batch); % runs Denoising step only
% clear batch;
% batch.filename=fullfile(cwd,'conn_NYU.mat');            % Existing conn_*.mat experiment name

%% FIRST-LEVEL ANALYSIS step
% CONN Analysis                                     % Default options (uses all ROIs in conn/rois/ as connectivity sources); see conn_batch for additional options 
batch.Analysis.done=1;
batch.Analysis.overwrite='Yes';

%% Run all analyses
conn_batch(batch);

quit
