%% Plot ERPs of your epochs
% An ERP is a plot of the raw, usually filtered, data, at one or multiple electrodes. It doesn't use time-frequency data.
% We make ERPs if we have segmented datasets that we want to compare across conditions.

% In this case, you are using all your electrodes, not a subset.
electrodes = {EEG.chanlocs(:).labels};
% Type "electrodes" into the command line. This will show you which number to use for i_chan

% This code will take a grand average of the subjects, making one figure per set.
% This is the normal way to present ERP results.
i_chan = [1,15];%%%1(O1) 15(O2) 7(Pz) 8(Cz) 9(Fz) 17(HEOG) 18(VEOG) 
for i_set = 1:nsets
    data_out = [];
    exp.setname{i_set}
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

%%%erpdata, erpdata_parts, all_chan_parts are organised the following%%%
%%%ROWS = Conditions (Depth_1;Depth_2;Depth_3;Depth_4;Depth_5)%%%
%%%COLUMNS = Events...
%%%(Standards,Targets)%%%

%%%%%THE FOLLOWING ARE  FOR EACH PARTICIPANT, SEE BELOW FOR GRAND AVERAGE ERPS%%%%%
% if exp.trigger_set == 1
%     col = {'r';'g';'b';'m';'c'};%%%Orb onset at five depths
% elseif exp.trigger_set == 2
%     col = {'k','r';'k','g';'k','b';'k','m';'k','c'};%%%Colour onset for standards and targets, five depths
% elseif exp.trigger_set == 3
%     col = {'k','r';'k','g';'k','b';'k','m';'k','c'};%%%Colour offset for standards and targets, five depths
% elseif exp.trigger_set == 4
%     col = {'r';'g';'b';'m';'c';};%%%Responses to targets at five depths
% end

col = {'r';'g';'b';'m';'c'};%%%Orb onset at five depths
%%%%% Pick your condition 1 = Depth_1;2 = Depth_2;3 = Depth_3;4 = Depth_4;5 = Depth_5%%%%%
cond1 = 1;
cond2 = 2;
cond3 = 3;
cond4 = 4;
cond5 = 5;
%%%%%Pick your event. May only be one event, based on the trigger set you loaded%%%%%
%%%1 = Standards,2 = Targets
event1 = 1;
event2 = 1;

%%%%%ERPs for high/low tones%%%%%
figure;hold on;
for i_part = 1:nparts
    subplot(ceil(sqrt(nparts)),ceil(sqrt(nparts)),i_part);
    boundedline(EEG.times,erpdata_parts(cond1,event1).cond(:,i_part),std(erpdata_parts(cond1,event1).cond(:,i_part))./sqrt(length(exp.participants)),col{cond1,event1})
%     ,...
%         EEG.times,erpdata_parts(cond2,event1).cond(:,i_part),std(erpdata_parts(cond2,event1).cond(:,i_part))./sqrt(length(exp.participants)),col{cond2,event1},...
%         EEG.times,erpdata_parts(cond3,event1).cond(:,i_part),std(erpdata_parts(cond3,event1).cond(:,i_part))./sqrt(length(exp.participants)),col{cond3,event1},...
%         EEG.times,erpdata_parts(cond4,event1).cond(:,i_part),std(erpdata_parts(cond4,event1).cond(:,i_part))./sqrt(length(exp.participants)),col{cond4,event1},...
%         EEG.times,erpdata_parts(cond5,event1).cond(:,i_part),std(erpdata_parts(cond5,event1).cond(:,i_part))./sqrt(length(exp.participants)),col{cond5,event1},...
%         EEG.times,erpdata_parts(cond1,event2).cond(:,i_part),std(erpdata_parts(cond1,event2).cond(:,i_part))./sqrt(length(exp.participants)),col{cond1,event2},...
%         EEG.times,erpdata_parts(cond2,event2).cond(:,i_part),std(erpdata_parts(cond2,event2).cond(:,i_part))./sqrt(length(exp.participants)),col{cond2,event2},...
%         EEG.times,erpdata_parts(cond3,event2).cond(:,i_part),std(erpdata_parts(cond3,event2).cond(:,i_part))./sqrt(length(exp.participants)),col{cond3,event2},...
%         EEG.times,erpdata_parts(cond4,event2).cond(:,i_part),std(erpdata_parts(cond4,event2).cond(:,i_part))./sqrt(length(exp.participants)),col{cond4,event2},...
%         EEG.times,erpdata_parts(cond5,event2).cond(:,i_part),std(erpdata_parts(cond5,event2).cond(:,i_part))./sqrt(length(exp.participants)),col{cond5,event2});
%     %%%%% epoched to last entrainer %%%%%
    xlim([-200 1000])
    ylim([-10 10])
    set(gca,'Ydir','reverse');
    %%%%% epoched to last entrainegfhr %%%%%
    line([0 0],[-10 10],'color','k');
    line([-200 1000],[0 0],'color','k');
    title(['Participant ' num2str(i_part)]);
end
hold off;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%THE FOLLOWING ARE FOR GRAND AVERAGES%%%%%
% if exp.trigger_set == 1
%     col = {'r';'g';'b';'m';'c'};%%%Orb onset at five depths
% elseif exp.trigger_set == 2
%     col = {'k','r';'k','g';'k','b';'k','m';'k','c'};%%%Colour onset for standards and targets, five depths
% elseif exp.trigger_set == 3
%     col = {'k','r';'k','g';'k','b';'k','m';'k','c'};%%%Colour offset for standards and targets, five depths
% elseif exp.trigger_set == 4
%     col = {'r';'g';'b';'m';'c';};%%%Responses to targets at five depths
% end
col = {'r';'g';'b';'m';'c'};%%%Orb onset at five depths
%%%%% Pick your condition 1 = Depth_1;2 = Depth_2;3 = Depth_3;4 = Depth_4;5 = Depth_5%%%%%
cond1 = 1;
cond2 = 2;
cond3 = 3;
cond4 = 4;
cond5 = 5;
%%%%%Pick your event. May only be one event, based on the trigger set you loaded%%%%%
%%%1 = Standards,2 = Targets
event1 = 1;

%%%%%Grand average ERPs%%%%%
figure;
boundedline(EEG.times,erpdata(cond1,event1).cond,std(erpdata_parts(cond1,event1).cond,[],2)./sqrt(length(exp.participants)),col{cond1,event1},...
    EEG.times,erpdata(cond2,event1).cond,std(erpdata_parts(cond2,event1).cond,[],2)./sqrt(length(exp.participants)),col{cond2,event1},...
    EEG.times,erpdata(cond3,event1).cond,std(erpdata_parts(cond3,event1).cond,[],2)./sqrt(length(exp.participants)),col{cond3,event1},...
    EEG.times,erpdata(cond4,event1).cond,std(erpdata_parts(cond4,event1).cond,[],2)./sqrt(length(exp.participants)),col{cond4,event1},...
    EEG.times,erpdata(cond5,event1).cond,std(erpdata_parts(cond5,event1).cond,[],2)./sqrt(length(exp.participants)),col{cond5,event1},...
    EEG.times,erpdata(cond1,event2).cond,std(erpdata_parts(cond1,event2).cond,[],2)./sqrt(length(exp.participants)),col{cond1,event2},...
    EEG.times,erpdata(cond2,event2).cond,std(erpdata_parts(cond2,event2).cond,[],2)./sqrt(length(exp.participants)),col{cond2,event2},...
    EEG.times,erpdata(cond3,event2).cond,std(erpdata_parts(cond3,event2).cond,[],2)./sqrt(length(exp.participants)),col{cond3,event2},...
    EEG.times,erpdata(cond4,event2).cond,std(erpdata_parts(cond4,event2).cond,[],2)./sqrt(length(exp.participants)),col{cond4,event2},...
    EEG.times,erpdata(cond5,event2).cond,std(erpdata_parts(cond5,event2).cond,[],2)./sqrt(length(exp.participants)),col{cond5,event2});

%%%%% epoched to last entrainer %%%%%
xlim([0 600])
ylim([-10 10])
set(gca,'Ydir','reverse');
%%%%% epoched to last entrainer %%%%%
% % line([10 10],[-10 10],'color','k');
% % line([30 30],[-10 10],'color','k');
% % line([40 40],[-10 10],'color','k');
% % line([60 60],[-10 10],'color','k');
% % line([80 80],[-10 10],'color','k');
% % line([150 150],[-10 10],'color','k');
% % line([150 150],[-10 10],'color','k');
% % line([200 200],[-10 10],'color','k');
% % line([350 350],[-10 10],'color','k');
% % line([550 550],[-10 10],'color','k');
% % line([250 250],[-10 10],'color','k');
% % line([500 500],[-10 10],'color','k');

line([0 0],[-10 10],'color','k');
line([-200 1000],[0 0],'color','k');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%THE FOLLOWING ARE FOR GRAND AVERAGE DIFFERENCE WAVES%%%%%
% if exp.trigger_set == 1
%     col = {'r';'g';'b';'m';'c'};%%%Orb onset at five depths
% elseif exp.trigger_set == 2
%     col = {'k','r';'k','g';'k','b';'k','m';'k','c'};%%%Colour onset for standards and targets, five depths
% elseif exp.trigger_set == 3
%     col = {'k','r';'k','g';'k','b';'k','m';'k','c'};%%%Colour offset for standards and targets, five depths
% elseif exp.trigger_set == 4
%     col = {'r';'g';'b';'m';'c';};%%%Responses to targets at five depths
% end
%%%%% Pick your condition 1 = Depth_1;2 = Depth_2;3 = Depth_3;4 = Depth_4;5 = Depth_5%%%%%
cond1 = 1;
cond2 = 2;
cond3 = 3;
cond4 = 4;
cond5 = 5;
%%%%%Pick your event. May only be one event, based on the trigger set you loaded%%%%%
%%%1 = Standards,2 = Targets
event1 = 1;
event2 = 2;
%%%%%Grand average ERPs%%%%%
figure;
boundedline(EEG.times,(erpdata(cond1,event2).cond-erpdata(cond1,event1).cond),std((erpdata_parts(cond1,event2).cond-erpdata_parts(cond1,event1).cond),[],2)./sqrt(length(exp.participants)),col{cond1,event2},...
EEG.times,(erpdata(cond2,event2).cond-erpdata(cond2,event1).cond),std((erpdata_parts(cond2,event2).cond-erpdata_parts(cond2,event1).cond),[],2)./sqrt(length(exp.participants)),col{cond2,event2},...
EEG.times,(erpdata(cond3,event2).cond-erpdata(cond3,event1).cond),std((erpdata_parts(cond3,event2).cond-erpdata_parts(cond3,event1).cond),[],2)./sqrt(length(exp.participants)),col{cond3,event2},...
EEG.times,(erpdata(cond4,event2).cond-erpdata(cond4,event1).cond),std((erpdata_parts(cond4,event2).cond-erpdata_parts(cond4,event1).cond),[],2)./sqrt(length(exp.participants)),col{cond4,event2},...
EEG.times,(erpdata(cond5,event2).cond-erpdata(cond5,event1).cond),std((erpdata_parts(cond5,event2).cond-erpdata_parts(cond5,event1).cond),[],2)./sqrt(length(exp.participants)),col{cond5,event2});

%%%%% epoched to last entrainer %%%%%
xlim([-200 600])
ylim([-15 15])
set(gca,'Ydir','reverse');
%%%%% epoched to last entrainer %%%%%
line([0 0],[-10 10],'color','k');
line([-200 1000],[0 0],'color','k');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%Power Topoplots%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Pick your condition 1 = Depth_1;2 = Depth_2;3 = Depth_3;4 = Depth_4;5 = Depth_5%%%%%
cond1 = 1;
cond2 = 2;
cond3 = 3;
cond4 = 4;
cond5 = 5;
%%%%%Pick your event. May only be one event, based on the trigger set you loaded%%%%%
%%%1 = Standards,2 = Targets
event1 = 1;
event2 = 1;
%%%%%Pick your time window%%%%%
%%%orb onset
time1 = 75;
time2 = 150;

time1 = 250;
time2 = 500;

%%%colour onset
time1 = 150;
time2 = 250;

time1 = 350;
time2 = 550;

%%%%%Get topoplots for differnce between targets and standards%%%%%
time_window = find(EEG.times>time1,1)-1:find(EEG.times>time2,1)-2;

%%%this is for ERPs to near and far stimuli%%%
erp_cond1 = all_chan_erpdata(cond1,event1).cond;
erp_cond2 = all_chan_erpdata(cond2,event1).cond;
erp_cond3 = all_chan_erpdata(cond3,event1).cond;
erp_cond4 = all_chan_erpdata(cond4,event1).cond;
erp_cond5 = all_chan_erpdata(cond5,event1).cond;

temp1 = mean(erp_cond1(:,time_window),2);
temp2 = mean(erp_cond2(:,time_window),2);
temp3 = mean(erp_cond3(:,time_window),2);
temp4 = mean(erp_cond4(:,time_window),2);
temp5 = mean(erp_cond5(:,time_window),2);
temp1(17:18) = NaN;
temp2(17:18) = NaN;
temp3(17:18) = NaN;
temp4(17:18) = NaN;
temp5(17:18) = NaN;

lims = [-5 5];

figure('Color',[1 1 1]);
set(gca,'Color',[1 1 1]);
topoplot((temp1),exp.electrode_locs, 'whitebk','on','plotrad',.6,'maplimits',lims)
title([exp.setname{cond1} '_' exp.event_names{event1}]);
t = colorbar('peer',gca);
set(get(t,'ylabel'),'String', 'Voltage Difference (uV)');

figure('Color',[1 1 1]);
set(gca,'Color',[1 1 1]);
topoplot((temp2),exp.electrode_locs, 'whitebk','on','plotrad',.6,'maplimits',lims)
title([exp.setname{cond2} '_' exp.event_names{event2}]);
t = colorbar('peer',gca);
set(get(t,'ylabel'),'String', 'Voltage Difference (uV)');

figure('Color',[1 1 1]);
set(gca,'Color',[1 1 1]);
topoplot((temp3),exp.electrode_locs, 'whitebk','on','plotrad',.6,'maplimits',lims)
title([exp.setname{cond1} '_' exp.event_names{event1}]);
t = colorbar('peer',gca);
set(get(t,'ylabel'),'String', 'Voltage Difference (uV)');

figure('Color',[1 1 1]);
set(gca,'Color',[1 1 1]);
topoplot((temp4),exp.electrode_locs, 'whitebk','on','plotrad',.6,'maplimits',lims)
title([exp.setname{cond2} '_' exp.event_names{event2}]);
t = colorbar('peer',gca);
set(get(t,'ylabel'),'String', 'Voltage Difference (uV)');

figure('Color',[1 1 1]);
set(gca,'Color',[1 1 1]);
topoplot((temp5),exp.electrode_locs, 'whitebk','on','plotrad',.6,'maplimits',lims)
title([exp.setname{cond2} '_' exp.event_names{event2}]);
t = colorbar('peer',gca);
set(get(t,'ylabel'),'String', 'Voltage Difference (uV)');

%%%%%Power Topoplots%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Pick your condition 1 = Depth_1;2 = Depth_2;3 = Depth_3;4 = Depth_4;5 = Depth_5%%%%%
cond1 = 1;
cond2 = 2;
cond3 = 3;
cond4 = 4;
cond5 = 5;
%%%%%Pick your event. May only be one event, based on the trigger set you loaded%%%%%
%%%1 = Standards,2 = Targets
event1 = 1;
event2 = 2;
%%%%%Pick your time window%%%%%
time1 = 150;
time2 = 250;

time1 = 350;
time2 = 550;

%%%%%Get topoplots for differnce between targets and standards%%%%%
time_window = find(EEG.times>time1,1)-1:find(EEG.times>time2,1)-2;

%%%standards%%%
erp_stnd1 = all_chan_erpdata(cond1,event1).cond;
erp_stnd2 = all_chan_erpdata(cond2,event1).cond;
erp_stnd3 = all_chan_erpdata(cond3,event1).cond;
erp_stnd4 = all_chan_erpdata(cond4,event1).cond;
erp_stnd5 = all_chan_erpdata(cond5,event1).cond;

temps1 = mean(erp_stnd1(:,time_window),2);
temps2 = mean(erp_stnd2(:,time_window),2);
temps3 = mean(erp_stnd3(:,time_window),2);
temps4 = mean(erp_stnd4(:,time_window),2);
temps5 = mean(erp_stnd5(:,time_window),2);
temps1(17:18) = NaN;
temps2(17:18) = NaN;
temps3(17:18) = NaN;
temps4(17:18) = NaN;
temps5(17:18) = NaN;

%%%targets%%%
erp_targ1 = all_chan_erpdata(cond1,event2).cond;
erp_targ2 = all_chan_erpdata(cond2,event2).cond;
erp_targ3 = all_chan_erpdata(cond3,event2).cond;
erp_targ4 = all_chan_erpdata(cond4,event2).cond;
erp_targ5 = all_chan_erpdata(cond5,event2).cond;

tempt1 = mean(erp_targ1(:,time_window),2);
tempt2 = mean(erp_targ2(:,time_window),2);
tempt3 = mean(erp_targ3(:,time_window),2);
tempt4 = mean(erp_targ4(:,time_window),2);
tempt5 = mean(erp_targ5(:,time_window),2);
tempt1(17:18) = NaN;
tempt2(17:18) = NaN;
tempt3(17:18) = NaN;
tempt4(17:18) = NaN;
tempt5(17:18) = NaN;

%%%difference%%%
erp_diff1 = (all_chan_erpdata(cond1,event2).cond-all_chan_erpdata(cond1,event1).cond);
erp_diff2 = (all_chan_erpdata(cond2,event2).cond-all_chan_erpdata(cond2,event1).cond);
erp_diff3 = (all_chan_erpdata(cond3,event2).cond-all_chan_erpdata(cond3,event1).cond);
erp_diff4 = (all_chan_erpdata(cond4,event2).cond-all_chan_erpdata(cond4,event1).cond);
erp_diff5 = (all_chan_erpdata(cond5,event2).cond-all_chan_erpdata(cond5,event1).cond);

tempd1 = mean(erp_diff1(:,time_window),2);
tempd2 = mean(erp_diff2(:,time_window),2);
tempd3 = mean(erp_diff3(:,time_window),2);
tempd4 = mean(erp_diff4(:,time_window),2);
tempd5 = mean(erp_diff5(:,time_window),2);
tempd1(17:18) = NaN;
tempd2(17:18) = NaN;
tempd3(17:18) = NaN;
tempd4(17:18) = NaN;
tempd5(17:18) = NaN;

lims = [-5 5];

figure('Color',[1 1 1]);
set(gca,'Color',[1 1 1]);
topoplot((temps1),exp.electrode_locs, 'whitebk','on','plotrad',.6,'maplimits',lims)
title([exp.setname{cond1} '_' exp.event_names{event1}]);
t = colorbar('peer',gca);
set(get(t,'ylabel'),'String', 'Voltage Difference (uV)');

figure('Color',[1 1 1]);
set(gca,'Color',[1 1 1]);
topoplot((temps2),exp.electrode_locs, 'whitebk','on','plotrad',.6,'maplimits',lims)
title([exp.setname{cond2} '_' exp.event_names{event2}]);
t = colorbar('peer',gca);
set(get(t,'ylabel'),'String', 'Voltage Difference (uV)');

figure('Color',[1 1 1]);
set(gca,'Color',[1 1 1]);
topoplot((temps3),exp.electrode_locs, 'whitebk','on','plotrad',.6,'maplimits',lims)
title([exp.setname{cond1} '_' exp.event_names{event1}]);
t = colorbar('peer',gca);
set(get(t,'ylabel'),'String', 'Voltage Difference (uV)');

figure('Color',[1 1 1]);
set(gca,'Color',[1 1 1]);
topoplot((temps4),exp.electrode_locs, 'whitebk','on','plotrad',.6,'maplimits',lims)
title([exp.setname{cond2} '_' exp.event_names{event2}]);
t = colorbar('peer',gca);
set(get(t,'ylabel'),'String', 'Voltage Difference (uV)');

figure('Color',[1 1 1]);
set(gca,'Color',[1 1 1]);
topoplot((temps5),exp.electrode_locs, 'whitebk','on','plotrad',.6,'maplimits',lims)
title([exp.setname{cond2} '_' exp.event_names{event2}]);
t = colorbar('peer',gca);
set(get(t,'ylabel'),'String', 'Voltage Difference (uV)');

figure('Color',[1 1 1]);
set(gca,'Color',[1 1 1]);
topoplot((tempt1),exp.electrode_locs, 'whitebk','on','plotrad',.6,'maplimits',lims)
title([exp.setname{cond1} '_' exp.event_names{event1}]);
t = colorbar('peer',gca);
set(get(t,'ylabel'),'String', 'Voltage Difference (uV)');

figure('Color',[1 1 1]);
set(gca,'Color',[1 1 1]);
topoplot((tempt2),exp.electrode_locs, 'whitebk','on','plotrad',.6,'maplimits',lims)
title([exp.setname{cond2} '_' exp.event_names{event2}]);
t = colorbar('peer',gca);
set(get(t,'ylabel'),'String', 'Voltage Difference (uV)');

figure('Color',[1 1 1]);
set(gca,'Color',[1 1 1]);
topoplot((tempt3),exp.electrode_locs, 'whitebk','on','plotrad',.6,'maplimits',lims)
title([exp.setname{cond1} '_' exp.event_names{event1}]);
t = colorbar('peer',gca);
set(get(t,'ylabel'),'String', 'Voltage Difference (uV)');

figure('Color',[1 1 1]);
set(gca,'Color',[1 1 1]);
topoplot((tempt4),exp.electrode_locs, 'whitebk','on','plotrad',.6,'maplimits',lims)
title([exp.setname{cond2} '_' exp.event_names{event2}]);
t = colorbar('peer',gca);
set(get(t,'ylabel'),'String', 'Voltage Difference (uV)');

figure('Color',[1 1 1]);
set(gca,'Color',[1 1 1]);
topoplot((tempt5),exp.electrode_locs, 'whitebk','on','plotrad',.6,'maplimits',lims)
title([exp.setname{cond2} '_' exp.event_names{event2}]);
t = colorbar('peer',gca);
set(get(t,'ylabel'),'String', 'Voltage Difference (uV)');

figure('Color',[1 1 1]);
set(gca,'Color',[1 1 1]);
topoplot((tempd1),exp.electrode_locs, 'whitebk','on','plotrad',.6,'maplimits',lims)
title([exp.setname{cond1} '_' exp.event_names{event1}]);
t = colorbar('peer',gca);
set(get(t,'ylabel'),'String', 'Voltage Difference (uV)');

figure('Color',[1 1 1]);
set(gca,'Color',[1 1 1]);
topoplot((tempd2),exp.electrode_locs, 'whitebk','on','plotrad',.6,'maplimits',lims)
title([exp.setname{cond2} '_' exp.event_names{event2}]);
t = colorbar('peer',gca);
set(get(t,'ylabel'),'String', 'Voltage Difference (uV)');

figure('Color',[1 1 1]);
set(gca,'Color',[1 1 1]);
topoplot((tempd3),exp.electrode_locs, 'whitebk','on','plotrad',.6,'maplimits',lims)
title([exp.setname{cond1} '_' exp.event_names{event1}]);
t = colorbar('peer',gca);
set(get(t,'ylabel'),'String', 'Voltage Difference (uV)');

figure('Color',[1 1 1]);
set(gca,'Color',[1 1 1]);
topoplot((tempd4),exp.electrode_locs, 'whitebk','on','plotrad',.6,'maplimits',lims)
title([exp.setname{cond2} '_' exp.event_names{event2}]);
t = colorbar('peer',gca);
set(get(t,'ylabel'),'String', 'Voltage Difference (uV)');

figure('Color',[1 1 1]);
set(gca,'Color',[1 1 1]);
topoplot((tempd5),exp.electrode_locs, 'whitebk','on','plotrad',.6,'maplimits',lims)
title([exp.setname{cond2} '_' exp.event_names{event2}]);
t = colorbar('peer',gca);
set(get(t,'ylabel'),'String', 'Voltage Difference (uV)');


%%%here we can make bar graphs of the averaged activity across regions%%%
%%%%% Pick your condition 1 = Depth_1;2 = Depth_2;3 = Depth_3;4 = Depth_4;5 = Depth_5%%%%%
cond1 = 1;
cond2 = 2;
cond3 = 3;
cond4 = 4;
cond5 = 5;
%%%%%Pick your event. May only be one event, based on the trigger set you loaded%%%%%
%%%1 = Standards,2 = Targets
event1 = 1;
event2 = 1;
%%%%%Pick your time window%%%%%

%%%P1 ~= 10-30ms
time1 = 10;
time2 = 30;
%%%N1 ~= 40-60ms
time1 = 40;
time2 = 60;
%%%P2 ~= 80-150ms
time1 = 80;
time2 = 150;
%%%N2 ~= 150-200ms
time1 = 150;
time2 = 200;
%%%P3 ~= 300-400ms
time1 = 350;
time2 = 550;

%%%%%Get topoplots for differnce between targets and standards%%%%%
time_window = find(EEG.times>time1,1)-1:find(EEG.times>time2,1)-2;

temp1 = mean(erpdata(cond1,event1).cond(1,time_window));
temp2 = mean(erpdata(cond2,event1).cond(1,time_window));
temp3 = mean(erpdata(cond3,event1).cond(1,time_window));
temp4 = mean(erpdata(cond4,event1).cond(1,time_window));
temp5 = mean(erpdata(cond5,event1).cond(1,time_window));

temp1se = mean(std(erpdata_parts(cond1,event1).cond(time_window,:),[],2)/nparts);
temp2se = mean(std(erpdata_parts(cond2,event1).cond(time_window,:),[],2)/nparts);
temp3se = mean(std(erpdata_parts(cond3,event1).cond(time_window,:),[],2)/nparts);
temp4se = mean(std(erpdata_parts(cond4,event1).cond(time_window,:),[],2)/nparts);
temp5se = mean(std(erpdata_parts(cond5,event1).cond(time_window,:),[],2)/nparts);

figure;hold on;
bar([temp1,temp2,temp3,temp4,temp5]);
errorbar([temp1,temp2,temp3,temp4,temp5],[temp1se,temp2se,temp3se,temp4se,temp5se],'.');
hold off;

%%%bar graphs for colour onset%%%
%%%%% Pick your condition 1 = Depth_1;2 = Depth_2;3 = Depth_3;4 = Depth_4;5 = Depth_5%%%%%
cond1 = 1;
cond2 = 2;
cond3 = 3;
cond4 = 4;
cond5 = 5;
%%%%%Pick your event. May only be one event, based on the trigger set you loaded%%%%%
%%%1 = Standards,2 = Targets
event1 = 1;
event2 = 2;
%%%%%Pick your time window%%%%%

%%%P1 ~= 10-30ms
time1 = 10;
time2 = 30;
%%%N1 ~= 40-60ms
time1 = 40;
time2 = 60;
%%%P2 ~= 80-150ms
time1 = 80;
time2 = 150;
%%%N2 ~= 150-200ms
time1 = 150;
time2 = 200;
%%%P3 ~= 300-400ms
time1 = 350;
time2 = 550;

time1 = 100;
time2 = 200;

%%%%%Get topoplots for differnce between targets and standards%%%%%
time_window = find(EEG.times>time1,1)-1:find(EEG.times>time2,1)-2;

temp1 = mean(erpdata(cond1,event2).cond(1,time_window)-erpdata(cond1,event1).cond(1,time_window));
temp2 = mean(erpdata(cond2,event2).cond(1,time_window)-erpdata(cond2,event1).cond(1,time_window));
temp3 = mean(erpdata(cond3,event2).cond(1,time_window)-erpdata(cond3,event1).cond(1,time_window));
temp4 = mean(erpdata(cond4,event2).cond(1,time_window)-erpdata(cond4,event1).cond(1,time_window));
temp5 = mean(erpdata(cond5,event2).cond(1,time_window)-erpdata(cond5,event1).cond(1,time_window));

temp1se = mean(std(erpdata_parts(cond1,event2).cond(time_window,:)-erpdata_parts(cond1,event1).cond(time_window,:),[],2)/sqrt(nparts));
temp2se = mean(std(erpdata_parts(cond2,event2).cond(time_window,:)-erpdata_parts(cond2,event1).cond(time_window,:),[],2)/sqrt(nparts));
temp3se = mean(std(erpdata_parts(cond3,event2).cond(time_window,:)-erpdata_parts(cond3,event1).cond(time_window,:),[],2)/sqrt(nparts));
temp4se = mean(std(erpdata_parts(cond4,event2).cond(time_window,:)-erpdata_parts(cond4,event1).cond(time_window,:),[],2)/sqrt(nparts));
temp5se = mean(std(erpdata_parts(cond5,event2).cond(time_window,:)-erpdata_parts(cond5,event1).cond(time_window,:),[],2)/sqrt(nparts));

temp1 = mean(erpdata(cond1,event1).cond(1,time_window));
temp2 = mean(erpdata(cond2,event1).cond(1,time_window));
temp3 = mean(erpdata(cond3,event1).cond(1,time_window));
temp4 = mean(erpdata(cond4,event1).cond(1,time_window));
temp5 = mean(erpdata(cond5,event1).cond(1,time_window));

temp1se = mean(std(erpdata_parts(cond1,event1).cond(time_window,:),[],2)/sqrt(nparts));
temp2se = mean(std(erpdata_parts(cond2,event1).cond(time_window,:),[],2)/sqrt(nparts));
temp3se = mean(std(erpdata_parts(cond3,event1).cond(time_window,:),[],2)/sqrt(nparts));
temp4se = mean(std(erpdata_parts(cond4,event1).cond(time_window,:),[],2)/sqrt(nparts));
temp5se = mean(std(erpdata_parts(cond5,event1).cond(time_window,:),[],2)/sqrt(nparts));

figure;hold on;
bar([temp1,temp2,temp3,temp4,temp5]);
errorbar([temp1,temp2,temp3,temp4,temp5],[temp1se,temp2se,temp3se,temp4se,temp5se],'.');
hold off;
