%% Plot ERPs of your epochs
% An ERP is a plot of the raw, usually filtered, data, at one or multiple electrodes. It doesn't use time-frequency data.
% We make ERPs if we have segmented datasets that we want to compare across conditions.
% % % 
% % % if exist('exp')~=1;
% % %     load('Last_Ent_Targets')
% % %     anal.segments = 'off'; %load the EEG segments?
% % %     anal.tf = 'off'; %load the time-frequency data?
% % %     anal.singletrials = 'on'; %load the single trial data?
% % %     anal.entrainer_freqs = [10;20]; %Single trial data is loaded at the event time, and at the chosen frequency.
% % %     anal.tfelecs = []; %load all the electodes, or just a few? Leave blank [] for all.
% % %     anal.singletrialselecs = [2 3 4 6];
% % %     exp.events = {[48];[48];[48];[48];[48]};
% % %     Analysis(exp,anal) % The Analysis primarily loads the processed data. It will attempt to make some figures, but most analysis will need to be done in seperate scripts.
% % % end

% In this case, you are using all your electrodes, not a subset.
electrodes = {EEG.chanlocs(:).labels};
% Type "electrodes" into the command line. This will show you which number to use for i_chan

% This code will take a grand average of the subjects, making one figure per set.
% This is the normal way to present ERP results.
i_chan = [9];%%%7(Pz) 9(Fz)
for i_set = 1:nsets
    data_out = [];
    exp.setname{i_set}
    % The code below uses a nested loop to determine which segmented dataset corresponds to the right argument in data_out
    % e.g. if you have 5 sets, 20 participants, and 4 events, for i_set ==
    % 2 and i_part == 1 and i_event == 1, the code uses the data from set (2-1)*4*20 + (1-1)*20 + 1 == set 81
    for eegset = 1:nevents
        exp.event_names{1,eegset}
        for i_part = 1:nparts
            
            data_out(:,:,eegset,i_part,i_set) = nanmean(ALLEEG((i_set-1)*nevents*nparts + (eegset-1)*(nparts) + i_part).data,3);
            
            ALLEEG((i_set-1)*nevents*nparts + (eegset-1)*(nparts) + i_part).filename
        end
        
        % this is the averaged ERP data. We take the mean across the selected channels (dim1) and the participants (dim4).
        erpdata(i_set,eegset).cond = squeeze(mean(mean(data_out(i_chan,:,eegset,:,i_set),1),4));
        erpdata_parts(i_set,eegset).cond = squeeze(mean(data_out(i_chan,:,eegset,:,i_set),1));
        all_chan_erpdata(i_set,eegset).cond = squeeze(mean(data_out(:,:,eegset,:,i_set),4));
        %     erpdata = squeeze(mean(mean(data_out(i_chan,:,:,:,i_set),1),4));
        
    end
end

% % Low Tones
% % erpdata(1,1) = No_Headset
% % erpdata(2,1) = Headset
% %
% % High Tones
% % erpdata(1,2) = No_Headset
% % erpdata(2,2) = Headset

%%%%%THE FOLLOWING ARE FOR TONES FOR EACH PARTICIPANT, SEE BELOW FOR MEAN TONES%%%%%
col = ['k','b';'k','r'];
%%%%% Pick your condition 1 = no headset; 2 = headset%%%%%
cond1 = 2;
cond2 = 2;
%%%%%Pick your tone 1 = low; 2 = high%%%%%
tone1 = 1;
tone2 = 2;

%%%%%ERPs for high/low tones%%%%%
figure;hold on;
for i_part = 1:nparts
    subplot(ceil(sqrt(nparts)),ceil(sqrt(nparts)),i_part);boundedline(EEG.times,erpdata_parts(cond1,tone1).cond(:,i_part),std(erpdata_parts(cond1,tone1).cond(:,i_part))./sqrt(length(exp.participants)),col(cond1,tone1),...
        EEG.times,erpdata_parts(cond2,tone2).cond(:,i_part),std(erpdata_parts(cond2,tone2).cond(:,i_part))./sqrt(length(exp.participants)),col(cond2,tone2));
    
% %         subplot(ceil(sqrt(nparts)),ceil(sqrt(nparts)),i_part);boundedline(EEG.times,erpdata_parts(cond1,tone2).cond(:,i_part)-erpdata_parts(cond1,tone1).cond(:,i_part),...
% %             std(erpdata_parts(cond1,tone2).cond(:,i_part)-erpdata_parts(cond1,tone1).cond(:,i_part))./sqrt(length(exp.participants)),col(cond1,tone2));
% %     %%%%% epoched to last entrainer %%%%%
    xlim([-200 1000])
    ylim([-25  25])
    set(gca,'Ydir','reverse');
    %%%%% epoched to last entrainegfhr %%%%%
    line([0 0],[-10 10],'color','k');
% %     line([300 300],[-10 10],'color','k'); %%%%use this to help find ERP regions
% %     line([550 550],[-10 10],'color','k'); %%%%use this to help find ERP regions
    line([-200 1000],[0 0],'color','k');
    title(['Participant ' num2str(i_part)]);
end
 hold off;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%THE FOLLOWING ARE FOR TONES%%%%%
col = ['b','b';'r','r']; %%%uncomment to compare one tone type across conditions
% % col = ['k','b';'k','r']; %%%uncomment for high and low tones
%%%%% Pick your condition 1 = no headset; 2 = headset%%%%%
cond1 = 1;
cond2 = 2;
%%%%%Pick your tone 1 = low; 2 = high%%%%%
tone1 = 2;
tone2 = 2;
%%%%%ERPs for high or low tones%%%%%
figure;boundedline(EEG.times(801:2000),erpdata(cond1,tone1).cond(801:2000),std(erpdata_parts(cond1,tone1).cond(801:2000,:),[],2)./sqrt(length(exp.participants)),col(cond1,tone1),...
    EEG.times(801:2000),erpdata(cond2,tone2).cond(801:2000),std(erpdata_parts(cond2,tone2).cond(801:2000,:),[],2)./sqrt(length(exp.participants)),col(cond2,tone2));

%%%%%Difference Waves for high and low tones%%%%%
% % figure;boundedline(EEG.times(801:2000),(erpdata(cond1,tone2).cond(801:2000)-erpdata(cond1,tone1).cond(801:2000)),std(erpdata_parts(cond1,tone2).cond(801:2000,:)-erpdata_parts(cond1,tone1).cond(801:2000,:),[],2)./sqrt(length(exp.participants)),col(cond1,tone1),...
% %     EEG.times(801:2000),(erpdata(cond2,tone2).cond(801:2000)-erpdata(cond2,tone1).cond(801:2000)),std(erpdata_parts(cond2,tone2).cond(801:2000,:)-erpdata_parts(cond2,tone1).cond(801:2000,:),[],2)./sqrt(length(exp.participants)),col(cond2,tone2));

%%%%% epoched to last entrainer %%%%%
xlim([-200 1000])
ylim([-15 15])
set(gca,'Ydir','reverse');
%%%%% epoched to last entrainer %%%%%
line([0 0],[-10 10],'color','k');
line([-200 1000],[0 0],'color','k');
% line([175 175],[-10 10],'color','k'); %%%%use this to help find ERP regions
% line([275 275],[-10 10],'color','k'); %%%%use this to help find ERP regions
hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%bar plots of means%%%%%
cond1 = 1;
cond2 = 2;
%%%%%Pick your tone 1 = low; 2 = high%%%%%
tone1 = 1;
tone2 = 2;

time1 = 300;
time2 = 550;

%%%%%Get topoplots for differnce between targets and standards%%%%%
time_window = find(EEG.times>time1,1)-1:find(EEG.times>time2,1)-2;

figure;hold on;
bar([mean(erpdata(cond1,tone2).cond(time_window)-erpdata(cond1,tone1).cond(time_window)),mean(erpdata(cond2,tone2).cond(time_window)-erpdata(cond2,tone1).cond(time_window))]);
errorbar([mean(erpdata(cond1,tone2).cond(time_window)-erpdata(cond1,tone1).cond(time_window)),mean(erpdata(cond2,tone2).cond(time_window)-erpdata(cond2,tone1).cond(time_window))],...
    [mean(std(erpdata_parts(cond1,tone2).cond(time_window,:)-erpdata_parts(cond1,tone1).cond(time_window,:),[],2)./sqrt(length(exp.participants))),mean(std(erpdata_parts(cond2,tone2).cond(time_window,:)-erpdata_parts(cond2,tone1).cond(time_window,:),[],2)./sqrt(length(exp.participants)))],'.');
hold off;
ylim([5,8]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%Power Topoplots%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Pick your condition 1 = no headset; 2 = headset%%%%%
cond1 = 1;
cond2 = 2;
%%%%%Pick your tone 1 = low 2 = high%%%%%
tone1 = 1;
tone2 = 2;
%%%%%Pick your time window 300-550 for P3, 175-275 for MMN DO NOT USE%%%%%
%%%%%for revised auditory VR with RT, 400-550 for P3, 300-425 for MMN (Eden
%%%%%revised auditory VR for 
%%%%%for revised visual VR with RT, 300-550 for P3, 250-325 for MMN
time1 = 400;
time2 = 550;

% % time1 = 300;
% % time2 = 425;

time1 = 300;
time2 = 550;

% % time1 = 250;
% % time2 = 325;



% % time1 = 425;
% % time2 = 600;

% % time1 = 325;
% % time2 = 525;



%%%%%Get topoplots for differnce between targets and standards%%%%%
time_window = find(EEG.times>time1,1)-1:find(EEG.times>time2,1)-2;

erp_diff_out_nhs = (all_chan_erpdata(cond1,tone2).cond-all_chan_erpdata(cond1,tone1).cond);
erp_diff_out_hs = (all_chan_erpdata(cond2,tone2).cond-all_chan_erpdata(cond2,tone1).cond);

figure('Color',[1 1 1]);
set(gca,'Color',[1 1 1]);
temp1 = mean(erp_diff_out_nhs(:,time_window),2);
temp2 = mean(erp_diff_out_hs(:,time_window),2);
temp1(17:18) = NaN;
temp2(17:18) = NaN;

subplot(1,2,1);
topoplot((temp1),exp.electrode_locs, 'whitebk','on','plotrad',.6,'maplimits',[-5 5])
title('No Headset');
t = colorbar('peer',gca);
set(get(t,'ylabel'),'String', 'Voltage Difference (uV)');

subplot(1,2,2);
topoplot((temp2),exp.electrode_locs, 'whitebk','on','plotrad',.6,'maplimits',[-5 5])
title('Headset');
t = colorbar('peer',gca);
set(get(t,'ylabel'),'String', 'Voltage Difference (uV)');

%%%%%Difference Topoplots%%%%%
figure('Color',[1 1 1]);
set(gca,'Color',[1 1 1]);

topoplot((temp1-temp2),exp.electrode_locs, 'whitebk','on','plotrad',.6,'maplimits',[-5 5])
title('No Headset - Headset');
t = colorbar('peer',gca);
set(get(t,'ylabel'),'String', 'Voltage Difference (uV)');
hold off;

        %% Custom Stats %%
        

nhs_diff = erpdata_parts(1,2).cond-erpdata_parts(1,1).cond;
hs_diff = erpdata_parts(2,2).cond-erpdata_parts(2,1).cond;

%%%%%Pick your time window 300-550 for P300, 175-275 for MMN%%%%%
%%%P3 auditory
time1 = 400;
time2 = 550;

%%%MMN auditory
time1 = 300;
time2 = 425;

%%%P3 visual
time1 = 300;
time2 = 550;

%%%MMN visual
time1 = 250;
time2 = 325;



% % time1 = 300;
% % time2 = 550;

% % time1 = 275;
% % time2 = 300;

% % time1 = 300;
% % time2 = 425;

% % time1 = 425;
% % time2 = 600;

% % time1 = 325;
% % time2 = 525;


% % time1 = 250;
% % time2 = 325;

% % time1 = 400
% % time2 = 550

% % time1 = 175;
% % time2 = 250;

time_window = find(EEG.times>time1,1)-1:find(EEG.times>time2,1)-2;

%%%compare conditions
[h p ci stat] = ttest(mean(nhs_diff(time_window,:),1),mean(hs_diff(time_window,:),1),.05,'both',2); %% For headset - no headset %%
disp(['h-val: ', num2str(h),' p-val: ', num2str(p),' ci-val: ', num2str(ci),' stat.tstat-val: ', num2str(stat.tstat),' stat.df-val: ' num2str(stat.df),' stat.sd-val: ' num2str(stat.sd)])

%%%compare from zero with single tail(right) for the Pz electrode only (P300)
[h p ci stat] = ttest(mean(nhs_diff(time_window,:),1),0,.05,'right',2); %% For no headset condition %%
disp(['h-val: ', num2str(h),' p-val: ', num2str(p),' ci-val: ', num2str(ci),' stat.tstat-val: ', num2str(stat.tstat),' stat.df-val: ' num2str(stat.df),' stat.sd-val: ' num2str(stat.sd)])

[h p ci stat] = ttest(mean(hs_diff(time_window,:),1),0,.05,'right',2); %% for headset condition %%
disp(['h-val: ', num2str(h),' p-val: ', num2str(p),' ci-val: ', num2str(ci),' stat.tstat-val: ', num2str(stat.tstat),' stat.df-val: ' num2str(stat.df),' stat.sd-val: ' num2str(stat.sd)])

%%%compare from zero with single tail(left) for the Fz electrode only (MMN) 
[h p ci stat] = ttest(mean(nhs_diff(time_window,:),1),0,.05,'left',2);  %% For no headset condition %%
disp(['h-val: ', num2str(h),' p-val: ', num2str(p),' ci-val: ', num2str(ci),' stat.tstat-val: ', num2str(stat.tstat),' stat.df-val: ' num2str(stat.df),' stat.sd-val: ' num2str(stat.sd)])

[h p ci stat] = ttest(mean(hs_diff(time_window,:),1),0,.05,'left',2); %% for headset condition %%
disp(['h-val: ', num2str(h),' p-val: ', num2str(p),' ci-val: ', num2str(ci),' stat.tstat-val: ', num2str(stat.tstat),' stat.df-val: ' num2str(stat.df),' stat.sd-val: ' num2str(stat.sd)])

% % % Mean and SD for both P300 and MMN


mean1=mean(mean(nhs_diff(time_window,:),1)); %% For no headset mean %%
disp(['mean-val: ', num2str(mean1)])

mean2=mean(mean(hs_diff(time_window,:),1)); %% For headset mean %%
disp(['mean-val: ', num2str(mean2)])

mean3=std(mean(nhs_diff(time_window,:),1)); %% For no headset SD %%
disp(['SD-val: ', num2str(mean3)])

mean4=std(mean(hs_diff(time_window,:),1)); %% For headset SD %%
disp(['SD-val: ', num2str(mean4)])

mean5= mean3/(sqrt(nparts)); %% For no headset SE %%
disp(['SE-val: ', num2str(mean5)])

mean6= mean4/(sqrt(nparts)); %% For headset SE %%
disp(['SE-val: ', num2str(mean6)])


mean_barweb = barweb([mean1,mean2],[mean5,mean6], [], [], [], [], [], jet, [], [], 2, []);

ylim([-2 0.1]); 


%%
%%%grab trial numbers LAPTOP VS PANDA%%% Sitting and Laptop/Biking and
%%%Panda correspond to the same condition number

nhs_low = zeros(1,length(exp.participants));
nhs_high = zeros(1,length(exp.participants));
hs_low = zeros(1,length(exp.participants));
hs_high = zeros(1,length(exp.participants));


count1 = 1;
count2 = 1;
count3 = 1;
count4 = 1;

for i_event = 1:length(ALLEEG);
    
    if strcmp(ALLEEG(i_event).filename(end-23:end),'No_Headset_Low_Tones.set') == 1
        for i_type = 1:length(ALLEEG(i_event).event)
            if strcmp(ALLEEG(i_event).event(i_type).type,'1');
                if nhs_low(count1) == 0
                    nhs_low(count1) = 1;
                elseif nhs_low(count1) > 0
               nhs_low(count1) = nhs_low(count1) + 1;
                end
            end
        end
        count1 = count1+1;
    elseif strcmp(ALLEEG(i_event).filename(end-24:end),'No_Headset_High_Tones.set') == 1
        for i_type = 1:length(ALLEEG(i_event).event)
            if strcmp(ALLEEG(i_event).event(i_type).type,'2');
                if nhs_high(count2) == 0
                    nhs_high(count2) = 1;
                elseif nhs_low(count2) > 0
               nhs_high(count2) = nhs_high(count2) + 1;
                end
            end
        end
        count2 = count2+1;
    elseif strcmp(ALLEEG(i_event).filename(end-20:end),'Headset_Low_Tones.set') == 1
        for i_type = 1:length(ALLEEG(i_event).event)
            if strcmp(ALLEEG(i_event).event(i_type).type,'1');
                if hs_low(count3) == 0
                    hs_low(count3) = 1;
                elseif hs_low(count3) > 0
               hs_low(count3) = hs_low(count3) + 1;
                end
            end
        end
        count3 = count3+1;
    elseif strcmp(ALLEEG(i_event).filename(end-21:end),'Headset_High_Tones.set') == 1
        for i_type = 1:length(ALLEEG(i_event).event)
            if strcmp(ALLEEG(i_event).event(i_type).type,'2');
               if hs_high(count4) == 0
                    hs_high(count4) = 1;
                elseif hs_high(count4) > 0
               hs_high(count4) = hs_high(count4) + 1;
                end
            end
        end
        count4 = count4+1;
    end
end


nhs_total = nhs_low + nhs_high
hs_total = hs_low + hs_high

% % % mean(-nhs_low)
% % % mean(-nhs_high)
% % % mean(-hs_low)
% % % mean(-hs_high)
% % % 
% % % std(-nhs_low)
% % % std(-nhs_high)
% % % std(-hs_low)
% % % std(-hs_high)

mean(nhs_low)
mean(nhs_high)
mean(hs_low)
mean(hs_high)

std(nhs_low)
std(nhs_high)
std(hs_low)
std(hs_high)

min(nhs_low)
min(nhs_high)
min(hs_low)
min(hs_high)

max(nhs_low)
max(nhs_high)
max(hs_low)
max(hs_high)

min(nhs_total)
min(hs_total)

max(nhs_total)
max(hs_total)

%% confirming grabbing right events in trial count
for i_event = 1:length(ALLEEG);
    
    if strcmp(ALLEEG(i_event).filename(end-23:end),'No_Headset_Low_Tones.set') == 1
        for i_type = 1:length(ALLEEG(i_event).event)
            if strcmp(ALLEEG(i_event).event(i_type).type,'1') == 1;
                if nhs_low(count1) == 0
                    nhs_low(count1) = 1;
                elseif nhs_low(count1) > 0
               nhs_low(count1) = nhs_low(count1) + 1;
                end
            end
        end
        count1 = count1+1;
    elseif strcmp(ALLEEG(i_event).filename(end-24:end),'No_Headset_High_Tones.set') == 1
        for i_type = 1:length(ALLEEG(i_event).event)
            if strcmp(ALLEEG(i_event).event(i_type).type,'2') == 1;
                if nhs_high(count2) == 0
                    nhs_high(count2) = 1;
                elseif nhs_low(count2) > 0
               nhs_high(count2) = nhs_high(count2) + 1;
                end
            end
        end
        count2 = count2+1;
    elseif strcmp(ALLEEG(i_event).filename(end-20:end),'Headset_Low_Tones.set') == 1
        for i_type = 1:length(ALLEEG(i_event).event)
            if strcmp(ALLEEG(i_event).event(i_type).type,'1') == 1;
                if hs_low(count3) == 0
                    hs_low(count3) = 1;
                elseif hs_low(count3) > 0
               hs_low(count3) = hs_low(count3) + 1;
                end
            end
        end
        count3 = count3+1;
    elseif strcmp(ALLEEG(i_event).filename(end-21:end),'Headset_High_Tones.set') == 1
        for i_type = 1:length(ALLEEG(i_event).event)
            if strcmp(ALLEEG(i_event).event(i_type).type,'2') == 1;
               if hs_high(count4) == 0
                    hs_high(count4) = 1;
                elseif hs_high(count4) > 0
               hs_high(count4) = hs_high(count4) + 1;
                end
            end
        end
        count4 = count4+1;
    end
end

