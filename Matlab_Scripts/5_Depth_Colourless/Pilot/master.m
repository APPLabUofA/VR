% You run and change parameters for preprocessing and analysis here, you
% also specify the target condition & event type
Wrapper_VR_P3_Depth_Colourless_Pilot

% This script renames triggers appropriately, refer to markerinfo.txt
% and initializes structures in accordance with wrapper settings above
Preprocessing_VR_P3_Depth_Colourless(exp)

% Loads data for use with ERP (we are not using time-frequency analysis)
Analysis_VR_P3_Depth_Colourless(exp,anal)

%This script plots the ERPs & topographies
VR_P3_Depth_Colourless_ERP



