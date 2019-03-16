% This script either runs preprocesses or analysis, for the appropriate
% condition & event type depending on its settings
% change preprocessing parameters here
Wrapper_VR_P3_Depth_Colourless_Pilot

% This script renames triggers appropriately, refer to markerinfo.txt
% and initializes structures in accordance with wrapper settings above
Preprocessing_VR_P3_Depth_Colourless

% Loads data for use with ERP (we are not using time-frequency analysis)
Analysis_VR_P3_Depth_Colourless

%This script plots the ERPs & topographies
VR_P3_Depth_Colourless_ERP



