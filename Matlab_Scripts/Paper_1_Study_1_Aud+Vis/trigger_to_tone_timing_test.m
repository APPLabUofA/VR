ccc;

%%%%%%% This code measures how many time points occur between each event
%%%%%%% (trigger) and when the tone is produced (>1000uV)


% EEG = pop_loadbv('M:\Data\Pi-P300\Trigger_Timing_Test\', 'PC_Trigger_Timing_Audio_20000.vhdr'); %load the file
%
% timing_pc = [];
% i = 1;
% for i_event = 3:length(EEG.event)
%     if EEG.event(i_event).type == 'S  1'
%         timing_pc(i) = EEG.event(i_event).latency - EEG.event(i_event+1).latency;
%         i = i + 1;
%     elseif EEG.event(i_event).type == 'S  2'
%         timing_pc(i) = EEG.event(i_event).latency - EEG.event(i_event+1).latency;
%         i = i + 1;
%     end
% end
%
% EEG = pop_loadbv('M:\Data\Pi-P300\Trigger_Timing_Test\', 'Pi_Trigger_Timing_Audio_20000.vhdr'); %load the file
%
% timing_pi = [];
% i = 1;
% for i_event = 3:length(EEG.event)
%     if EEG.event(i_event).type == 'S  1'
%         timing_pi(i) = EEG.event(i_event).latency - EEG.event(i_event+1).latency;
%         i = i + 1;
%     elseif EEG.event(i_event).type == 'S  2'
%         timing_pi(i) = EEG.event(i_event).latency - EEG.event(i_event+1).latency;
%         i = i + 1;
%     end
% end
%
% subplot(2,1,1);hist(timing_pc); title('PC Trigger Differences');
% subplot(2,1,2);hist(timing_pi); title('Pi Trigger Differences');
%
% timing_pc = [];
% i = 1;
% for i_event = 3:length(EEG.event)
%     if EEG.event(i_event).type == 'S  1'
%         timing_pc(i) = EEG.event(i_event).latency - EEG.event(i_event+1).latency;
%         i = i + 1;
%     elseif EEG.event(i_event).type == 'S  2'
%         timing_pc(i) = EEG.event(i_event).latency - EEG.event(i_event+1).latency;
%         i = i + 1;
%     end
% end

EEG = pop_loadbv('M:\Data\PandaAmp\', 'panda_p3_laptop_2.vhdr'); %load the file

for i = 2:length(EEG.event)
    if strcmp(EEG.event(1,i).type,'S  1') || strcmp(EEG.event(1,i).type,'S  2')
        latency = EEG.event(1,i).latency;
        times_lap(i-1) = find(EEG.data(latency:end)>1000,1);
        times_lap_aud_start(i-1) = find(EEG.data(latency:end)>1000,1) - find(EEG.data(latency:end)>50,1);
    end
end

times_lap(times_lap == 0) = [];
times_lap_aud_start(times_lap_aud_start == 0) = [];

EEG = pop_loadbv('M:\Data\PandaAmp\', 'panda_p3_panda_2.vhdr'); %load the file

for i = 2:length(EEG.event)
    if strcmp(EEG.event(1,i).type,'S  1') || strcmp(EEG.event(1,i).type,'S  2')
        latency = EEG.event(1,i).latency;
        times_pan(i-1) = find(EEG.data(latency:end)>1000,1);
        times_pan_aud_start(i-1) = (find(EEG.data(latency:end)>1000,1)) - (find(EEG.data(latency:end)>50,1));
    end
end

times_pan(times_pan == 0) = [];
times_pan_aud_start(times_pan_aud_start == 0) = [];

%every 20 timepoints is 1ms, divide by 20 for times in ms
avg_lap = mean(times_lap)/20; %916.5 time points
avg_pan = mean(times_pan)/20; %693.7982 time points
times_lap_aud_start = times_lap_aud_start/20;
times_pan_aud_start = times_pan_aud_start/20;
times_lap = times_lap/20;
times_pan = times_pan/20;
sd_lap = std(times_lap);
sd_pan = std(times_pan);

times_lap(times_lap > 100) = [];
times_lap(times_lap < 10) = [];

times_pan = times_pan(1:length(times_lap));


figure;
subplot(2,1,1);
hist(times_lap(2:end),150);title('Laptop');ylim([0 30]);xlim([0 50]);

subplot(2,1,2);
hist(times_pan(2:end),150);title('Panda');ylim([0 30]);xlim([0 50]);

%%%%% test of each time %%%%%

times_all{1} = times_lap(2:end);
times_all{2} = times_pan(2:end);

times_all_2(1,:) = times_lap(1:212);
times_all_2(2,:) = times_pan(1:212);


[h p ci stat] = ttest(times_all_2(1,:),times_all_2(2,:),.05,'both',2)

[h p ci stat] = ttest(times_lap,times_pan,.05,'both',2)

[h p ci stat] = ttest2(times_lap,times_pan,.05,'both',2)

diff_times = mean(times_lap(1:212)-times_pan(1:212));
sd_times = std(times_lap(1:212)-times_pan(1:212));

srate = 20000;
period = 1/20000;
times = (0:period:1400*period)*1000;

times = times - times(101);

EEG = pop_loadbv('M:\Data\Pi-P300\Trigger_Timing_Test\', 'Pi_Trigger_Timing_Audio_20000.vhdr'); %load the file
%start of tone is 5ms (100 time points) later on plot
%%%% determine start of tone by looking at the latency of an ideal trigger

% % % find([EEG.event(1:end).latency] > 2917908);%%% use first event
% % % figure
% % % subplot(2,2,1);plot(times,EEG.data(2918008:2919308));xlim([-200 1300]);ylim([-40000 40000]);title('Pi-Low Tone');
% % % %tone start
% % % % line([0 0],[-4000 4000]);
% % % %sd
% % % % line([0+((max(times_pi)-avg_pi)*20) 0-((avg_pi-min(times_pi))*20)],[4000 4000]);
% % % % line([0+((max(times_pi)-avg_pi)*20) 0-((avg_pi-min(times_pi))*20)],[-4000 -4000]);

find(times_pan > 34.6 & times_pan < 34.76); %remember to add 1 to the number this spits out, since 'boundary' is 1 in EEG.event

figure
subplot(2,2,1);plot(times,EEG.data(2942032:2943432));xlim([-5 65]);ylim([-40000 40000]);title('Pi-Low Tone');
%tone start
line([0 0],[-4000 4000]);line([34 34],[-4000 4000]);
%sd
line([avg_pan+((max(times_pan)-avg_pan)) avg_pan-((avg_pan-min(times_pan)))],[40000 40000]);
line([avg_pan+((max(times_pan)-avg_pan)) avg_pan+((max(times_pan)-avg_pan))],[-40000 40000]);
line([avg_pan+((max(times_pan)-avg_pan)) avg_pan-((avg_pan-min(times_pan)))],[-40000 -40000]);
line([avg_pan-((avg_pan-min(times_pan))) avg_pan-((avg_pan-min(times_pan)))],[-40000 40000]);


% % find([EEG.event(1:end).latency] > 4055930);%%% use first event
% %
% % subplot(2,2,2);plot(EEG.data(4056030:4057330));xlim([-200 1300]);ylim([-40000 40000]);title('Pi-High Tone');
% % %tone start
% % line([0 0],[-4000 4000])
% % %sd
% % line([0+((max(times_pi)-avg_pi)*20) 0-((avg_pi-min(times_pi))*20)],[4000 4000]);
% % line([0+((max(times_pi)-avg_pi)*20) 0-((avg_pi-min(times_pi))*20)],[-4000 -4000]);

find(times_pan > 34.6 & times_pan < 34.76);

subplot(2,2,2);plot(times,EEG.data(4085604:4087004));xlim([-5 65]);ylim([-40000 40000]);title('Pi-High Tone');
%tone start
line([0 0],[-4000 4000]);line([34 34],[-4000 4000]);
%sd
line([avg_pan+((max(times_pan)-avg_pan)) avg_pan-((avg_pan-min(times_pan)))],[40000 40000]);
line([avg_pan+((max(times_pan)-avg_pan)) avg_pan+((max(times_pan)-avg_pan))],[-40000 40000]);
line([avg_pan+((max(times_pan)-avg_pan)) avg_pan-((avg_pan-min(times_pan)))],[-40000 -40000]);
line([avg_pan-((avg_pan-min(times_pan))) avg_pan-((avg_pan-min(times_pan)))],[-40000 40000]);

EEG = pop_loadbv('M:\Data\Pi-P300\Trigger_Timing_Test\', 'PC_Trigger_Timing_Audio_20000.vhdr'); %load the file


% % find([EEG.event(1:end).latency] > 206299);%%% use first event
% %
% % subplot(2,2,3);plot(EEG.data(206343:207643));xlim([-200 1300]);title('PC-Low Tone');
% % %tone start
% % line([0 0],[-4000 4000]);
% % %sd
% % line([0+((max(times_pc)-avg_pc)*20) 0-((avg_pc-min(times_pc))*20)],[4000 4000]);
% % line([0+((max(times_pc)-avg_pc)*20) 0-((avg_pc-min(times_pc))*20)],[-4000 -4000]);

find(times_lap > 42.8 & times_lap < 42.9);

subplot(2,2,3);plot(times,EEG.data(688151:689551));xlim([-5 65]);ylim([-40000 40000]);title('PC-Low Tone');
%tone start
line([0 0],[-4000 4000]);line([45 45],[-4000 4000]);
%sd
line([avg_lap+((max(times_lap)-avg_lap)) avg_lap-((avg_lap-min(times_lap)))],[40000 40000]);
line([avg_lap+((max(times_lap)-avg_lap)) avg_lap+((max(times_lap)-avg_lap))],[-40000 40000]);
line([avg_lap+((max(times_lap)-avg_lap)) avg_lap-((avg_lap-min(times_lap)))],[-40000 -40000]);
line([avg_lap-((avg_lap-min(times_lap))) avg_lap-((avg_lap-min(times_lap)))],[-40000 40000]);


% % find([EEG.event(1:end).latency] > 3205866);%%% use first event
% %
% % subplot(2,2,4);plot(EEG.data(3205910:3207210));xlim([-200 1300]);title('PC-High Tone');
% % %tone start
% % line([0 0],[-4000 4000]);
% % %sd
% % line([0+((max(times_pc)-avg_pc)*20) 0-((avg_pc-min(times_pc))*20)],[4000 4000]);
% % line([0+((max(times_pc)-avg_pc)*20) 0-((avg_pc-min(times_pc))*20)],[-4000 -4000]);

find(times_lap > 42.8 & times_lap < 42.9);

subplot(2,2,4);plot(times,EEG.data(6205:7605));xlim([-5 65]);ylim([-40000 40000]);title('PC-High Tone');
%tone start
line([0 0],[-4000 4000]);line([45 45],[-4000 4000]);
%sd
line([avg_lap+((max(times_lap)-avg_lap)) avg_lap-((avg_lap-min(times_lap)))],[40000 40000]);
line([avg_lap+((max(times_lap)-avg_lap)) avg_lap+((max(times_lap)-avg_lap))],[-40000 40000]);
line([avg_lap+((max(times_lap)-avg_lap)) avg_lap-((avg_lap-min(times_lap)))],[-40000 -40000]);
line([avg_lap-((avg_lap-min(times_lap))) avg_lap-((avg_lap-min(times_lap)))],[-40000 40000]);


%%%%% Old versions, in case I forget something %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %start of tone is 5ms (100 time points) later on plot
% % %%%% determine start of tone by looking at the latency of an ideal trigger
% %
% % find([EEG.event(1:end).latency] > 2917908);%%% use first event
% % figure
% % subplot(2,2,1);plot(EEG.data(2917908:2919208));xlim([0 1300]);ylim([-40000 40000]);title('Pi-Low Tone');
% % %tone start
% % line([100 100],[-4000 4000]);
% % %sd
% % line([100+(sd_pi*20) 100-(sd_pi*20)],[2000 2000]);
% % line([100+(sd_pi*20) 100-(sd_pi*20)],[-2000 -2000]);
% %
% % find([EEG.event(1:end).latency] > 4055930);%%% use first event
% %
% % subplot(2,2,2);plot(EEG.data(4055930:4057230));xlim([0 1300]);ylim([-40000 40000]);title('Pi-High Tone');
% % %tone start
% % line([100 100],[-4000 4000])
% % %sd
% % line([100+(sd_pi*20) 100-(sd_pi*20)],[2000 2000]);
% % line([100+(sd_pi*20) 100-(sd_pi*20)],[-2000 -2000]);
% %
% % EEG = pop_loadbv('M:\Data\Pi-P300\Trigger_Timing_Test\', 'PC_Trigger_Timing_Audio_20000.vhdr'); %load the file
% %
% % subplot(2,2,3);plot(EEG.data(206299:207599));xlim([0 1300]);title('PC-Low Tone');
% % %tone start
% % line([100 100],[-4000 4000]);
% % %sd
% % line([100+(sd_pc*20) 100-(sd_pc*20)],[4000 4000]);
% % line([100+(sd_pc*20) 100-(sd_pc*20)],[-4000 -4000]);
% %
% % subplot(2,2,4);plot(EEG.data(3205866:3207166));xlim([0 1300]);title('PC-High Tone');
% % %tone start
% % line([100 100],[-4000 4000]);
% % %sd
% % line([100+(sd_pc*20) 100-(sd_pc*20)],[4000 4000]);
% % line([100+(sd_pc*20) 100-(sd_pc*20)],[-4000 -4000]);

% figure;
% subplot(2,1,1);
% hist(times_pc(2:end),20);title('PC');ylim([0 30]);xlim([25 50]);
%
% subplot(2,1,2);
% hist(times_pi(2:end),20);title('Pi');ylim([0 30]);xlim([25 50]);
%
% figure
% subplot(2,2,1);plot(EEG.data(22900:24000));title('Pi-Low Tone');
% line([72 72],[-2000 2000]);
%
% subplot(2,2,2);plot(EEG.data(49094:50194));title('Pi-High Tone');
% line([72 72],[-2000 2000])
%
% EEG = pop_loadbv('M:\Data\Pi-P300\Trigger_Timing_Test\', 'PC_Trigger_Timing_Audio_20000.vhdr'); %load the file
%
% subplot(2,2,3);plot(EEG.data(35495:36595));title('PC-Low Tone');
% line([72 72],[-4000 4000]);
%
% subplot(2,2,4);plot(EEG.data(57425:58525));title('PC-High Tone');
% line([72 72],[-4000 4000]);

%every 1 timepoints is 2 ms
%3 minutes = 90 000
% EEG = pop_loadbv('M:\Data\Pi-P300\EEG', '025_pi300_pi.vhdr');
%
% plot(EEG.data(7,[50000:140000]));ylim([-100 100]);xlim([0 90000]);title('3 min pi, electrode 7');
% plot(EEG.data(9,[50000:140000]));ylim([-100 100]);xlim([0 90000]);title('3 min pi, electrode 9');
%
% EEG = pop_loadbv('M:\Data\Pi-P300\EEG', '025_pi300_pc.vhdr');
%
% plot(EEG.data(7,[50000:140000]));ylim([-100 100]);xlim([0 90000]);title('3 min PC, electrode 7');
% plot(EEG.data(9,[50000:140000]));ylim([-100 100]);xlim([0 90000]);title('3 min PC, electrode 9');