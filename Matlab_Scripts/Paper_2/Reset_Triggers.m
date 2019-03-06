     %% Set up parallel port
%initialize the inpoutx64 low-level I/O driver
config_io;
%optional step: verify that the inpoutx64 driver was successfully installed
global cogent; 
if( cogent.io.status ~= 0 )
   error('inp/outp installation failed');
end
%write a value to the default LPT1 printer output port (at 0x378)
address_eeg = hex2dec('B010');

outp(address_eeg,0);  %set pins to zero  