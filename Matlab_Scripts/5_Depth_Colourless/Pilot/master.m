% You run and change parameters for preprocessing and analysis with this one script, from this script you can also change the target condition & event type
% Running this script will create both **exp** & **anal** structures which are used in preprocessing & analysis
1. Wrapper_VR_P3_Depth_Colourless_Pilot

% This script renames triggers appropriately, *refer to markerinfo.txt*
% and initializes structures in accordance with wrapper settings above
2. Preprocessing_VR_P3_Depth_Colourless(**exp**)

% Loads data for use with ERP (note: we are not using time-frequency analysis)
3. Analysis_VR_P3_Depth_Colourless(**exp,anal**)

%This script plots the ERP, topographies, and bar graphs
4. VR_P3_Depth_Colourless_ERP



