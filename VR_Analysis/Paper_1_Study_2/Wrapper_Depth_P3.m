%% PREPROCESSING AND ANALYSIS WRAPPER
%clear and close everything
ccc

%% Settings for loading the raw data
exp.analysis = 1;
exp.preprocess = 3; %%%set to 1 for far, 2 for near, 3 for LOADING PROPROCESSED DATA

%%%004 onward uses new task with fixation in middle
%%%do not use 011, could not tell difference between near and far
%%%013 responded to standards instead of targets, despite instructions
exp.participants = {'004';'005';'006';'007';'008';'009';'010';'012';'014';'015';'016';'017';'018';'019';'020';'021';'022';'023';'024'};
% %     exp.participants = {'024'};

if exp.preprocess == 1
    %Datafiles must be in the format exp_participant, e.g. EEGexp_001.vhdr
    exp.name = 'depth_p3_far';
    
    exp.pathname = 'M:\Data\VR_P3\Depth';
    
    %%%%%Triggers to tone onset%%%%%
    exp.events = {[1],[2]};    %must be matrix (sets x events)
    
    exp.setname = {'Far'}; %name the rows
    exp.event_names = {'Standards','Targets'}; %name the columns
    exp.selection_cards = {'1','2'};
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif exp.preprocess == 2
    %Datafiles must be in the format exp_participant, e.g. EEGexp_001.vhdr
    exp.name = 'depth_p3_near';
    
    exp.pathname = 'M:\Data\VR_P3\Depth';
    
    %%%%%Triggers to tone onset%%%%%
    exp.events = {[2],[1]};    %must be matrix (sets x events)
    
    exp.setname = {'Near'}; %name the rows
    exp.event_names = {'Standards','Targets'}; %name the columns
    exp.selection_cards = {'2','1'};
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif exp.preprocess == 3
    %Datafiles must be in the format exp_participant, e.g. EEGexp_001.vhdr
    exp.name = 'depth_p3_far';
    
    exp.pathname = 'M:\Data\VR_P3\Depth';
    
    %%%%%Triggers to tone onset%%%%%
    exp.events = {[1],[2];...
        [2],[1]};    %must be matrix (sets x events)
    
    exp.setname = {'Far';'Near'}; %name the rows
    exp.event_names = {'Standards','Targets'}; %name the columns
    exp.selection_cards = {'2','1'};
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif exp.preprocess == 4
    %Datafiles must be in the format exp_participant, e.g. EEGexp_001.vhdr
    exp.name = 'depth_p3_dfdrrg';
    
    exp.participants = {'004';'005'};
    
    exp.pathname = 'M:\Data\VR_P3\Depth\Depth_Eye_P3';
    
    %%%%%Triggers to tone onset%%%%%
    exp.events = {[111],[222],[138],[139]};    %must be matrix (sets x events)
    
    exp.setname = {'Eye_Depth'}; %name the rows
    exp.event_names = {'Near','Far','Detect_Near','Detect_Far'}; %name the columns
    exp.selection_cards = {'111','222','138','139'};
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif exp.preprocess == 5
    %Datafiles must be in the format exp_participant, e.g. EEGexp_001.vhdr
    exp.name = 'depth_p3_near_far_erps';
    
    exp.pathname = 'M:\Data\VR_P3\Depth';
    
    %%%%%Triggers to tone onset%%%%%
    exp.events = {[1],[2]};    %must be matrix (sets x events)
    
    exp.setname = {'Near&Far'}; %name the rows
    exp.event_names = {'Near','Far'}; %name the columns
    exp.selection_cards = {'1','2'};
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

% % Each item in the exp.events matrix will become a seperate dataset, including only those epochs referenced by the events in that item.
% %e.g. 3 rows x 4 columns == 12 datasets/participant

% % The settings will be saved as a new folder. It lets you save multiple datasets with different preprocessing parameters.
exp.settings = 'Depth_P3_ERP';

%% Preprocessing Settings
%segments settings
exp.segments = 'on'; %Do you want to make new epoched datasets? Set to "off" if you are only changing the tf settings.
%Where are your electrodes? (.ced file)
exp.electrode_locs = 'M:\Analysis\VR_P3\BrainAMP_EOG_VR.ced';

%% Filter the data?
exp.filter = 'on';
exp.lowpass = 50;
exp.highpass = 0;

%% Re-referencing the data
exp.refelec = 16; %which electrode do you want to re-reference to?
exp.brainelecs = [1:15]; %list of every electrode collecting brain data (exclude mastoid reference, EOGs, HR, EMG, etc.

%% Epoching the data
%Choose what to epoch to. The default [] uses every event listed above.
%Alternatively, you can epoch to something else in the format {'TRIG'}. Use triggers which are at a consistent time point in every trial.
exp.epochs = [];
exp.epochslims = [-1 1]; %Tone Onset in seconds; epoched trigger is 0 e.g. [-1 2]
% % exp.epochslims = [-1 2.5]; %Picture Onset in seconds; epoched trigger is 0 e.g. [-1 2]
exp.epochbaseline = [-200 0]; %remove the for each epoched set, in ms. e.g. [-200 0]

%% Artifact rejection.
% Choose the threshold to reject trials. More lenient threshold followed by an (optional) stricter threshold
exp.preocularthresh = [-1000 1000]; %First happens before the ocular correction.
exp.postocularthresh = [-500 500]; %Second happens after. Leave blank [] to skip

%% Blink Correction
%the Blink Correction wants dissimilar events (different erps) seperated by commas and similar events (similar erps) seperated with spaces. See 'help gratton_emcp'
% % exp.selection_cards = {'1','2'};
%%%%

%% Time-Frequency settings
%Do you want to run time-frequency analyses? (on/off)
exp.tf = 'off';
%Do you want to save the single-trial data? (on/off) (Memory intensive!!!)
exp.singletrials = 'off';
%Do you want to use all the electrodes or just a few? Leave blank [] for all (will use same as exp.brainelecs)
exp.tfelecs = [];
%Saving the single trial data is memory intensive. Just use the electrodes you need.
exp.singletrialselecs = [3];

%% Wavelet settings
%how long is your window going to be? (Longer window == BETTER frequency resolution & WORSE time resolution)
exp.winsize = 512; %in ms; use numbers that are 2^x, e.g. 2^10 == 1024ms
%baseline will be subtracted from the power variable. It is relative to your window size.
exp.erspbaseline = [-200 0]; %e.g., [-200 0] will use [-200-exp.winsize/2 0-exp.winsize/2]; Can use just NaN for no baseline
%Instead of choosing a windowsize, you can choose a number of cycles per frequency. See "help popnewtimef"
exp.cycles = [0]; %leave it at 0 to use a consistent time window
exp.freqrange = [1 40]; % what frequencies to consider? default is [1 50]
%%%%

%% Save your pipeline settings
save([exp.settings '_Settings'],'exp') %save these settings as a .mat file. This will help you remember what settings were used in each dataset

% % Run Preprocessing
if exp.analysis == 0
    Preprocessing_Depth_P3(exp) %comment out if you're only doing analysis
end

%% Run Analysis
%Don't want to change all the above settings? Load the settings from the saved .mat file.

%choose the data types to load into memory (on/off)
anal.segments = 'on'; %load the EEG segments?
anal.tf = 'off'; %load the time-frequency data?

anal.singletrials = 'off'; %load the single trial data?
anal.entrainer_freqs = [20; 15; 12; 8.5; 4]; %Single trial data is loaded at the event time, and at the chosen frequency.

anal.tfelecs = []; %load all the electodes, or just a few? Leave blank [] for all.
anal.singletrialselecs = [2 3 4 6];

if exp.analysis == 1
    Analysis_Depth_P3(exp,anal) % The Analysis primarily loads the processed data. It will attempt to make some figures, but most analysis will need to be done in seperate scripts.
end
