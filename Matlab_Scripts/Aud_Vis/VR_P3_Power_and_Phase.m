%% Plot Figures
if isempty(anal.tfelecs)==1;
    electrodes = {EEG.chanlocs(:).labels}
else
    electrodes = {EEG.chanlocs(anal.tfelecs).labels}
end
% % frequencies = [10];
% % refreshes = [2.5,5,8.5,11,17,23];

% Type "electrodes" into the command line. This will show you which number to use for i_chan
i_chan = [3];%2 for Oz, 4 for Cz (M1 is actually electrode 1)

%% Plot spectrograms of power and phase
% A spectogram is a 3d figure that plots time on the x-axis, frequency on the y-axis, and shows you the power or phase-locking value for each point.
% We compute spectograms if we have power and phase information, averaged across trials, for at least one electrode.
% This can help us understand the changes of power and phase throughout the trial.

% A Topoplot is a graph of the distribution of power or phase-locking magnitude across the scalp, averaging a range of both time and frequency.
% We make a topoplot if we have power or phase-locking information, averaged across the trials, for every electrode.
% This can help us understand the scalp distribution of power or phase-locking at a crucial time and at the frequency of maximal effect.


%ITC SPECTROGRAM
for i_set = 1:nsets
    figure;
    
    %The variable itc will be a 6D variable: (participants x sets x events x electrodes x frequencies x timepoints).
    %You need a 2D variable, frequency x time.
    %By default it will take the mean across participants, events, and channels (given in i_chan) and show the data for each set.
    set_itc = squeeze(mean(mean(mean(abs(itc(:,i_set,:,i_chan,:,:)),1),3),4));
    CLim = ([0,0.4]);
    colormap(whitered);
    %
    %     avg_itc = itc(:,i_set,:,i_chan,[8:12],[1750:1950])
    % avg_itc = squeeze((abs(itc(:,i_set,:,i_chan,:,:))));
    % avg_itc_part = mean(mean(avg_itc,2),3);
    
    %         set_itc = squeeze(mean(mean(mean((abs(itc(:,3,:,i_chan,:,:))-abs(itc(:,i_set,:,i_chan,:,:))),1),3),4));
    %             colormap(redblue);
    %                 CLim = ([-0.2,0.2]);
    %
    %             set_itc = squeeze(mean(mean(mean((abs(itc(:,i_set,:,i_chan,:,:))-abs(itc(:,4,:,i_chan,:,:))),1),3),4));
    %             colormap(redblue);
    %                 CLim = ([-0.2,0.2]);
    
    %             set_itc = squeeze(mean(mean(mean(((abs(itc(:,i_set,:,i_chan,:,:)-mean(mean(itc(:,i_set,:,i_chan,:,:),3),4)))-(abs(itc(:,4,:,i_chan,:,:)-mean(mean(itc(:,4,:,i_chan,:,:),3),4)))),1),3),4));
    
    %             set_itc_20 = squeeze(mean(mean(mean(abs(itc(:,i_set,:,i_chan,[18:22],:))-abs(itc(:,4,:,i_chan,[18:22],:)),1),3),4));
    %             set_itc_10 = squeeze(mean(mean(mean(abs(itc(:,3,:,i_chan,[8:12],:))-abs(itc(:,i_set,:,i_chan,[8:12],:)),1),3),4));
    
    %This variable sets the scale of the color axis, which corresponds to the itc or power values.
    
    %This code creates the spectogram. Arguents are x-axis values (time), y-axis valus (frequency) and color axis values (itc or ersp).
    imagesc(times,freqs,set_itc,CLim); axis([-200 2500 0.75 40]); set(gca,'ydir','normal'); colorbar; %Remove the CLim argument to find the right scale
    %             imagesc(times,freqs,set_itc_20,CLim); axis([-200 2000 18 22]); set(gca,'ydir','normal'); colorbar;
    %Make a Title
    %             title([exp.setname{i_set} ' at electrode ' electrodes])
    title([exp.setname{i_set} ' at electrode ' electrodes{i_chan}])
    
    %You can also put lines on the figure to show the trial start, important events, etc.
    line([-200 1750], [20 20], 'color', 'k');
    line([1000 1750], [22 22], 'color', 'k');
    line([1000 1750], [18 18], 'color', 'k');
    
    line([-200 1750], [10 10], 'color', 'k');
    line([1000 1750], [12 12], 'color', 'k');
    line([1000 1750], [8 8], 'color', 'k');
    xlim([-200 2500]);
    
    cue = line([0,0], [0,40], 'color', 'k'); Cue = 'Cue';
    entr1 = line([1000,1000], [0,40], 'color', 'k'); Entr1 = 'First Entrainer';
    entr16 = line([1750,1750], [0,40], 'color', 'k'); Entr8 = 'Last Entrainer';
    
    line([1950 1950], [0 40], 'color', 'k');
    
    %             tlims = [0 7*refreshes(i_set)*8.33]; time_lims = find(times>=tlims(1),1):find(times>=tlims(2),1)-1;
    %             flims = [frequencies(i_set)-1 frequencies(i_set)+1]; tlims = [0 7*refreshes(i_set)*8.33];
    %             line([tlims(1) tlims(2)],[flims(1) flims(1)], 'color', 'k');
    %             line([tlims(1) tlims(2)], [flims(2) flims(2)],'color', 'k');
end
avg_itc_part = mean(mean(avg_itc,2),3);


%         %ITC TOPOPLOT
%         %%%%%need to use all electrodes%%%%% %%%%% for these, electrode 1
%         and 3 are Oz and Cz %%%%%
for i_set = 1:nsets
    figure;
    
    %A Topoplot needs to collapse across frequency and time so it can show the data across electrodes
    flims = [8 12]; % set the range of frequency to consider
    %             tlims = [1000 1750]; % set the range of time to consider
    tlims = [1750 1950]; % set the range of time to consider Lag Period
    %     tlims = [1400 1750]; % set the range of time to consider Last Ents
    
    freq_lims = find(freqs>= flims(1),1):find(freqs>=flims(2),1)-1; %this code finds the frequencies you want from the freqs variable
    time_lims = find(times>=tlims(1),1):find(times>=tlims(2),1)-1;  %this code finds the times you want from the timess variable
    
    %Here you need a 1D variable, electrodes.
    %By default it will take the mean across participants, events, times and frequencies, and show the data for each set
    %             set_elec_itc = squeeze(mean(mean(mean(mean(abs(itc(:,i_set,:,i_chan,freq_lims,time_lims)),1),3),5),6))'
    
    %     set_elec_itc = squeeze(mean(mean(mean(mean(abs(itc(:,i_set,:,exp.brainelecs,freq_lims,time_lims)),1),3),5),6))'
    %     CLim = ([0,0.4]);
    %     colormap(whitered);
    
    %     set_elec_itc = squeeze(mean(mean(mean(mean((abs(itc(:,3,:,exp.brainelecs,freq_lims,time_lims))-abs(itc(:,i_set,:,exp.brainelecs,freq_lims,time_lims))),1),3),5),6))'
    %     CLim = ([-0.2,0.2]);
    %     colormap(redblue);
    %
    %     set_elec_itc = squeeze(mean(mean(mean(mean((abs(itc(:,i_set,:,exp.brainelecs,freq_lims,time_lims))-abs(itc(:,4,:,exp.brainelecs,freq_lims,time_lims))),1),3),5),6))'
    %     CLim = ([-0.2,0.2]);
    %     colormap(redblue);
    
    
    %%%%%for individual parts%%%%%
    for i_part = 1:length(exp.participants)
        %%%%%condition minus 20hz%%%%%
        %         set_elec_itc = squeeze(mean(mean(mean(mean((abs(itc(i_part,i_set,:,exp.brainelecs,freq_lims,time_lims))-abs(itc(i_part,4,:,exp.brainelecs,freq_lims,time_lims))),1),3),5),6))'
        %%%%%10hz minus condition%%%%%
        %         set_elec_itc = squeeze(mean(mean(mean(mean((abs(itc(i_part,3,:,exp.brainelecs,freq_lims,time_lims))-abs(itc(i_part,i_set,:,exp.brainelecs,freq_lims,time_lims))),1),3),5),6))'
        %%%%%condition only%%%%%
        set_elec_itc = squeeze(mean(mean(mean(mean((abs(itc(i_part,i_set,:,exp.brainelecs,freq_lims,time_lims))),1),3),5),6))'
        part_itc(i_part,i_set) = set_elec_itc(3);
    end
    CLim = ([-0.2,0.2]);
    colormap(redblue);
    
    %This variable sets the scale of the color axis, which corresponds to the itc or power values.
    %             CLim = ([0,0.4]);
    
    %This code creates the topoplots. You need to replace all the non-brain electrodes with NaN.
    topoplot([NaN set_elec_itc NaN NaN],exp.electrode_locs,'maplimits',CLim,'plotrad',0.6,'whitebk','on','colormap',colormap); colorbar;
    
    %Make a Title
    title([exp.setname{i_set} ' at electrode ' electrodes])
    %             title([exp.setname{i_set} ' at electrode ' electrodes{i_chan}])
end

% ERSP SPECTROGRAM
%%%%%need to use all electrodes%%%%%
i_chan = [6];
condition = 2
for i_set = 1:nsets
    for i_event = 1:nevents
        if condition == 1
            %%%%%Tone Onset%%%%%
            figure;
            
            disp(exp.setname{i_set})
            disp(exp.event_names{i_set,i_event})
            
            %The variable ersp will be a 6D variable: (participants x sets x events x electrodes x frequencies x timepoints).
            %You need a 2D variable, frequency x time.
            %By default it will take the mean across participants, events, and channels (given in i_chan) and show the data for each set.
            set_ersp = squeeze(mean(mean(mean(ersp(:,i_set,i_event,i_chan,:,:),1),3),4));
            
            %%%%%Find difference in each condition%%%%%
            % %             set_ersp_nature_low = squeeze(mean(mean(mean(ersp(:,2,1,i_chan,:,:),1),3),4));
            % %             set_ersp_nature_high = squeeze(mean(mean(mean(ersp(:,2,2,i_chan,:,:),1),3),4));
            % %             set_ersp_urban_low = squeeze(mean(mean(mean(ersp(:,3,1,i_chan,:,:),1),3),4));
            % %             set_ersp_urban_high = squeeze(mean(mean(mean(ersp(:,3,2,i_chan,:,:),1),3),4));
            % %             set_ersp_baseline_low = squeeze(mean(mean(mean(ersp(:,1,1,i_chan,:,:),1),3),4));
            % %             set_ersp_baseline_high = squeeze(mean(mean(mean(ersp(:,1,2,i_chan,:,:),1),3),4));
            % %
            % %             set_ersp_nature_baseline = set_ersp_nature_high - set_ersp_baseline_high;
            % %             set_ersp_nature_urban = set_ersp_nature_high - set_ersp_urban_high;
            
            %This variable sets the scale of the color axis, which corresponds to the itc or power values.
            CLim = ([-2 2]); %colormap(b2r(CLim(1),CLim(2)))
            
            %This code creates the spectogram. Arguents are x-axis values (time), y-axis valus (frequency) and color axis values (itc or ersp).
            imagesc(times,freqs,set_ersp,CLim); axis([-1000 3000 0.75 40]); set(gca,'ydir','normal'); colorbar; %Remove the CLim argument to find the right scale
            
            %Make a Title
            title([exp.setname{i_set} ' ' exp.event_names{i_set,i_event} ' at electrode ' electrodes(i_chan)])
            %             title([exp.setname{i_set} ' at electrode ' electrodes{i_chan}])
            
            %You can also put lines on the figure to show the trial start, important events, etc.
            %%%%%Tone Onset%%%%%
            line([-1000 3000], [12 12], 'color', 'k');
            %%%Start of Tone%%%
            line([0,0], [0,40], 'color', 'k');
            %%%Time when tone may end%%%
            line([1000,1000], [0,40], 'color', 'k');
            line([1500,1500], [0,40], 'color', 'k');
            
            %%%create a bar graph of the average power across some time%%%
            time1 = 700;
            time2 = 1000;
            time_points = find(times>time1 & times<time2);
            freq_points = find(freqs>8&freqs<12);
            
            avg_power(i_set,i_event) = mean(mean(set_ersp(freq_points,time_points)));
            
        elseif condition == 2
            %%%%%Picture Onset%%%%%
            figure;
            
            disp(exp.setname{i_set})
            disp(exp.event_names{i_set,i_event})
            
            %The variable ersp will be a 6D variable: (participants x sets x events x electrodes x frequencies x timepoints).
            %You need a 2D variable, frequency x time.
            %By default it will take the mean across participants, events, and channels (given in i_chan) and show the data for each set.
            set_ersp = squeeze(mean(mean(mean(ersp(:,i_set,i_event,i_chan,:,:),1),3),4));
            
            %This variable sets the scale of the color axis, which corresponds to the itc or power values.
            CLim = ([-1 1]); %colormap(b2r(CLim(1),CLim(2)))
            
            %This code creates the spectogram. Arguents are x-axis values (time), y-axis valus (frequency) and color axis values (itc or ersp).
            imagesc(times,freqs,set_ersp,CLim); axis([-1000 3500 0.75 40]); set(gca,'ydir','normal'); colorbar; %Remove the CLim argument to find the right scale
            
            %Make a Title
            title([exp.setname{i_set} ' ' exp.event_names{i_set,i_event} ' at electrode ' electrodes(i_chan)])
            %             title([exp.setname{i_set} ' at electrode ' electrodes{i_chan}])
            
            %You can also put lines on the figure to show the trial start, important events, etc.
            %%%%%Pic Onset%%%%%
            line([-1000 3500], [12 12], 'color', 'k');
            %%%Start of Pic%%%
            line([0,0], [0,40], 'color', 'k');
            %%%Time when tone may end%%%
            line([2000,2000], [0,40], 'color', 'k');
            line([3000,3000], [0,40], 'color', 'k');
            
                        %%%create a bar graph of the average power across some time%%%
            time1 = 1500;
            time2 = 2000;
            time_points = find(times>time1 & times<time2);
            freq_points = find(freqs>8&freqs<12);
            
            avg_power(i_set,i_event) = mean(mean(set_ersp(freq_points,time_points)));
            
        end
    end
end

%%%now actually create the bar graph of average power of specified time%%%
%%%Low Tones/Picture Onset%%%
figure;bar([avg_power(1,1),avg_power(2,1),avg_power(3,1)]);
title(['Average 8-12Hz Activity Over ' num2str(time1) ' - ' num2str(time2) 'ms']);
xlabel(['Baseline','Nature','Urban']);ylabel('Average Power (uV)');
ylim([-0.6,0.4]);

%%%High Tones%%%
figure;bar([avg_power(1,2),avg_power(2,2),avg_power(3,2)]);
title(['Average 8-12Hz Activity Over ' num2str(time1) ' - ' num2str(time2) 'ms']);
xlabel(['Baseline','Nature','Urban']);ylabel('Average Power (uV)');
ylim([-3.5,0.15]);

%%%%%TONE ONSET%%%%%
i_chan = [3];
%%%%%Find difference in each condition%%%%%
set_ersp_nature_low = squeeze(mean(mean(mean(ersp(:,2,1,i_chan,:,:),1),3),4));
set_ersp_nature_high = squeeze(mean(mean(mean(ersp(:,2,2,i_chan,:,:),1),3),4));
set_ersp_urban_low = squeeze(mean(mean(mean(ersp(:,3,1,i_chan,:,:),1),3),4));
set_ersp_urban_high = squeeze(mean(mean(mean(ersp(:,3,2,i_chan,:,:),1),3),4));
set_ersp_baseline_low = squeeze(mean(mean(mean(ersp(:,1,1,i_chan,:,:),1),3),4));
set_ersp_baseline_high = squeeze(mean(mean(mean(ersp(:,1,2,i_chan,:,:),1),3),4));

set_ersp_nature_baseline = squeeze(mean(mean(mean(ersp(:,2,2,i_chan,:,:)-ersp(:,1,2,i_chan,:,:),1),3),4));
set_ersp_nature_urban = squeeze(mean(mean(mean(ersp(:,2,2,i_chan,:,:)-ersp(:,3,2,i_chan,:,:),1),3),4));

% % set_ersp_nature_baseline = set_ersp_nature_high - set_ersp_baseline_high;
% % set_ersp_nature_urban = set_ersp_nature_high - set_ersp_urban_high;

%This variable sets the scale of the color axis, which corresponds to the itc or power values.
% CLim = get(gca,'CLim')

CLim = ([-2 2]); 

%This code creates the spectogram. Arguents are x-axis values (time), y-axis valus (frequency) and color axis values (itc or ersp).
figure;imagesc(times,freqs,set_ersp_nature_baseline,CLim); axis([-1000 3000 0.75 40]); set(gca,'ydir','normal'); colorbar; %Remove the CLim argument to find the right scale

% % colormap(b2r(CLim(1),CLim(2)))%%%run this to change to a blue-red colormap

%Make a Title
title(['Nature Minus Baseline at electrode ' electrodes(i_chan)])
%             title([exp.setname{i_set} ' at electrode ' electrodes{i_chan}])

%You can also put lines on the figure to show the trial start, important events, etc.
%%%%%Tone Onset%%%%%
line([-1000 3000], [12 12], 'color', 'k');
%%%Start of Tone%%%
line([0,0], [0,40], 'color', 'k');
%%%Time when tone may end%%%
line([1000,1000], [0,40], 'color', 'k');
line([1500,1500], [0,40], 'color', 'k');

figure;imagesc(times,freqs,set_ersp_nature_urban,CLim); axis([-1000 3000 0.75 40]); set(gca,'ydir','normal'); colorbar; %Remove the CLim argument to find the right scale
%Make a Title
title(['Nature Minus Urban at electrode ' electrodes(i_chan)])
%             title([exp.setname{i_set} ' at electrode ' electrodes{i_chan}])

%You can also put lines on the figure to show the trial start, important events, etc.
%%%%%Tone Onset%%%%%
line([-1000 3000], [12 12], 'color', 'k');
%%%Start of Tone%%%
line([0,0], [0,40], 'color', 'k');
%%%Time when tone may end%%%
line([1000,1000], [0,40], 'color', 'k');
line([1500,1500], [0,40], 'color', 'k');

%%%create a bar graph of the average power across some time%%%
time1 = 700;
time2 = 1000;
time_points = find(times>time1 & times<time2);
freq_points = find(freqs>8&freqs<12);

%%%Nature Minus Baseline%%%
avg_power(1,1) = mean(mean(set_ersp_nature_baseline(freq_points,time_points)));

%%%Nature Minus Urban%%%
avg_power(1,2) = mean(mean(set_ersp_nature_urban(freq_points,time_points)));

%%%High Tones%%%
figure;bar([avg_power(1,1),avg_power(1,2)]);
title(['Average 8-12Hz Activity Over ' num2str(time1) ' - ' num2str(time2) 'ms']);
xlabel(['Nature Minus Baseline','Nature Minus Urban']);ylabel('Average Power (uV)');
ylim([-0.2,0.8]);

%%%%%PICTURE ONSET%%%%%
i_chan = [6];
%%%%%Find difference in each condition%%%%%
set_ersp_nature_pics = squeeze(mean(mean(mean(ersp(:,2,:,i_chan,:,:),1),3),4));
set_ersp_urban_pics = squeeze(mean(mean(mean(ersp(:,3,:,i_chan,:,:),1),3),4));
set_ersp_baseline_pics = squeeze(mean(mean(mean(ersp(:,1,:,i_chan,:,:),1),3),4));

set_ersp_nature_baseline = squeeze(mean(mean(mean(ersp(:,2,:,i_chan,:,:)-ersp(:,1,:,i_chan,:,:),1),3),4));
set_ersp_nature_urban = squeeze(mean(mean(mean(ersp(:,2,:,i_chan,:,:)-ersp(:,3,:,i_chan,:,:),1),3),4));

% % set_ersp_nature_baseline = set_ersp_nature_pics - set_ersp_baseline_pics;
% % set_ersp_nature_urban = set_ersp_nature_pics - set_ersp_urban_pics;

%This variable sets the scale of the color axis, which corresponds to the itc or power values.
CLim = ([-1 1]); %colormap(b2r(CLim(1),CLim(2)))

%This code creates the spectogram. Arguents are x-axis values (time), y-axis valus (frequency) and color axis values (itc or ersp).
figure;imagesc(times,freqs,set_ersp_nature_baseline,CLim); axis([-1000 3500 0.75 40]); set(gca,'ydir','normal'); colorbar; %Remove the CLim argument to find the right scale

%Make a Title
title(['Nature Minus Baseline at electrode ' electrodes(i_chan)])
%             title([exp.setname{i_set} ' at electrode ' electrodes{i_chan}])

%You can also put lines on the figure to show the trial start, important events, etc.
%%%%%Tone Onset%%%%%
line([-1000 3500], [12 12], 'color', 'k');
%%%Start of Tone%%%
line([0,0], [0,40], 'color', 'k');
figure;imagesc(times,freqs,set_ersp_nature_urban,CLim); axis([-1000 3500 0.75 40]); set(gca,'ydir','normal'); colorbar; %Remove the CLim argument to find the right scale
%%%Time when tone may end%%%
line([2000,2000], [0,40], 'color', 'k');
line([3000,3000], [0,40], 'color', 'k');
%Make a Title
title(['Nature Minus Urban at electrode ' electrodes(i_chan)])
%             title([exp.setname{i_set} ' at electrode ' electrodes{i_chan}])

%You can also put lines on the figure to show the trial start, important events, etc.
%%%%%Tone Onset%%%%%
line([-1000 3500], [12 12], 'color', 'k');
%%%Start of Tone%%%
line([0,0], [0,40], 'color', 'k');
%%%Time when tone may end%%%
line([2000,2000], [0,40], 'color', 'k');
line([3000,3000], [0,40], 'color', 'k');


%%%create a bar graph of the average power across some time%%%
time1 = 1500;
time2 = 2000;
time_points = find(times>time1 & times<time2);
freq_points = find(freqs>8&freqs<12);

%%%Nature Minus Baseline%%%
avg_power(1,1) = mean(mean(set_ersp_nature_baseline(freq_points,time_points)));

%%%Nature Minus Urban%%%
avg_power(1,2) = mean(mean(set_ersp_nature_urban(freq_points,time_points)));

%%%High Tones%%%
figure;bar([avg_power(1,1),avg_power(1,2)]);
title(['Average 8-12Hz Activity Over ' num2str(time1) ' - ' num2str(time2) 'ms']);
xlabel(['Nature Minus Baseline','Nature Minus Urban']);ylabel('Average Power (uV)');
ylim([-1.8,0.2]);


%         % ERSP TOPOPLOT
%%%%%need to use all electrodes%%%%%
for i_set = 1:nsets
    for i_event = 1:nevents
        figure;
        
        %A Topoplot needs to collapse across frequency and time so it can show the data across electrodes
        flims = [8 12]; % set the range of frequency to consider
        tlims = [1500 2000]; % set the range of time to consider
        
        freq_lims = find(freqs>= flims(1),1):find(freqs>=flims(2),1)-1; %this code finds the frequencies you want from the freqs variable
        time_lims = find(times>=tlims(1),1):find(times>=tlims(2),1)-1;  %this code finds the times you want from the timess variable
        
        %Here you need a 1D variable, electrodes.
        %By default it will take the mean across participants, events, times and frequencies, and show the data for each set
        set_elec_ersp = squeeze(mean(mean(mean(mean(ersp(:,i_set,i_event,exp.brainelecs,freq_lims,time_lims),1),3),5),6))'
        
        %This variable sets the scale of the color axis, which corresponds to the itc or power values.
        CLim = ([-2 2]);
        
        %This code creates the topoplots. You need to replace all the non-brain electrodes with NaN.
        topoplot([NaN set_elec_ersp NaN NaN],exp.electrode_locs,'maplimits',CLim,'plotrad',0.6,'whitebk','on','colormap',linspecer); colorbar;
        
        %Make a Title
        title([exp.setname{i_set} ' ' exp.event_names{i_set,i_event}])
        %             title([exp.setname{i_set} ' at electrode ' electrodes{i_chan}])
    end
end

%%%%%TONE ONSET Difference Topographies%%%%%
%A Topoplot needs to collapse across frequency and time so it can show the data across electrodes
flims = [8 12]; % set the range of frequency to consider
tlims = [0 500]; % set the range of time to consider

freq_lims = find(freqs>= flims(1),1):find(freqs>=flims(2),1)-1; %this code finds the frequencies you want from the freqs variable
time_lims = find(times>=tlims(1),1):find(times>=tlims(2),1)-1;  %this code finds the times you want from the timess variable

%Here you need a 1D variable, electrodes.
%By default it will take the mean across participants, events, times and frequencies, and show the data for each set
set_elec_ersp_nature_low = squeeze(mean(mean(mean(mean(ersp(:,2,1,exp.brainelecs,freq_lims,time_lims),1),3),5),6))';
set_elec_ersp_nature_high = squeeze(mean(mean(mean(mean(ersp(:,2,2,exp.brainelecs,freq_lims,time_lims),1),3),5),6))';
set_elec_ersp_urban_low = squeeze(mean(mean(mean(mean(ersp(:,3,1,exp.brainelecs,freq_lims,time_lims),1),3),5),6))';
set_elec_ersp_urban_high = squeeze(mean(mean(mean(mean(ersp(:,3,2,exp.brainelecs,freq_lims,time_lims),1),3),5),6))';
set_elec_ersp_baseline_low = squeeze(mean(mean(mean(mean(ersp(:,1,1,exp.brainelecs,freq_lims,time_lims),1),3),5),6))';
set_elec_ersp_baseline_high = squeeze(mean(mean(mean(mean(ersp(:,1,2,exp.brainelecs,freq_lims,time_lims),1),3),5),6))';


set_elec_ersp_nature_baseline = squeeze(mean(mean(mean(mean(ersp(:,2,2,exp.brainelecs,freq_lims,time_lims)-ersp(:,1,2,exp.brainelecs,freq_lims,time_lims),1),3),5),6))';
set_elec_ersp_nature_urban = squeeze(mean(mean(mean(mean(ersp(:,2,2,exp.brainelecs,freq_lims,time_lims)-ersp(:,3,2,exp.brainelecs,freq_lims,time_lims),1),3),5),6))';

% % % set_elec_ersp_nature_baseline = set_elec_ersp_nature_high - set_elec_ersp_baseline_high
% % % set_elec_ersp_nature_urban = set_elec_ersp_nature_high - set_elec_ersp_urban_high

%This variable sets the scale of the color axis, which corresponds to the itc or power values.
CLim = ([-1 1]);

%This code creates the topoplots. You need to replace all the non-brain electrodes with NaN.
figure;topoplot([NaN set_elec_ersp_nature_baseline NaN NaN],exp.electrode_locs,'maplimits',CLim,'plotrad',0.6,'whitebk','on','colormap',linspecer); colorbar;

%Make a Title
title('Nature Minus Baseline')
%             title([exp.setname{i_set} ' at electrode ' electrodes{i_chan}])

%This code creates the topoplots. You need to replace all the non-brain electrodes with NaN.
figure;topoplot([NaN set_elec_ersp_nature_urban NaN NaN],exp.electrode_locs,'maplimits',CLim,'plotrad',0.6,'whitebk','on','colormap',linspecer); colorbar;

%Make a Title
title('Nature Minus Urban')
%             title([exp.setname{i_set} ' at electrode ' electrodes{i_chan}])

%%%%%PICTURE ONSET Difference Topographies%%%%%
%A Topoplot needs to collapse across frequency and time so it can show the data across electrodes
flims = [8 12]; % set the range of frequency to consider
tlims = [1500 2000]; % set the range of time to consider

freq_lims = find(freqs>= flims(1),1):find(freqs>=flims(2),1)-1; %this code finds the frequencies you want from the freqs variable
time_lims = find(times>=tlims(1),1):find(times>=tlims(2),1)-1;  %this code finds the times you want from the timess variable

%Here you need a 1D variable, electrodes.
%By default it will take the mean across participants, events, times and frequencies, and show the data for each set
set_elec_ersp_nature_pics = squeeze(mean(mean(mean(mean(ersp(:,2,:,exp.brainelecs,freq_lims,time_lims),1),3),5),6))'
set_elec_ersp_urban_pics = squeeze(mean(mean(mean(mean(ersp(:,3,:,exp.brainelecs,freq_lims,time_lims),1),3),5),6))'
set_elec_ersp_baseline_pics = squeeze(mean(mean(mean(mean(ersp(:,1,:,exp.brainelecs,freq_lims,time_lims),1),3),5),6))'

set_elec_ersp_nature_baseline = set_elec_ersp_nature_pics - set_elec_ersp_baseline_pics
set_elec_ersp_nature_urban = set_elec_ersp_nature_pics - set_elec_ersp_urban_pics

%This variable sets the scale of the color axis, which corresponds to the itc or power values.
CLim = ([-2 2]);

%This code creates the topoplots. You need to replace all the non-brain electrodes with NaN.
figure;topoplot([NaN set_elec_ersp_nature_baseline NaN NaN],exp.electrode_locs,'maplimits',CLim,'plotrad',0.6,'whitebk','on','colormap',linspecer); colorbar;

%Make a Title
title('Nature Minus Baseline')
%             title([exp.setname{i_set} ' at electrode ' electrodes{i_chan}])

%This code creates the topoplots. You need to replace all the non-brain electrodes with NaN.
figure;topoplot([NaN set_elec_ersp_nature_urban NaN NaN],exp.electrode_locs,'maplimits',CLim,'plotrad',0.6,'whitebk','on','colormap',linspecer); colorbar;

%Make a Title
title('Nature Minus Urban')
%             title([exp.setname{i_set} ' at electrode ' electrodes{i_chan}])


%% Advanced analyses
% The basic spectograms and topoplots will often need to be tweaked to serve the specific purpose of your experiment.
% Here, I show examples where the data being plotted is normalized to the average of the other sets.

%ITC NORMALIZED SPECTROGRAM
for i_set = 1:nsets
    figure;
    
    %The variable itc will be a 6D variable: (participants x sets x events x electrodes x frequencies x timepoints).
    %You need a 2D variable, frequency x time.
    %By default it will take the mean across participants, events, and channels (given in i_chan) and show the data for each set.
    set_itc = mean(mean(mean(abs(itc(:,i_set,:,i_chan,:,:)),1),3),4);
    
    %Here we are also going to take the difference from the average of the other sets.
    diff = [1:nsets]; diff(i_set) = [];
    diff_itc = mean(mean(mean(mean(abs(itc(:,diff,:,i_chan,:,:)),1),2),3),4);
    
    %This variable sets the scale of the color axis, which corresponds to the itc or power values.
    CLim = ([-0.2 0.2]); colormap(b2r(CLim(1),CLim(2)))
    
    %This code creates the spectogram. Arguents are x-axis values (time), y-axis valus (frequency) and color axis values (itc or ersp).
    imagesc(times,freqs,squeeze(set_itc - diff_itc),CLim); axis([-200 2000 0.75 40]); set(gca,'ydir','normal'); colorbar; %Remove the CLim argument to find the right scale
    
    %Make a Title
    title([exp.setname{i_set} ' at electrode ' electrodes])
    % %             title([exp.setname{i_set} ' at electrode ' electrodes{i_chan}])
    %
    %             %You can also put lines on the figure to show the trial start, important events, etc.
    %             line([-200 2000], [frequencies(i_set) frequencies(i_set)], 'color', 'k');
    %
    %             cue = line([0,0], [0,40], 'color', 'k'); Cue = 'Cue';
    %             entr1 = line([600,600], [0,40], 'color', 'k'); Entr1 = 'First Entrainer';
    %             entr16 = line([1350,1350], [0,40], 'color', 'k'); Entr8 = 'Last Entrainer';
    %
    %             tlims = [0 7*refreshes(i_set)*8.33]; time_lims = find(times>=tlims(1),1):find(times>=tlims(2),1)-1;
    %             flims = [frequencies(i_set)-1 frequencies(i_set)+1]; tlims = [0 7*refreshes(i_set)*8.33];
    % %             line([tlims(1) tlims(2)],[flims(1) flims(1)], 'color', 'k');
    % %             line([tlims(1) tlims(2)], [flims(2) flims(2)],'color', 'k');
    
    line([-200 1700], [20 20], 'color', 'k');
    line([600 1350], [22 22], 'color', 'k');
    line([600 1350], [18 18], 'color', 'k');
    
    line([-200 1700], [10 10], 'color', 'k');
    line([600 1350], [12 12], 'color', 'k');
    line([600 1350], [8 8], 'color', 'k');
    xlim([-200 1700]);
    
    cue = line([0,0], [0,40], 'color', 'k'); Cue = 'Cue';
    entr1 = line([600,600], [0,40], 'color', 'k'); Entr1 = 'First Entrainer';
    entr16 = line([1350,1350], [0,40], 'color', 'k'); Entr8 = 'Last Entrainer';
    
    line([1550 1550], [0 40], 'color', 'k');
    
end

%ITC NORMALIZED TOPOPLOT
%         for i_set = 1:nsets
%             figure;
%
%             %A Topoplot needs to collapse across frequency and time so it can show the data across electrodes
%             flims = [frequencies(i_set)-2 frequencies(i_set)+2]; % set the range of frequency to consider
%             tlims = [0 7*refreshes(i_set)*8.33]; % set the range of time to consider
%
%             freq_lims = find(freqs>= flims(1),1):find(freqs>=flims(2),1)-1; %this code finds the frequencies you want from the freqs variable
%             time_lims = find(times>=tlims(1),1):find(times>=tlims(2),1)-1;  %this code finds the times you want from the timess variable
%
%             %Here you need a 1D variable, electrodes.
%             %By default it will take the mean across participants, events, times and frequencies, and show the data for each set
%             set_elec_itc = squeeze( mean(mean( mean(abs(itc(:,i_set,:,:,freq_lims,time_lims)),1),5),6) )';
%
%             %Here we are also going to take the difference from the average of the other sets.
%             diff = [1:nsets]; diff(i_set) = [];
%             diff_set_elec_itc = squeeze( mean(mean(mean(mean(mean(abs(itc(:,diff,:,:,freq_lims,time_lims)),1),2),3),5),6) )';
%
%             %This variable sets the scale of the color axis, which corresponds to the itc or power values.
%             CLim = ([0 0.2]);
%
%             %This code creates the topoplots. You need to replace all the non-brain electrodes with NaN.
%             topoplot([NaN squeeze(set_elec_itc(2:32)-diff_set_elec_itc(2:32)) NaN NaN],exp.electrode_locs,'maplimits',CLim,'plotrad',0.6,'whitebk','on','colormap',linspecer); colorbar;
%
%             %Make a Title
%             title([exp.setname{i_set} ' at electrode ' electrodes])
% %             title([exp.setname{i_set} ' at electrode ' electrodes{i_chan}])
%         end

%ERSP NORMALIZED SPECTROGRAM
for i_set = 1:nsets
    figure;
    
    %The variable ersp will be a 6D variable: (participants x sets x events x electrodes x frequencies x timepoints).
    %You need a 2D variable, frequency x time.
    %By default it will take the mean across participants, events, and channels (given in i_chan) and show the data for each set.
    set_ersp = squeeze(mean(mean(mean(ersp(:,i_set,:,i_chan,:,:),1),3),4));
    
    %Here we are also going to take the difference from the average of the other sets.
    diffs = [1:nsets]; diffs(i_set) = [];
    diff_ersp =  squeeze(mean(mean(mean(mean(ersp(:,diffs,:,i_chan,:,:),1),2),3),4));
    
    %This variable sets the scale of the color axis, which corresponds to the itc or power values.
    CLim = ([-1 1]); colormap(b2r(CLim(1),CLim(2)))
    
    %This code creates the spectogram. Arguents are x-axis values (time), y-axis valus (frequency) and color axis values (itc or ersp).
    imagesc(times,freqs,squeeze(set_ersp-diff_ersp),CLim); axis([-200 2000 0.75 40]); set(gca,'ydir','normal'); colorbar; %Remove the CLim argument to find the right scale
    
    %Make a Title
    title([exp.setname{i_set} ' at electrode ' electrodes])
    %             title([exp.setname{i_set} ' at electrode ' electrodes{i_chan}])
    
    %             %You can also put lines on the figure to show the trial start, important events, etc.
    %             line([-200 2000], [frequencies(i_set) frequencies(i_set)], 'color', 'k');
    %
    %             cue = line([0,0], [0,40], 'color', 'k'); Cue = 'Cue';
    %             entr1 = line([600,600], [0,40], 'color', 'k'); Entr1 = 'First Entrainer';
    %             entr16 = line([1350,1350], [0,40], 'color', 'k'); Entr8 = 'Last Entrainer';
    %
    %             tlims = [0 7*refreshes(i_set)*8.33]; time_lims = find(times>=tlims(1),1):find(times>=tlims(2),1)-1;
    %             flims = [frequencies(i_set)-1 frequencies(i_set)+1]; tlims = [0 7*refreshes(i_set)*8.33];
    % %             line([tlims(1) tlims(2)],[flims(1) flims(1)], 'color', 'k');
    % %             line([tlims(1) tlims(2)], [flims(2) flims(2)],'color', 'k');
    
    line([-200 1700], [20 20], 'color', 'k');
    line([600 1350], [22 22], 'color', 'k');
    line([600 1350], [18 18], 'color', 'k');
    
    line([-200 1700], [10 10], 'color', 'k');
    line([600 1350], [12 12], 'color', 'k');
    line([600 1350], [8 8], 'color', 'k');
    xlim([-200 1700]);
    
    cue = line([0,0], [0,40], 'color', 'k'); Cue = 'Cue';
    entr1 = line([600,600], [0,40], 'color', 'k'); Entr1 = 'First Entrainer';
    entr16 = line([1350,1350], [0,40], 'color', 'k'); Entr8 = 'Last Entrainer';
    
    line([1550 1550], [0 40], 'color', 'k');
    
end

%         %ERSP NORMALIZED TOPOPPLOT
%         for i_set = 1:nsets
%             figure;
%
%             %A Topoplot needs to collapse across frequency and time so it can show the data across electrodes
%             flims = [frequencies(i_set)-2 frequencies(i_set)+2]; % set the range of frequency to consider
%             tlims = [0 7*refreshes(i_set)*8.33]; % set the range of time to consider
%
%             freq_lims = find(freqs>= flims(1),1):find(freqs>=flims(2),1)-1; %this code finds the frequencies you want from the freqs variable
%             time_lims = find(times>=tlims(1),1):find(times>=tlims(2),1)-1;  %this code finds the times you want from the timess variable
%
%             %Here you need a 1D variable, electrodes.
%             %By default it will take the mean across participants, events, times and frequencies, and show the data for each set
%             set_elec_ersp = squeeze(mean(mean(mean(mean(ersp(:,i_set,:,exp.brainelecs,freq_lims,time_lims),1),3),5),6))'
%
%             %Here we are also going to take the difference from the average of the other sets.
%             diffs = [1:nsets]; diffs(i_set) = [];
%             diff_set_elec_ersp = squeeze(mean(mean(mean(mean(mean(abs(ersp(:,diffs,:,:,freq_lims,time_lims)),1),2),3),5),6))';
%
%             %This variable sets the scale of the color axis, which corresponds to the itc or power values.
%             CLim = ([-0.3 0.3]);
%
%             %This code creates the topoplots. You need to replace all the non-brain electrodes with NaN.
%             topoplot([NaN squeeze(set_elec_ersp - diff_set_elec_ersp) NaN NaN],exp.electrode_locs,'maplimits',CLim,'plotrad',0.6,'whitebk','on','colormap',linspecer); colorbar;
%
%             %Make a Title
%             title([exp.setname{i_set} ' at electrode ' electrodes{i_chan}])
%         end






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %% Spectograms, topoplots, bargraphs
% %
% % if isempty(anal.tfelecs)==1;
% %     electrodes = {EEG.chanlocs(:).labels}
% % else
% %     electrodes = {EEG.chanlocs(anal.tfelecs).labels}
% % end
% % frequencies = [20,15,12,8.5,4];
% % refreshes = [6, 8, 10, 14, 30];
% %
% % % Type "electrodes" into the command line. This will show you which number to use for i_chan
% % i_chan = [4];
% %
% % %ITC SPECTROGRAM
% %
% % for i_set = 1:nsets
% %     figure;
% %
% %     %The variable itc will be a 6D variable: (participants x sets x events x electrodes x frequencies x timepoints).
% %     %You need a 2D variable, frequency x time.
% %     %By default it will take the mean across participants, events, and channels (given in i_chan) and show the data for each set.
% %     set_itc = squeeze(mean(mean(mean(abs(itc(:,i_set,:,i_chan,:,:)),1),3),4));
% %
% %     %This variable sets the scale of the color axis, which corresponds to the itc or power values.
% %      CLim = ([0,0.35]); colormap(paruly)
% %
% %     %This code creates the spectogram. Arguents are x-axis values (time), y-axis valus (frequency) and color axis values (itc or ersp).
% %     imagesc(times,freqs,set_itc,CLim); axis([-800 2000 1 40]); set(gca,'ydir','normal'); %Remove the CLim argument to find the right scale
% %
% %     %Make a Title
% %     title([exp.setname{i_set} ' at electrode ' electrodes{i_chan}])
% %     %You can also put lines on the figure to show the trial start, important events, etc.
% %     line([-800 2000], [frequencies(i_set) frequencies(i_set)], 'color', 'k');
% %     entr1 = line([0,0], [0,40], 'color', 'k'); Entr1 = 'First Entrainer';
% %     entr8 = line([7*refreshes(i_set)*8.33,7*refreshes(i_set)*8.33], [0,40], 'color', 'k'); Entr8 = 'Last Entrainer';
% %     tlims = [0 7*refreshes(i_set)*8.33]; time_lims = find(times>=tlims(1),1):find(times>=tlims(2),1)-1;
% %     flims = [frequencies(i_set)-1 frequencies(i_set)+1]; tlims = [0 7*refreshes(i_set)*8.33];
% %     line([tlims(1) tlims(2)],[flims(1) flims(1)], 'color', 'k');
% %     line([tlims(1) tlims(2)], [flims(2) flims(2)],'color', 'k');
% % end
% % colorbar;
% %
% %
% %
% % %ITC TOPOPLOT
% % for i_set = 1:nsets
% %     figure;
% %
% %     %A Topoplot needs to collapse across frequency and time so it can show the data across electrodes
% %     flims = [frequencies(i_set)-2 frequencies(i_set)+2]; % set the range of frequency to consider
% %     tlims = [0 7*refreshes(i_set)*8.33]; % set the range of time to consider
% %
% %     freq_lims = find(freqs>= flims(1),1):find(freqs>=flims(2),1)-1; %this code finds the frequencies you want from the freqs variable
% %     time_lims = find(times>=tlims(1),1):find(times>=tlims(2),1)-1;  %this code finds the times you want from the timess variable
% %
% %     %Here you need a 1D variable, electrodes.
% %     %By default it will take the mean across participants, events, times and frequencies, and show the data for each set
% %     set_elec_itc = squeeze(mean(mean(mean(mean(abs(itc(:,i_set,:,exp.brainelecs,freq_lims,time_lims)),1),3),5),6))'
% %
% %     %This variable sets the scale of the color axis, which corresponds to the itc or power values.
% %     CLim = ([0,0.25]);
% %
% %     %This code creates the topoplots. You need to replace all the non-brain electrodes with NaN.
% %     topoplot([NaN set_elec_itc NaN NaN],exp.electrode_locs,'maplimits',CLim,'plotrad',0.6,'whitebk','on','colormap',paruly); colorbar;
% %
% %     %Make a Title
% %     title([exp.setname{i_set} ' at electrode ' electrodes{i_chan}])
% % end
% %
% % % ERSP SPECTROGRAM
% % for i_set = 1:nsets
% %     figure;
% %
% %     %The variable ersp will be a 6D variable: (participants x sets x events x electrodes x frequencies x timepoints).
% %     %You need a 2D variable, frequency x time.
% %     %By default it will take the mean across participants, events, and channels (given in i_chan) and show the data for each set.
% %     set_ersp = squeeze(mean(mean(mean(ersp(:,i_set,:,i_chan,:,:),1),3),4));
% %
% %     %This variable sets the scale of the color axis, which corresponds to the itc or power values.
% %     CLim = ([-4 1]); colormap(paruly)
% %
% %     %This code creates the spectogram. Arguents are x-axis values (time), y-axis valus (frequency) and color axis values (itc or ersp).
% %     imagesc(times,freqs,set_ersp,CLim); axis([-200 2000 0.75 40]); set(gca,'ydir','normal'); colorbar; %Remove the CLim argument to find the right scale
% %
% %     %Make a Title
% %     title([exp.setname{i_set} ' at electrode ' electrodes{i_chan}])
% %
% %     %You can also put lines on the figure to show the trial start, important events, etc.
% %     line([-800 2200], [12 12], 'color', 'k');
% %     entr1 = line([0,0], [0,40], 'color', 'k'); Entr1 = 'First Entrainer';
% %     entr8 = line([7*refreshes(i_set)*8.33,7*refreshes(i_set)*8.33], [0,40], 'color', 'k'); Entr8 = 'Last Entrainer';
% %     tlims = [0 7*refreshes(i_set)*8.33]; time_lims = find(times>=tlims(1),1):find(times>=tlims(2),1)-1;
% %     flims = [frequencies(i_set)-1 frequencies(i_set)+1]; tlims = [0 7*refreshes(i_set)*8.33];
% %     line([tlims(1) tlims(2)],[flims(1) flims(1)], 'color', 'k');
% %     line([tlims(1) tlims(2)], [flims(2) flims(2)],'color', 'k');
% % end
% %
% % % ERSP TOPOPLOT
% % for i_set = 1:nsets
% %     figure;
% %
% %     %A Topoplot needs to collapse across frequency and time so it can show the data across electrodes
% %     flims = [frequencies(i_set)-2 frequencies(i_set)+2]; % set the range of frequency to consider
% %     tlims = [0 7*refreshes(i_set)*8.33]; % set the range of time to consider
% %
% %     freq_lims = find(freqs>= flims(1),1):find(freqs>=flims(2),1)-1; %this code finds the frequencies you want from the freqs variable
% %     time_lims = find(times>=tlims(1),1):find(times>=tlims(2),1)-1;  %this code finds the times you want from the timess variable
% %
% %     %Here you need a 1D variable, electrodes.
% %     %By default it will take the mean across participants, events, times and frequencies, and show the data for each set
% %     set_elec_ersp = squeeze(mean(mean(mean(mean(ersp(:,i_set,:,exp.brainelecs,freq_lims,time_lims),1),3),5),6))'
% %
% %     %This variable sets the scale of the color axis, which corresponds to the itc or power values.
% %     CLim = ([-2 1]);
% %
% %     %This code creates the topoplots. You need to replace all the non-brain electrodes with NaN.
% %     topoplot([NaN set_elec_ersp NaN NaN],exp.electrode_locs,'maplimits',CLim,'plotrad',0.6,'whitebk','on','colormap',paruly); colorbar;
% %
% %     %Make a Title
% %     title([exp.setname{i_set} ' at electrode ' electrodes{i_chan}])
% % end
% %
% % %% Advanced analyses
% % % The basic spectograms and topoplots will often need to be tweaked to serve the specific purpose of your experiment.
% % % Here, I show examples where the data being plotted is normalized to the average of the other sets.
% %
% % %ITC NORMALIZED SPECTROGRAM
% % for i_set = 1:nsets
% %     figure;
% %
% %     %The variable itc will be a 6D variable: (participants x sets x events x electrodes x frequencies x timepoints).
% %     %You need a 2D variable, frequency x time.
% %     %By default it will take the mean across participants, events, and channels (given in i_chan) and show the data for each set.
% %     set_itc = squeeze(mean(mean(abs(itc(:,i_set,:,i_chan,:,:)),3),4));
% %
% %     %Here we are also going to take the difference from the average of the other sets.
% %     diff = [1:nsets]; diff(i_set) = [];
% %     diff_itc = squeeze(mean(mean(mean(abs(itc(:,diff,:,i_chan,:,:)),2),3),4));
% %
% %     %This variable sets the scale of the color axis, which corresponds to the itc or power values.
% %     CLim = ([-0.2 0.2]); colormap(b2r(CLim(1),CLim(2)))
% %
% %     %This code creates the spectogram. Arguents are x-axis values (time), y-axis valus (frequency) and color axis values (itc or ersp).
% %     imagesc(times,freqs,squeeze(mean(set_itc - diff_itc,1)),CLim); axis([-800 2000 0.75 40]); set(gca,'ydir','normal');  %Remove the CLim argument to find the right scale
% %
% %     %Make a Title
% %     h1 = title([exp.setname{i_set} ' at electrode ' electrodes{i_chan}]); set(gca,'fontsize',20); set(h1,'fontsize',20)
% %
% %     %You can also put lines on the figure to show the trial start, important events, etc.
% %     line([-800 2000], [frequencies(i_set) frequencies(i_set)], 'color', 'k');
% %     entr1 = line([0,0], [0,40], 'color', 'k'); Entr1 = 'First Entrainer';
% %     entr8 = line([7*refreshes(i_set)*8.33,7*refreshes(i_set)*8.33], [0,40], 'color', 'k'); Entr8 = 'Last Entrainer';
% %     tlims = [0 7*refreshes(i_set)*8.33]; time_lims = find(times>=tlims(1),1):find(times>=tlims(2),1)-1;
% %     flims = [frequencies(i_set)-1 frequencies(i_set)+1]; freq_lims = find(freqs>=flims(1),1):find(freqs>=flims(2),1)-1;
% %     line([tlims(1) tlims(2)],[flims(1) flims(1)], 'color', 'k');
% %     line([tlims(1) tlims(2)], [flims(2) flims(2)],'color', 'k');
% %
% %     %This is also a good time to save a variable with the power in the defined range for each subject, which can make a bargraph
% %     sub_itc(i_set,:) = mean(mean(set_itc(:,freq_lims,time_lims),2),3);
% %     sub_diff_itc(i_set,:) = mean(mean(diff_itc(:,freq_lims,time_lims),2),3);
% %
% %     figure; barweb([mean(sub_itc(i_set,:),2) mean(sub_diff_itc(i_set,:),2)],[std(sub_itc(i_set,:),[],2)/sqrt(nparts) std(sub_diff_itc(i_set,:),[],2)/sqrt(nparts)])
% %     h1 = legend(exp.setname{i_set},'Baseline'); legend BOXOFF; ylim([0 0.5]); set(gca,'fontsize',20); set(h1,'fontsize',20)
% % end
% % figure;
% % CLim = ([-0.2 0.2]); colormap(b2r(CLim(1),CLim(2)))
% % colorbar;
% %
% % %ITC NORMALIZED TOPOPLOT
% % for i_set = 1:nsets
% %     figure;
% %
% %     %A Topoplot needs to collapse across frequency and time so it can show the data across electrodes
% %     flims = [frequencies(i_set)-2 frequencies(i_set)+2]; % set the range of frequency to consider
% %     tlims = [0 7*refreshes(i_set)*8.33]; % set the range of time to consider
% %
% %     freq_lims = find(freqs>= flims(1),1):find(freqs>=flims(2),1)-1; %this code finds the frequencies you want from the freqs variable
% %     time_lims = find(times>=tlims(1),1):find(times>=tlims(2),1)-1;  %this code finds the times you want from the timess variable
% %
% %     %Here you need a 1D variable, electrodes.
% %     %By default it will take the mean across participants, events, times and frequencies, and show the data for each set
% %     set_elec_itc = squeeze( mean(mean( mean(abs(itc(:,i_set,:,:,freq_lims,time_lims)),1),5),6) )';
% %
% %     %Here we are also going to take the difference from the average of the other sets.
% %     diff = [1:nsets]; diff(i_set) = [];
% %     diff_set_elec_itc = squeeze( mean(mean(mean(mean(mean(abs(itc(:,diff,:,:,freq_lims,time_lims)),1),2),3),5),6) )';
% %
% %     %This variable sets the scale of the color axis, which corresponds to the itc or power values.
% %     CLim = ([-0.1 0.1]); colorbar; set(gca,'fontsize',20)
% %
% %     %This code creates the topoplots. You need to replace all the non-brain electrodes with NaN.
% %     topoplot([NaN squeeze(set_elec_itc(2:32)-diff_set_elec_itc(2:32)) NaN NaN],exp.electrode_locs,'maplimits',CLim,'plotrad',0.6,'whitebk','on','colormap',b2r(CLim(1),CLim(2)));
% %
% %     %Make a Title
% %     h1 = title([exp.setname{i_set} ' - Baseline']); set(h1,'fontsize',30)
% % end
% %
% % %ERSP NORMALIZED SPECTROGRAM
% % for i_set = 1:nsets
% %      figure;
% %
% %     %The variable ersp will be a 6D variable: (participants x sets x events x electrodes x frequencies x timepoints).
% %     %You need a 2D variable, frequency x time.
% %     %By default it will take the mean across participants, events, and channels (given in i_chan) and show the data for each set.
% %     set_ersp = squeeze(mean(mean(ersp(:,i_set,:,i_chan,:,:),3),4));
% %
% %     %Here we are also going to take the difference from the average of the other sets.
% %     diffs = [1:nsets]; diffs(i_set) = [];
% %     diff_ersp =  squeeze(mean(mean(mean(ersp(:,diffs,:,i_chan,:,:),2),3),4));
% %
% %     %This variable sets the scale of the color axis, which corresponds to the itc or power values.
% %     CLim = ([-1 1]); colormap(b2r(CLim(1),CLim(2)))
% %
% %     %This code creates the spectogram. Arguents are x-axis values (time), y-axis valus (frequency) and color axis values (itc or ersp).
% %      imagesc(times,freqs,squeeze(mean(set_ersp-diff_ersp,1)),CLim); axis([-800 2000 0.75 40]); set(gca,'ydir','normal'); %Remove the CLim argument to find the right scale
% %
% %     %Make a Title
% %     h1 = title([exp.setname{i_set} ' at electrode ' electrodes{i_chan}]); set(gca,'fontsize',20); set(h1,'fontsize',20)
% %
% %     %You can also put lines on the figure to show the trial start, important events, etc.
% %     line([-800 2000], [frequencies(i_set) frequencies(i_set)], 'color', 'k');
% %     entr1 = line([0,0], [0,40], 'color', 'k'); Entr1 = 'First Entrainer';
% %     entr8 = line([7*refreshes(i_set)*8.33,7*refreshes(i_set)*8.33], [0,40], 'color', 'k'); Entr8 = 'Last Entrainer';
% %     tlims = [0 7*refreshes(i_set)*8.33]; time_lims = find(times>=tlims(1),1):find(times>=tlims(2),1)-1;
% %     flims = [frequencies(i_set)-1 frequencies(i_set)+1]; freq_lims = find(freqs>=flims(1),1):find(freqs>=flims(2),1)-1;
% %     line([tlims(1) tlims(2)],[flims(1) flims(1)], 'color', 'k');
% %     line([tlims(1) tlims(2)], [flims(2) flims(2)],'color', 'k');
% %
% %     %This is also a good time to save a variable with the power in the defined range for each subject, which can make a bargraph
% %     sub_ersp(i_set,:) = mean(mean(set_ersp(:,freq_lims,time_lims),2),3);
% %     sub_diff_ersp(i_set,:) = mean(mean(diff_ersp(:,freq_lims,time_lims),2),3);
% %
% %     figure; barweb([mean(sub_ersp(i_set,:),2) mean(sub_diff_ersp(i_set,:),2)],[std(sub_ersp(i_set,:),[],2)/sqrt(nparts) std(sub_diff_ersp(i_set,:),[],2)/sqrt(nparts)])
% %     ylim([-4 2])
% %     h1 = legend(exp.setname{i_set},'Baseline'); legend BOXOFF; ylim([-2 1]); set(gca,'fontsize',20); set(h1,'fontsize',20)
% % end
% % figure;
% % CLim = ([-1 1]); colormap(b2r(CLim(1),CLim(2)))
% % colorbar;
% %
% % %ERSP NORMALIZED TOPOPPLOT
% % for i_set = 1:nsets
% %     figure;
% %
% %     %A Topoplot needs to collapse across frequency and time so it can show the data across electrodes
% %     flims = [frequencies(i_set)-1 frequencies(i_set)+1]; % set the range of frequency to consider
% %     tlims = [0 7*refreshes(i_set)*8.33]; % set the range of time to consider
% %
% %     freq_lims = find(freqs>= flims(1),1):find(freqs>=flims(2),1)-1; %this code finds the frequencies you want from the freqs variable
% %     time_lims = find(times>=tlims(1),1):find(times>=tlims(2),1)-1;  %this code finds the times you want from the timess variable
% %
% %     %Here you need a 1D variable, electrodes.
% %     %By default it will take the mean across participants, events, times and frequencies, and show the data for each set
% %     set_elec_ersp = squeeze(mean(mean(mean(mean(ersp(:,i_set,:,exp.brainelecs,freq_lims,time_lims),1),3),5),6))'
% %
% %     %Here we are also going to take the difference from the average of the other sets.
% %     diffs = [1:nsets]; diffs(i_set) = [];
% %     diff_set_elec_ersp = squeeze(mean(mean(mean(mean(mean(ersp(:,diffs,:,exp.brainelecs,freq_lims,time_lims),1),2),3),5),6))';
% %
% %     %This variable sets the scale of the color axis, which corresponds to the itc or power values.
% %     CLim = ([-.5 .5]); colorbar; set(gca,'fontsize',20)
% %
% %     %This code creates the topoplots. You need to replace all the non-brain electrodes with NaN.
% %     topoplot([NaN squeeze(set_elec_ersp - diff_set_elec_ersp) NaN NaN],exp.electrode_locs,'maplimits',CLim,'plotrad',0.6,'whitebk','on','colormap',colormap(b2r(CLim(1),CLim(2)))); colorbar;
% %
% %     %Make a Title
% %     h1 = title([exp.setname{i_set} ' - Baseline']); set(h1,'fontsize',30)
% % end
% %
