ccc;

%%%check which triggers we can use%%
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_loadbv('M:\Data\VR_P3\Unity_Test', 'unity_colour_test.vhdr'); %load the file

%%%NOTE, did not use trigger of 255, which results in 221 appearing in amp
%%%also started at trigger 69 and ended with 254
trig_list = [];
count = 1;
current_trig = 69;
for i_trig = 4:length(EEG.event)
    if i_trig == 4
        trig_list(1,count) = current_trig;
        trig_list(2,count) = str2num(EEG.event(i_trig).type(2:end));
        count = count + 1;
        current_trig = current_trig + 1;
    elseif  strcmp(EEG.event(i_trig).type,EEG.event(i_trig-1).type) == 1
        current_trig = current_trig + 1;
    else
        trig_list(1,count) = current_trig;
        trig_list(2,count) = str2num(EEG.event(i_trig).type(2:end));
        count = count + 1;
        current_trig = current_trig + 1;
    end
end

trig_list(1,end+1) = 255;
trig_list(2,end+1) = 221;



%%%now let's find latency differences between when the trigger was sent and
%%%when the pixel colour was changed%%%
ccc;

latency = [];

EEG = pop_loadbv('M:\Data\VR_P3\Unity_Test', 'vr_visual_photo_test.vhdr'); %load the file

for i_trig = 3:length(EEG.event)
    
    latency(i_trig-2) = find(EEG.data(17,EEG.event(i_trig).latency:end) > 100,1);
    
end

mean(latency)/EEG.srate
std(latency)/EEG.srate
min(latency)/EEG.srate
max(latency)/EEG.srate

figure;plot(1:length(EEG.times),EEG.data(17,:));hold on;
for i_line = 1:length(latency)
    line([EEG.event(i_line+2).latency,EEG.event(i_line+2).latency],[-200,200],'color','k');
    line([EEG.event(i_line+2).latency+latency(i_line),EEG.event(i_line+2).latency+latency(i_line)],[-200,200],'color','r');
end
hold off;

figure;hist(latency/EEG.srate);

%%%%%Latencies for HMD colour refresh%%%%

ccc;

latency = [];

EEG = pop_loadbv('M:\Data\VR_P3\Unity_Test', 'vr_hmd_photo_test.vhdr'); %load the file


for i_trig = 2:length(EEG.event)
    
    latency(i_trig-1) = find(EEG.data(17,EEG.event(i_trig).latency:end) > 100,1);
    
end

mean(latency)/EEG.srate
std(latency)/EEG.srate
min(latency)/EEG.srate
max(latency)/EEG.srate

figure;plot(1:length(EEG.times),EEG.data(17,:));hold on;
for i_line = 1:length(latency)
    line([EEG.event(i_line+1).latency,EEG.event(i_line+1).latency],[-200,200],'color','k');
    line([EEG.event(i_line+1).latency+latency(i_line),EEG.event(i_line+1).latency+latency(i_line)],[-200,200],'color','r');
end
hold off;

figure;hist(latency/EEG.srate);

%%%%%Latencies for auditory task, Trigger and tone onset%%%%%

ccc;

latency = [];

EEG = pop_loadbv('M:\Data\VR_P3\Unity_Test', 'vr_aud_test.vhdr'); %load the file

for i_trig = 2:length(EEG.event)-1
    
    latency(i_trig-1) = find(EEG.data(1,EEG.event(i_trig).latency:end) > 20000,1);
    
end

mean(latency)/EEG.srate
std(latency)/EEG.srate
min(latency)/EEG.srate
max(latency)/EEG.srate

figure;plot(1:length(EEG.times),EEG.data(1,:));hold on;
for i_line = 1:length(latency)
    line([EEG.event(i_line+1).latency,EEG.event(i_line+1).latency],[-20000,20000],'color','k');
    line([EEG.event(i_line+1).latency+latency(i_line),EEG.event(i_line+1).latency+latency(i_line)],[-20000,20000],'color','r');
end
hold off;

figure;hist(latency/EEG.srate,100);

%%%%%Latencies for auditory task, Trigger and photocell%%%%%

ccc;

latency = [];

EEG = pop_loadbv('M:\Data\VR_P3\Unity_Test', 'vr_aud_photo_test.vhdr'); %load the file

for i_trig = 2:length(EEG.event)-1
    
    latency(i_trig-1) = find(EEG.data(17,EEG.event(i_trig).latency:end) > 100,1);
    
end

mean(latency)/EEG.srate
std(latency)/EEG.srate
min(latency)/EEG.srate
max(latency)/EEG.srate

figure;plot(1:length(EEG.times),EEG.data(17,:));hold on;
for i_line = 1:length(latency)
    line([EEG.event(i_line+1).latency,EEG.event(i_line+1).latency],[-200,200],'color','k');
    line([EEG.event(i_line+1).latency+latency(i_line),EEG.event(i_line+1).latency+latency(i_line)],[-200,200],'color','r');
end
hold off;

figure;hist(latency/EEG.srate,100);


%%%%%Latencies between triggers, need to find how long each trial is%%%

ccc;

latency = [];

EEG = pop_loadbv('M:\Data\VR_P3\', '001_vr_vis_p3_hs.vhdr'); %load the file
EEG = pop_loadbv('M:\Data\VR_P3\', '001_vr_vis_p3_nohs.vhdr'); %load the file
EEG = pop_loadbv('M:\Data\VR_P3\', '001_vr_aud_p3_hs.vhdr'); %load the file
EEG = pop_loadbv('M:\Data\VR_P3\', '001_vr_aud_p3_nohs.vhdr'); %load the file
EEG = pop_loadbv('M:\Data\VR_P3\Unity_Test\', 'trial_count_vis.vhdr'); %load the file
EEG = pop_loadbv('M:\Data\VR_P3\Unity_Test\', 'trial_count_aud.vhdr'); %load the file

EEG = pop_loadbv('M:\Data\VR_P3\', '001_auditory_hs.vhdr'); %load the file
EEG = pop_loadbv('M:\Data\VR_P3\', '011_auditory_nhs.vhdr'); %load the file
EEG = pop_loadbv('M:\Data\VR_P3\', '001_visual_hs.vhdr'); %load the file
EEG = pop_loadbv('M:\Data\VR_P3\', '001_visual_nhs.vhdr'); %load the file

%%%remove the boundary triggers and the 2 extra triggers at end of block%%%
if length(EEG.event) == 504
    EEG.event([1,252,253,504]) = [];
elseif length(EEG.event) == 503
    EEG.event([1,252,253]) = [];
end

deleted_triggers = [];
for i_trig = 1:length(EEG.event)
    if strcmp(EEG.event(i_trig).type, 'S255') == 0 & strcmp(EEG.event(i_trig).type, 'S 85') == 0
        deleted_triggers = [deleted_triggers,i_trig];
    end
end

EEG.event(deleted_triggers) = [];

deleted_triggers = [];
for i_trig = 2:length(EEG.event)
    if EEG.event(i_trig).latency - EEG.event(i_trig-1).latency > 2000
        if i_trig == length(EEG.event)
            deleted_triggers = [deleted_triggers, i_trig];
        elseif EEG.event(i_trig+1).latency - EEG.event(i_trig).latency > 2000
            deleted_triggers = [deleted_triggers, i_trig];
        end
        
    end
end

EEG.event(deleted_triggers) = [];

for i_trig = 1:(length(EEG.event)/2)-1
    latency(i_trig) = (EEG.event(i_trig+1).latency-EEG.event(i_trig).latency)/EEG.srate;
end

mean(latency)
max(latency)
min(latency)