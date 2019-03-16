%% Plot ERPs of your epochs
% An ERP is a plot of the raw, usually filtered, data, at one or multiple electrodes. It doesn't use time-frequency data.
% We make ERPs if we have segmented datasets that we want to compare across conditions.

% In this case, you are using all your electrodes, not a subset.
electrodes = {EEG.chanlocs(:).labels};
% Type "electrodes" into the command line. This will show you which number to use for i_chan

% This code will take a grand average of the subjects, making one figure per set.
% This is the normal way to present ERP results.
i_chan = [1,15];%%%1(O1) 15(O2) 7(Pz) 8(Cz) 9(Fz) 17(VEOG) 18(HEOG)
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
    end
end

% % Standards
% % erpdata(1,1) = Far/Near
% % erpdata(2,1) = Far/Near
% %
% % Targets
% % erpdata(1,2) = Far/Near
% % erpdata(2,2) = Far/Near

%%%%%THE FOLLOWING ARE  FOR EACH PARTICIPANT, SEE BELOW FOR MEAN TONES%%%%%
col = ['k','b';'k','r'];
%%%%% Pick your condition 1 = Far; 2 = Near%%%%%
cond1 = 1;
cond2 = 2;
%%%%%Pick your tone 1 = Standards; 2 = Targets%%%%%
event1 = 1;
event2 = 1;

%%%%%ERPs for high/low tones%%%%%
figure;hold on;
for i_part = 1:nparts
    subplot(ceil(sqrt(nparts)),ceil(sqrt(nparts)),i_part);boundedline(EEG.times,erpdata_parts(cond1,event1).cond(:,i_part),std(erpdata_parts(cond1,event1).cond(:,i_part))./sqrt(length(exp.participants)),col(cond1,event1),...
        EEG.times,erpdata_parts(cond2,event2).cond(:,i_part),std(erpdata_parts(cond2,event2).cond(:,i_part))./sqrt(length(exp.participants)),col(cond2,event2));
    %%%%% epoched to last entrainer %%%%%
    xlim([-200 1000])
    ylim([-15 15])
    set(gca,'Ydir','reverse');
    %%%%% epoched to last entrainegfhr %%%%%
    line([0 0],[-10 10],'color','k');
    line([-200 1000],[0 0],'color','k');
    title(['Participant ' num2str(i_part)]);
end
hold off;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%THE FOLLOWING ARE FOR TONES%%%%%
col = ['b','b';'r','r']; %%%uncomment to compare one event type across conditions
% % col = ['k','b';'k','r']; %%%uncomment for standards and targets
% % col = ['b','r';'r','b']; %%%use this to compare NEAR and FAR, regardless of standards or targets
%%%%% Pick your condition 1 = Far Targets; 2 = Near Targets%%%%%
cond1 = 1;
cond2 = 2;
%%%%%Pick your event 1 = Standards; 2 = Targets%%%%%
event1 = 1;
event2 = 2;
%%%%%ERPs for standards and targets%%%%%
% % figure;boundedline(EEG.times(801:2000),erpdata(cond1,event1).cond(801:2000),std(erpdata_parts(cond1,event1).cond(801:2000),[],2)./sqrt(length(exp.participants)),col(cond1,event1),...
% %     EEG.times(801:2000),erpdata(cond2,event2).cond(801:2000),std(erpdata_parts(cond2,event2).cond(801:2000),[],2)./sqrt(length(exp.participants)),col(cond2,event2));

% % %%Difference Waves for standards and targets%%%%%
% % figure;boundedline(EEG.times(801:2000),(erpdata(cond1,event2).cond(801:2000)-erpdata(cond1,event1).cond(801:2000)),std(erpdata_parts(cond1,event2).cond(801:2000,:)-erpdata_parts(cond1,event1).cond(801:2000,:),[],2)./sqrt(length(exp.participants)),col(cond1,event1),...
% %     EEG.times(801:2000),(erpdata(cond2,event2).cond(801:2000)-erpdata(cond2,event1).cond(801:2000)),std(erpdata_parts(cond2,event2).cond(801:2000,:)-erpdata_parts(cond2,event1).cond(801:2000,:),[],2)./sqrt(length(exp.participants)),col(cond2,event2));

%%%Combine near and far orbs, regardless of being standard or target%%%
figure;boundedline(EEG.times(801:2000),mean(cat(3,erpdata(cond1,event2).cond(801:2000),erpdata(cond2,event1).cond(801:2000)),3),std(mean(cat(3,erpdata_parts(cond1,event2).cond(801:2000,:),erpdata_parts(cond2,event1).cond(801:2000,:)),3),[],2)./sqrt(length(exp.participants)),col(cond1,event1),...
    EEG.times(801:2000),mean(cat(3,erpdata(cond1,event1).cond(801:2000),erpdata(cond2,event2).cond(801:2000)),3),std(mean(cat(3,erpdata_parts(cond1,event1).cond(801:2000,:),erpdata_parts(cond2,event2).cond(801:2000,:)),3),[],2)./sqrt(length(exp.participants)),col(cond2,event2));

%%%%% epoched to last entrainer %%%%%
xlim([-200 1000])
ylim([-10 10])
set(gca,'Ydir','reverse');
%%%%% epoched to last entrainer %%%%%
line([0 0],[-10 10],'color','k');
line([-200 1000],[0 0],'color','k');

exist('M:\Data\Face_Place_P3\007_1_all_familiarity_p3_trigs_muse.csv','file')

line([200 200],[-10 10],'color','k');
line([300 300],[-10 10],'color','k');

%%%%%now make bar plots for the P3 region%%%
%%%%% Pick your condition 1 = far; 2 = near%%%%%
cond1 = 1;
cond2 = 2;
%%%%%Pick your tone 1 = standards 2 = targets%%%%%
event1 = 1;
event2 = 2;
%%%P3%%%
time1 = 300;
time2 = 600;
%%%%%Get bars for differnce between targets and standards%%%%%
time_window = find(EEG.times>time1,1)-1:find(EEG.times>time2,1)-2;

figure;hold on;
bar([mean(erpdata(cond1,event2).cond(time_window)-erpdata(cond1,event1).cond(time_window));mean(erpdata(cond2,event2).cond(time_window)-erpdata(cond2,event1).cond(time_window))]);
errorbar([mean(erpdata(cond1,event2).cond(time_window)-erpdata(cond1,event1).cond(time_window));mean(erpdata(cond2,event2).cond(time_window)-erpdata(cond2,event1).cond(time_window))],...
    [std(erpdata(cond1,event2).cond(time_window)-erpdata(cond1,event1).cond(time_window))./sqrt(length(exp.participants));std(erpdata(cond2,event2).cond(time_window)-erpdata(cond2,event1).cond(time_window))./sqrt(length(exp.participants))],'.');
ylim([1,2.5]);
hold off;


%%%%% Pick your condition 1 = far; 2 = near%%%%%
cond1 = 1;
cond2 = 2;
%%%%%Pick your tone 1 = standards 2 = targets%%%%%
event1 = 1;
event2 = 2;
%%%P3%%%
time1 = 300;
time2 = 600;
%%%%%Get bars for differnce between far and near%%%%%
time_window = find(EEG.times>time1,1)-1:find(EEG.times>time2,1)-2;
figure;hold on;
bar([mean(mean(cat(3,erpdata(cond1,event2).cond(time_window),erpdata(cond2,event1).cond(time_window)),3));mean(mean(cat(3,erpdata(cond1,event1).cond(time_window),erpdata(cond2,event2).cond(time_window)),3))]);
errorbar([mean(mean(cat(3,erpdata(cond1,event2).cond(time_window),erpdata(cond2,event1).cond(time_window)),3));mean(mean(cat(3,erpdata(cond1,event1).cond(time_window),erpdata(cond2,event2).cond(time_window)),3))],...
    [std(mean(mean(cat(3,erpdata_parts(cond1,event2).cond(time_window,:),erpdata_parts(cond2,event1).cond(time_window,:)),3),2))./sqrt(length(exp.participants));std(mean(mean(cat(3,erpdata_parts(cond1,event1).cond(time_window,:),erpdata_parts(cond2,event2).cond(time_window,:)),3),2))./sqrt(length(exp.participants))],'.');
ylim([3.5,4.5]);
hold off;


%%%lines for near%%
% line([17 17],[-20 20],'color','k');%%%min
% line([380 380],[-20 20],'color','k');%%%avg
% line([2725 2725],[-20 20],'color','k');%%%max

%%%lines for far%%
% line([50 50],[-20 20],'color','b');%%%min
% line([376 376],[-20 20],'color','b');%%%avg
% line([2209 2209],[-20 20],'color','b');%%%max
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%Power Topoplots%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Pick your condition 1 = far; 2 = near%%%%%
cond1 = 1;
cond2 = 2;
%%%%%Pick your tone 1 = standards 2 = targets%%%%%
event1 = 1;
event2 = 2;
%%%%%Pick your time window%%%%%
%%%%%%
time1 = 50;
time2 = 150;

%%%N2%%%
time1 = 150;
time2 = 200;

%%%P2%%%
time1 = 225;
time2 = 300;

%%%P3%%%
time1 = 300;
time2 = 600;

time_window = find(EEG.times>time1,1)-1:find(EEG.times>time2,1)-2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%this is for ERPs to near and far stimuli%%%
erp_near = mean(cat(3,all_chan_erpdata(cond1,event1).cond,all_chan_erpdata(cond2,event2).cond),3);
erp_far = mean(cat(3,all_chan_erpdata(cond1,event2).cond,all_chan_erpdata(cond2,event1).cond),3);

temp1 = mean(erp_far(:,time_window),2);
temp2 = mean(erp_near(:,time_window),2);
temp1(17:18) = NaN;
temp2(17:18) = NaN;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%this is for ERPs to near and far standards/targets%%%
erp_near_standards = all_chan_erpdata(cond1,event1).cond;
erp_far_standards = all_chan_erpdata(cond2,event2).cond;

temp1 = mean(erp_near_standards(:,time_window),2);
temp2 = mean(erp_far_standards(:,time_window),2);
temp1(17:18) = NaN;
temp2(17:18) = NaN;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%below is for the difference wave between targets and standards%%%
erp_diff_out_far = (all_chan_erpdata(cond1,event2).cond-all_chan_erpdata(cond1,event1).cond);
erp_diff_out_near = (all_chan_erpdata(cond2,event2).cond-all_chan_erpdata(cond2,event1).cond);

temp1 = mean(erp_diff_out_far(:,time_window),2);
temp2 = mean(erp_diff_out_near(:,time_window),2);
temp1(17:18) = NaN;
temp2(17:18) = NaN;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Color',[1 1 1]);
set(gca,'Color',[1 1 1]);
subplot(1,2,1);
topoplot((temp1),exp.electrode_locs, 'whitebk','on','plotrad',.6,'maplimits',[-5 5])
title('Far');
t = colorbar('peer',gca);
set(get(t,'ylabel'),'String', 'Voltage Difference (uV)');

subplot(1,2,2);
topoplot((temp2),exp.electrode_locs, 'whitebk','on','plotrad',.6,'maplimits',[-5 5])
title('Near');
t = colorbar('peer',gca);
set(get(t,'ylabel'),'String', 'Voltage Difference (uV)');

%%%%%Difference Topoplots%%%%%
figure('Color',[1 1 1]);
set(gca,'Color',[1 1 1]);

topoplot((temp1-temp2),exp.electrode_locs, 'whitebk','on','plotrad',.6,'maplimits',[-3 3])
title('Far - Near');
t = colorbar('peer',gca);
set(get(t,'ylabel'),'String', 'Voltage Difference (uV)');



%%%stats for comparisons of difference waves%%%
%%%%% Pick your condition 1 = far; 2 = near%%%%%
cond1 = 1;
cond2 = 2;
%%%%%Pick your tone 1 = standards 2 = targets%%%%%
event1 = 1;
event2 = 2;
%%%%%Pick your time window%%%%%
%%%%%%
time1 = 50;
time2 = 150;

%%%N2%%%
time1 = 150;
time2 = 200;

%%%P2%%%
time1 = 225;
time2 = 300;

%%%P3%%%
time1 = 300;
time2 = 600;

time_window = find(EEG.times>time1,1)-1:find(EEG.times>time2,1)-2;

erp_diff_out_far = mean((erpdata_parts(cond1,event2).cond(time_window,:)-erpdata_parts(cond1,event1).cond(time_window,:)),1);
erp_diff_out_near = mean((erpdata_parts(cond2,event2).cond(time_window,:)-erpdata_parts(cond2,event1).cond(time_window,:)),1);

[h p ci stat] = ttest(erp_diff_out_far,erp_diff_out_near,.05,'both',2);

h
p
ci
stat

%%%one tailed tests%%%
%%%%% Pick your condition 1 = far; 2 = near%%%%%
cond1 = 1;
cond2 = 2;
%%%%%Pick your tone 1 = standards 2 = targets%%%%%
event1 = 1;
event2 = 2;
%%%%%Pick your time window%%%%%
%%%%%%
time1 = 50;
time2 = 150;

%%%N2%%%
time1 = 150;
time2 = 200;

%%%P2%%%
time1 = 225;
time2 = 300;

%%%P3%%%
time1 = 300;
time2 = 600;

time_window = find(EEG.times>time1,1)-1:find(EEG.times>time2,1)-2;

erp_targs_far = mean(erpdata_parts(cond1,event2).cond(time_window,:),1);
erp_targs_near = mean(erpdata_parts(cond2,event2).cond(time_window,:),1);

[h p ci stat] = ttest(erp_diff_out_far,0,.05,'right',2);
h
p
ci
stat

[h p ci stat] = ttest(erp_diff_out_near,0,.05,'right',2);
h
p
ci
stat

[h p ci stat] = ttest(erp_diff_out_far,0,.05,'left',2);
h
p
ci
stat

[h p ci stat] = ttest(erp_diff_out_near,0,.05,'left',2);
h
p
ci
stat


%%%stats for comparisons of near and far stimuli%%%
%%%%% Pick your condition 1 = far; 2 = near%%%%%
cond1 = 1;
cond2 = 2;
%%%%%Pick your tone 1 = standards 2 = targets%%%%%
event1 = 1;
event2 = 2;
%%%%%Pick your time window%%%%%
%%%%%%
time1 = 50;
time2 = 150;

%%%N2%%%
time1 = 150;
time2 = 200;

%%%P2%%%
time1 = 225;
time2 = 300;

%%%P3%%%
time1 = 300;
time2 = 600;

time_window = find(EEG.times>time1,1)-1:find(EEG.times>time2,1)-2;

erp_near = mean(mean(cat(3,erpdata_parts(cond1,event1).cond(time_window,:),erpdata_parts(cond2,event2).cond(time_window,:)),3),1);
erp_far = mean(mean(cat(3,erpdata_parts(cond1,event2).cond(time_window,:),erpdata_parts(cond2,event1).cond(time_window,:)),3),1);


[h p ci stat] = ttest(erp_far,erp_near,.05,'both',2);

h
p
ci
stat

%%%one tailed tests%%%
%%%%% Pick your condition 1 = far; 2 = near%%%%%
cond1 = 1;
cond2 = 2;
%%%%%Pick your tone 1 = standards 2 = targets%%%%%
event1 = 1;
event2 = 2;
%%%%%Pick your time window%%%%%
%%%%%%
time1 = 50;
time2 = 150;

%%%N2%%%
time1 = 150;
time2 = 200;

%%%P2%%%
time1 = 225;
time2 = 300;

%%%P3%%%
time1 = 300;
time2 = 600;

time_window = find(EEG.times>time1,1)-1:find(EEG.times>time2,1)-2;

erp_targs_far = mean(erpdata_parts(cond1,event2).cond(time_window,:),1);
erp_targs_near = mean(erpdata_parts(cond2,event2).cond(time_window,:),1);

[h p ci stat] = ttest(erp_diff_out_far,0,.05,'right',2);
h
p
ci
stat

[h p ci stat] = ttest(erp_diff_out_near,0,.05,'right',2);
h
p
ci
stat

[h p ci stat] = ttest(erp_diff_out_far,0,.05,'left',2);
h
p
ci
stat

[h p ci stat] = ttest(erp_diff_out_near,0,.05,'left',2);
h
p
ci
stat

