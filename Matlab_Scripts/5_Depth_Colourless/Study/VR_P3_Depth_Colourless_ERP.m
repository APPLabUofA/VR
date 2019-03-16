%% Plot ERPs of your epochs
% An ERP is a plot of the raw, usually filtered, data, at one or multiple electrodes. It doesn't use time-frequency data.
% We make ERPs if we have segmented datasets that we want to compare across conditions.

% In this case, you are using all your electrodes, not a subset.
electrodes = {EEG.chanlocs(:).labels};
% Type "electrodes" into the command line. This will show you which number to use for i_chan
ndepths = 5;
%%% initialize condtion for naming figures + target_depth based off of
%%% wrapper initialized exp.condition (used to speccify standard/target)
if exp.condition_set == 1
    titled = 'Near';
    target_depth = 1;
elseif exp.condition_set == 2
    titled = 'Far';
    target_depth = 5;
else
    print('exp.condition_set is not set properly')
end
event_1 = 1; %% Only one event type per position per loaded data set 

%%% Initialize 2 time maps (start (10,40,80,etc.) & end (30,60,150,etc.) of window) based off of wave_keySet of ERP components ('P1','N1',etc.) 
%%% P1 ~ 10-30ms %%%N1 ~ 40-60ms %%%P2 ~ 80-150ms %%%N2 ~ 150-200ms %%%P3 ~ 300-400ms
%%% *** all you have to do is change the waveform! ****
waveform = 'P3';
% Initialize dict structs
wave_keySet = {'P1','N1','P2','N2','P3'};
valueSet_time_1 = {10,40,80,150,350}; valueSet_time_2 = {30,60,150,200,550};
% Build Maps
Time_Map_1 = containers.Map(wave_keySet,valueSet_time_1); Time_Map_2 = containers.Map(wave_keySet,valueSet_time_2);
% Pull from maps + construct frame from times pulled
time_1 = Time_Map_1(waveform); time_2 = Time_Map_2(waveform);
time_window = find(EEG.times>time_1,1)-1:find(EEG.times>time_2,1)-2;

% These are for optimizing later
electode_site_num = [1,15,7,8,9,17,18]; % double
electode_site_name = {'O1','O2','Pz','Cz','Fz','VEOG','HEOG'}; % cell

% Notes for optimizing:
% Have each figure include which electrode the figure was derived from (if applicable)
% Loop through each event type (ONSET, RESP, OFFSET) + at each relevant electrode site 
% + each relevant waveform component

i_chan = 7; %%% 1(O1) 15(O2) 7(Pz) 8(Cz) 9(Fz) 17(VEOG) 18(HEOG)
for i_set = 1:nsets
    data_out = [];
    exp.setname{i_set};
    for eegset = 1:nevents
        exp.event_names{1,eegset};
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
%%%COLUMNS = Conditions 
%%%ROWS = (Depth_1;Depth_2;Depth_3;Depth_4;Depth_5) %%%
%%%(Depends on loaded dataset)%%%

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%THE FOLLOWING ARE  FOR EACH PARTICIPANT, ALL 5 DEPTHS%%%%%
col = {'r';'g';'b';'m';'c'};%%%Orb onset, response, offset (depending on loaded dataset - at five depths
%%%%%ERPs for each depth%%%%%
figure;hold on;
for i_part = 1:nparts
    subplot(ceil(sqrt(nparts)),ceil(sqrt(nparts)),i_part);
    for i_depth = 1:ndepths
        boundedline(EEG.times,erpdata_parts(i_depth,event_1).cond(:,i_part),std(erpdata_parts(i_depth,event_1).cond(:,i_part))./sqrt(length(exp.participants)),col{i_depth,event_1},'alpha','transparency',(1-(i_depth)*0.15)) 
        %%% if you can find a way to cycle through custom colors in the
        %%% boundedline function please let me know, so far only preset colours work, which have too much specificity, I have tried adding the arguement "'colour', [x,y,z]".
        %%% 'alpha' and 'transparency' change the opaucitiy of the SE area and
        %%% line, respectively. 
    end
    xlim([-200 1000])
    ylim([-10 25])
    set(gca,'Ydir','reverse');
    line([0 0],[-10 10],'color','k');
    line([-200 1000],[0 0],'color','k');
    title([titled '__Condition_Participant_' num2str(i_part) '_Condition_Depth_All_Depths']);

end

hold off;
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% ERP FOR EACH PARTICIPANT TARGET ONLY %%%%%
col = {'r';'g';'b';'m';'c'};%%%Orb onset, response, offset (depending on loaded dataset - at five depths
%%%%%ERPs for each depth%%%%%
figure;hold on;
for i_part = 1:nparts
    subplot(ceil(sqrt(nparts)),ceil(sqrt(nparts)),i_part);
    for i_depth = length(ndepths)
        if i_depth == 1 || i_depth == 5
            boundedline(EEG.times,erpdata_parts(i_depth,event_1).cond(:,i_part),std(erpdata_parts(i_depth,event_1).cond(:,i_part))./sqrt(length(exp.participants)),col{i_depth,event_1})
        end
        xlim([-200 1000])
        ylim([-10 25])
        set(gca,'Ydir','reverse');
        line([0 0],[-10 10],'color','k');
        line([-200 1000],[0 0],'color','k');
        title([titled '_Condition_Participant_' num2str(i_part) '_Depth__' num2str(i_depth)]);

    end

end

hold off;
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%THE FOLLOWING ARE FOR GRAND AVERAGES%%%%%
col = {'r';'g';'b';'m';'c'};%%%Orb onset, response, offset (depending on loaded dataset - at five depths
%%%%%Grand average ERPs%%%%%
figure;hold on;
for i_depth = 1:ndepths
    subplot(ceil(sqrt(ndepths)),ceil(sqrt(ndepths)),i_depth);
    boundedline(EEG.times,erpdata(i_depth,event_1).cond(1,:),std(erpdata(i_depth,event_1).cond(1,:))./sqrt(length(exp.participants)),col{i_depth,event_1})
    xlim([0 600])
    ylim([-10 20])
    set(gca,'Ydir','reverse');
    line([0 0],[-10 10],'color','k');
    line([-200 1000],[0 0],'color','k');
    title([titled ' __Condition_Grand Average - Depth' num2str(i_depth)])
end
% line_x = [10,30,40,60,80,150,200,350,500,550]
% line y = [-10]
%line([line_x[1] line_x[1]],[line_y abs(line_y[1])],'color','k');

hold off;
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%THE FOLLOWING ARE FOR GRAND AVERAGE DIFFERENCE WAVES%%%%%
col = {'r';'g';'b';'m';'c'};%%%Orb onset, response, offset (depending on loaded dataset - at five depths
%%%%%Grand average ERPs%%%%%
figure;hold on;
for i_depth = 1:ndepths
    subplot(ceil(sqrt(ndepths)),ceil(sqrt(ndepths)),i_depth);
    boundedline(EEG.times,erpdata(target_depth,event_1).cond-erpdata(i_depth,event_1).cond,std((erpdata(target_depth,event_1).cond-erpdata(i_depth,event_1).cond),[],2)./sqrt(length(exp.participants)),col{i_depth,event_1})
    xlim([0 600])
    ylim([-10 20])
    set(gca,'Ydir','reverse');
    line([0 0],[-10 10],'color','k');
    line([-200 1000],[0 0],'color','k');
    title([titled '__Condition_Grand Average Difference Wave: Depth ' num2str(target_depth) ' - Depth' num2str(i_depth)])
end
% xlim([-200 600])
% ylim([-15 15])
% set(gca,'Ydir','reverse');
% %%%%% epoched to last entrainer %%%%%
% line([0 0],[-10 10],'color','k');
% line([-200 1000],[0 0],'color','k');
hold off;
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% POWER TOPOPLOTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% first instance of Depthy - a structure for holding all the topoplot and bar graph data %%% 
    Depths = {'Depth_1' 'Depth_2' 'Depth_3' 'Depth_4' 'Depth_5'};
for i_depth = 1 : length(Depths)
    subplot(ceil(sqrt(ndepths)),ceil(sqrt(ndepths)),i_depth);
     % Assign index to Depthy.Depth_1, Depthy.Depth_2 etc.
    Depthy.Depths{i_depth} = all_chan_erpdata(i_depth,event_1).cond;
    Depthy.Depths_mean{i_depth} = mean(Depthy.Depths{i_depth}(:,time_window),2);
    Depthy.Depths_mean{i_depth}(17:18) = NaN;
end

lims = [-4 4];
for i_depth = 1:ndepths
    figure('Color',[1 1 1]);hold on;
    set(gca,'Color',[1 1 1]);
    topoplot(Depthy.Depths_mean{i_depth},exp.electrode_locs, 'whitebk','on','plotrad',.6,'maplimits',lims)
    %%% conditional naming schema - standard and target change per
    %%% condition - target depth is initialized at the top of the script
    if i_depth == target_depth
        title([titled '_Condition_Target_Topoplot__' exp.event_names{event_1} '__Depth_' num2str(i_depth)]);
    else
        title([titled '_Condition_Standard_Topoplot__' exp.event_names{event_1} '__Depth_' num2str(i_depth) time_1 '-' time_2]);
    end
    t = colorbar('peer',gca);
    set(get(t,'ylabel'),'String', 'Voltage Difference (uV)');
    hold off;
end

%%
%%%%% DIFFERENCE TOPOPLOTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Depths = {'Depth_1' 'Depth_2' 'Depth_3' 'Depth_4' 'Depth_5'};
for i_depth = 1 : length(Depths)
     % Assign index to Depthy_DIff.Depth_1, Depthy_Diff.Depth_2 etc.
    Depthy.Depths_Diff{i_depth} = all_chan_erpdata(target_depth,event_1).cond-all_chan_erpdata(i_depth,event1).cond;
    Depthy.Depths_Diff_mean{i_depth} = mean(Depthy.Depths_Diff{i_depth}(:,time_window),2);
    Depthy.Depths_Diff_mean{i_depth}(17:18) = NaN;
end

lims = [-4 4];
for i_depth = 1:ndepths
    figure('Color',[1 1 1]);hold on;
    set(gca,'Color',[1 1 1]);
    topoplot(Depthy.Depths_Diff_mean{i_depth},exp.electrode_locs, 'whitebk','on','plotrad',.6,'maplimits',lims)
    title([titled '_Condition_Target_Difference_Topoplot__' exp.event_names{event_1} '__Depth_' num2str(target_depth) ' - Depth_' num2str(i_depth) time_1 '-' time_2]);
    t = colorbar('peer',gca);
    set(get(t,'ylabel'),'String', 'Voltage Difference (uV)');
    hold off;
end

%%
%%% BAR GRAPHS - AVERAGE ACTIVITY ACROSS REGIONS %%%

for i_depth = 1 : length(Depths)
    Depthy.Depth_bar_mean(i_depth) = mean(erpdata(i_depth,event_1).cond(time_window));
    Depthy.Depth_bar_se(i_depth) = mean(std(erpdata_parts(i_depth,event_1).cond(time_window,:),[],2)/nparts);
end

figure;hold on;
bar([Depthy.Depth_bar_mean]);
errorbar([Depthy.Depth_bar_mean],[Depthy.Depth_bar_se],'.');
title([titled '__Condition_Bar_Graph_' exp.event_names{event_1} time_1 '-' time_2])
hold off;


%%
%%%%% DIFFERENCE BAR GRAPHS %%%%%

for i_depth = 1 : length(Depths)
    Depthy.Depth_diff_bar_mean(i_depth) = mean(erpdata(i_depth,event_1).cond(1,time_window)-erpdata(i_depth,event1).cond(1,time_window)); % mean of difference
    Depthy.Depth_diff_bar_se(i_depth) = mean(std(erpdata_parts(i_depth,event_1).cond(time_window,:)-erpdata_parts(i_depth,event_1).cond(time_window,:),[],2)/sqrt(nparts)); % std of difference
%     Depthy.Depth_se(i_depth) = mean(std(erpdata_parts(i_depth,event_1).cond(time_window,:),[],2)/sqrt(nparts));   % std of just one
end

figure;hold on;
bar([Depthy.Depth_diff_bar_mean]);
errorbar([Depthy.Depth_diff_bar_mean],[Depthy.Depth_diff_bar_se],'.');
title([titled '__Condition_Bar_Graph_' exp.event_names{event_1} time_1 '-' time_2])
hold off;
