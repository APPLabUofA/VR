
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Calculate RMS%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pick_trials = 180; %360pick per resample
perms = 10000;

rms_out = zeros(nparts,nsets,perms);
rms_erp_out = zeros(nparts,nsets,perms);

for i_set = 1:nsets
    data_out = [];
    exp.setname{i_set}
    for eegset = 1 %%Only want to grab information from the low tone trials
        exp.event_names{1,eegset}
        for i_part = 1:nparts
            
            ALLEEG((i_set-1)*nevents*nparts + (eegset-1)*(nparts) + i_part).filename
            
            n_trials = ALLEEG((i_set-1)*nevents*nparts + (eegset-1)*(nparts) + i_part).trials;
            for i_perm = 1:perms
                these_trials = randperm(n_trials,pick_trials);
                %%%ALLEEG.data is organised by electrodes x timepoints x
                %%%trials
                
                %%%This grabs all the voltages for time points greater than
                %%%-200 and less than 0 (baseline and tone onset). This will results in 180 random trials
                %%%for each of the 15 electrodes (15 x 1200 x 180)
                %%%It will then calculate the RMS along the 2nd dimension,
                %%%corresponding to each time point. Resulting in a single
                %%%RMS value for each electrode and trial.
                %%%It will then squeeze and remove the singleton value
                %%%(time point).
                %%%It will then take the mean across trials, and then
                %%%across electrodes for each permutation
                %%%this will indicate the average baseline rms for each
                %%%trial
                rms_out(i_part,i_set,i_perm) = mean(mean(squeeze(rms(ALLEEG((i_set-1)*nevents*nparts + (eegset-1)*(nparts) + i_part).data(1:15, [ALLEEG((i_set-1)*nevents*nparts + (eegset-1)*(nparts) + i_part).times<0 & ALLEEG((i_set-1)*nevents*nparts + (eegset-1)*(nparts) + i_part).times>=-200],these_trials),2)),2));
                
                %%%This will do similar functions to the above, except that
                %%%it will first take the mean across trials (180), and
                %%%then calculate the RMS for each time point, then average
                %%%by electrodes
                %%%this would measure the rms of the ERP (during baseline)
                %%%since we are first averaging across all trials
                rms_erp_out(i_part,i_set,i_perm) = mean(rms(mean(ALLEEG((i_set-1)*nevents*nparts + (eegset-1)*(nparts) + i_part).data(1:15, [ALLEEG((i_set-1)*nevents*nparts + (eegset-1)*(nparts) + i_part).times<0 & ALLEEG((i_set-1)*nevents*nparts + (eegset-1)*(nparts) + i_part).times>=-200],these_trials),3),2));
                
                
            end
        end
        
    end
end

figure;

%%%this will calculate the average rms across parts for each cond and perm
rms_perm_mean = squeeze(mean(rms_out,1));
sd_rms = squeeze(std(rms_out,[],1));

%%%histogram of the first cond
hist(rms_perm_mean(1,:),15);

%%%histogram of the second cond
hold on; hist(rms_perm_mean(2,:),15);
g=findobj(gca,'Type','patch');
set(g(1),'FaceColor',[1 0 0],'EdgeColor','k');
set(g(2),'FaceColor',[0 0 1],'EdgeColor','k');

figure; barweb(mean(rms_perm_mean,2),std(rms_perm_mean,[],2), [], nevents, [], [], [], jet, [], [], 2, []);
ylim([6,7]);


figure;
rms_erp_perm_mean = squeeze(mean(rms_erp_out,1));
sd_erp = squeeze(std(rms_erp_out,[],1));
hist(rms_erp_perm_mean(1,:),50);
hold on; hist(rms_erp_perm_mean(2,:),50);
g=findobj(gca,'Type','patch');
set(g(1),'FaceColor',[1 0 0],'EdgeColor','k');
set(g(2),'FaceColor',[0 0 1],'EdgeColor','k');

figure; barweb(mean(rms_erp_perm_mean,2),std(rms_erp_perm_mean,[],2), [], nevents, [], [], [], jet, [], [], 2,[]);
legend(nevents);ylim([0.40,0.60]);

%mean and stats of rms
mean(rms_erp_perm_mean,2)
mean(rms_perm_mean,2)
mean(sd_rms,2)
mean(sd_erp,2)

[p,h,stats] = ranksum(rms_erp_perm_mean(1,:),rms_erp_perm_mean(2,:))
[p,h,stats] = ranksum(rms_perm_mean(1,:),rms_perm_mean(2,:))

[h,p,ci,stats] = ttest(rms_erp_perm_mean(1,:),rms_erp_perm_mean(2,:),0.05,'both')
[h,p,ci,stats] = ttest(rms_perm_mean(1,:),rms_perm_mean(2,:),0.05,'both')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Calculate Trial Count%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pick_trials_stand = [ 5 10:10:180 ]; %360pick per resample 400 350 300 250 200 150 100 75 50 40 30 20 10 5
pick_trials_targ = pick_trials_stand/5;
pick_trials_stand = pick_trials_stand-pick_trials_targ;


electrode = 7;% 7 = pz; 9 = fz
perms = 10000;
window = [300 550]; %%%

for i_part = 1:nparts
    for i_set = 1:nsets
        exp.setname{i_set}
        for eegset = 1:nevents
            exp.event_names{1,eegset}
            ALLEEG((i_set-1)*nevents*nparts + (eegset-1)*(nparts) + i_part).filename
            if i_part == 1 && i_set == 1 && eegset == 1
                time_window = find(ALLEEG((i_set-1)*nevents*nparts + (eegset-1)*(nparts) + i_part).times>=window(1),1):find(ALLEEG((i_set-1)*nevents*nparts + (eegset-1)*(nparts) + i_part).times>=window(2),1)-1; %data points of time window
                erp_out = zeros(length(time_window),2,nparts,nsets,perms,length(pick_trials_stand),'single');
                
            end
            if eegset == 1
                n_stand_trials = ALLEEG((i_set-1)*nevents*nparts + (eegset-1)*(nparts) + i_part).trials;
                for i_perm = 1:perms
                    for i_pick = 1:length(pick_trials_stand)
                        
                        stand_trials = randperm(n_stand_trials,pick_trials_stand(i_pick));            %without replacement (permutation)
                        %                 stand_trials = randi(n_stand_trials,pick_trials_stand(i_pick));  %with relacement (bootstrap)
                        erp_out(:,1,i_part,i_set,i_perm,i_pick) = mean(ALLEEG((i_set-1)*nevents*nparts + (eegset-1)*(nparts) + i_part).data(electrode,time_window,stand_trials),3);
                    end
                end
            elseif eegset == 2
                n_targ_trials = ALLEEG((i_set-1)*nevents*nparts + (eegset-1)*(nparts) + i_part).trials;
                for i_perm = 1:perms
                    for i_pick = 1:length(pick_trials_stand)
                        
                        targ_trials = randperm(n_targ_trials,pick_trials_targ(i_pick));
                        %                   targ_trials = randi(n_targ_trials,pick_trials_targ(i_pick),1)';
                        
                        erp_out(:,2,i_part,i_set,i_perm,i_pick) = mean(ALLEEG((i_set-1)*nevents*nparts + (eegset-1)*(nparts) + i_part).data(electrode,time_window,targ_trials),3);
                    end
                    
                end
            end
            
        end
        
    end
end


H =[];
P = [];
mean_erp = squeeze(mean(erp_out,1));
mean_erp_diff = squeeze(mean_erp(2,:,:,:,:) - mean_erp(1,:,:,:,:));
for i_pick = 1:length(pick_trials_stand)
    for i_perm = 1:perms
        [H(1:2,i_pick,i_perm),P(1:2,i_pick,i_perm)] = ttest(squeeze(mean_erp_diff(:,1:2,i_perm,i_pick)),0,.05,'right',1);%%%for P3
        % %                 [H(1:2,i_pick,i_perm),P(1:2,i_pick,i_perm)] = ttest(squeeze(mean_erp_diff(:,1:2,i_perm,i_pick)),0,.05,'left',1);%%%for MMN
    end
end
prop_sig = sum(H,3)/perms;

%%
figure; plot(pick_trials_targ(end:-1:1),prop_sig(:,end:-1:1)); legend('location','SouthEast');  line([0 135],[.8 .8],'color','k'); axis tight;
hold on;
plot(pick_trials_targ(end:-1:1), sqrt(pick_trials_targ(end:-1:1))/max(sqrt(pick_trials_targ(end:-1:1))),'k')% hold on;


figure; hold on; plot(pick_trials_stand(end:-1:1),prop_sig(1,end:-1:1),'-bo');plot(pick_trials_stand(end:-1:1),prop_sig(2,end:-1:1),'-ro'); legend('location','SouthEast');  line([0 400],[.8 .8],'color','k'); axis tight;
plot(pick_trials_stand(end):-1:1, sqrt(pick_trials_stand(end):-1:1)/max(sqrt(pick_trials_stand(end):-1:1)),'k'); hold off;
ylim([0,1]);



%% Panda

pick_trials_stand = [ 5 10:10:180 ]; %360pick per resample 400 350 300 250 200 150 100 75 50 40 30 20 10 5
pick_trials_targ = pick_trials_stand/5;
pick_trials_stand = pick_trials_stand-pick_trials_targ;


electrode = 7;% 7 = pz; 9 = fz
perms = 10000;
window = [300 525]; %300-550 = p3; 175-275 = mmn

for i_part = 1:nparts
    for i_set = 1:nsets
        exp.setname{i_set}
        for eegset = 1:nevents
            exp.event_names{1,eegset}
            ALLEEG((i_set-1)*nevents*nparts + (eegset-1)*(nparts) + i_part).filename
            % %             if strcmp(exp.participants{i_part},'013') & length(ALLEEG((i_set-1)*nevents*nparts + (eegset-1)*(nparts) + i_part).data(1,:,1)) == 2000
            % %                 ALLEEG((i_set-1)*nevents*nparts + (eegset-1)*(nparts) + i_part).data(:,2:2:2000,:) = [];
            % %                 ALLEEG((i_set-1)*nevents*nparts + (eegset-1)*(nparts) + i_part).times(2:2:2000) = [];
            % %             end
            if i_part == 1 && i_set == 1 && eegset == 1
                time_window = find(ALLEEG((i_set-1)*nevents*nparts + (eegset-1)*(nparts) + i_part).times>=window(1),1):find(ALLEEG((i_set-1)*nevents*nparts + (eegset-1)*(nparts) + i_part).times>=window(2),1)-1; %data points of time window
                erp_out = zeros(length(time_window),2,nparts,nsets,perms,length(pick_trials_stand));
                
            end
            if eegset == 1
                n_stand_trials = ALLEEG((i_set-1)*nevents*nparts + (eegset-1)*(nparts) + i_part).trials;
                for i_perm = 1:perms
                    for i_pick = 1:length(pick_trials_stand)
                        
                        stand_trials = randperm(n_stand_trials,pick_trials_stand(i_pick));            %without replacement (permutation)
                        %                 stand_trials = randi(n_stand_trials,pick_trials_stand(i_pick));  %with relacement (bootstrap)
                        erp_out(:,1,i_part,i_set,i_perm,i_pick) = mean(ALLEEG((i_set-1)*nevents*nparts + (eegset-1)*(nparts) + i_part).data(electrode,time_window,stand_trials),3);
                    end
                end
            elseif eegset == 2
                n_targ_trials = ALLEEG((i_set-1)*nevents*nparts + (eegset-1)*(nparts) + i_part).trials;
                for i_perm = 1:perms
                    for i_pick = 1:length(pick_trials_stand)
                        
                        targ_trials = randperm(n_targ_trials,pick_trials_targ(i_pick));
                        %                   targ_trials = randi(n_targ_trials,pick_trials_targ(i_pick),1)';
                        
                        erp_out(:,2,i_part,i_set,i_perm,i_pick) = mean(ALLEEG((i_set-1)*nevents*nparts + (eegset-1)*(nparts) + i_part).data(electrode,time_window,targ_trials),3);
                    end
                    
                end
            end
            
        end
        
    end
end


H =[];
P = [];
mean_erp = squeeze(mean(erp_out,1));
mean_erp_diff = squeeze(mean_erp(2,:,:,:,:) - mean_erp(1,:,:,:,:));
for i_pick = 1:length(pick_trials_stand)
    for i_perm = 1:perms
        [H(1:2,i_pick,i_perm),P(1:2,i_pick,i_perm)] = ttest(squeeze(mean_erp_diff(:,1:2,i_perm,i_pick)),0,.05,'right',1);%%%for P3
        % %                 [H(1:2,i_pick,i_perm),P(1:2,i_pick,i_perm)] = ttest(squeeze(mean_erp_diff(:,1:2,i_perm,i_pick)),0,.05,'left',1);%%%for MMN
    end
end
prop_sig = sum(H,3)/perms;


figure; plot(pick_trials_targ(end:-1:1),prop_sig(:,end:-1:1)); legend('location','SouthEast');  line([0 135],[.8 .8],'color','k'); axis tight;
hold on;
plot(pick_trials_targ(end:-1:1), sqrt(pick_trials_targ(end:-1:1))/max(sqrt(pick_trials_targ(end:-1:1))),'k')% hold on;


figure; hold on; plot(pick_trials_stand(end:-1:1),prop_sig(1,end:-1:1),'-bo');plot(pick_trials_stand(end:-1:1),prop_sig(2,end:-1:1),'-ro'); legend('location','SouthEast');  line([0 400],[.8 .8],'color','k'); axis tight;
plot(pick_trials_stand(end):-1:1, sqrt(pick_trials_stand(end):-1:1)/max(sqrt(pick_trials_stand(end):-1:1)),'k'); hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%FFT Analysis%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pick_trials = 180; %180 pick per resample, tis the min. trial count after rejections, Auditory  %%
electrode = 9;% 7(Pz) 9(Fz)
perms = 1; %pick all the standard trials for each subject

i_count = 0;
rms_out = zeros(nparts,nsets,perms);
rms_erp_out = zeros(nparts,nsets,perms);
power_out = zeros(61,nparts,nsets,perms);%%%was originally 61, but was not working
erp_out=[];
for i_part = 1:nparts
    for i_set = 1:nsets
        exp.setname{i_set}
        for eegset = 1
            exp.event_names{1,eegset}
            
            ALLEEG((i_set-1)*nevents*nparts + (eegset-1)*(nparts) + i_part).filename
            
            erp_out(:,eegset,:,i_set,i_part) = mean(ALLEEG((i_set-1)*nevents*nparts + (eegset-1)*(nparts) + i_part).data,3)';
            
            n_trials = ALLEEG((i_set-1)*nevents*nparts + (eegset-1)*(nparts) + i_part).trials;
            for i_perm = 1:perms
                these_trials = randperm(n_trials,pick_trials);
                %%%This grabs all the voltages for time points greater than
                %%%0 (tone onset). This will results in 180 random trials
                %%%for each of the 15 electrodes (15 x 1000 x 180)
                %%%It will then calculate the RMS along the 2nd dimension,
                %%%corresponding to each time point. Resulting in a single
                %%%RMS value for each electrode and trial.
                %%%It will then squeeze and remove the singleton value
                %%%(time point).
                %%%It will then take the mean across trials, and then
                %%%across electrodes
                rms_out(i_part,i_set,i_perm) = mean(mean(squeeze(rms( ALLEEG((i_set-1)*nevents*nparts + (eegset-1)*(nparts) + i_part).data(1:15, ALLEEG((i_set-1)*nevents*nparts + (eegset-1)*(nparts) + i_part).times<0,these_trials)   ,2)),2));
                
                %%%This will do similar functions to the above, except that
                %%%it will first take the mean across trials (180), and
                %%%then calculate the RMS for each time point, then average
                %%%by electrodes
                rms_erp_out(i_part,i_set,i_perm) = mean(rms(mean(ALLEEG((i_set-1)*nevents*nparts + (eegset-1)*(nparts) + i_part).data(1:15,ALLEEG((i_set-1)*nevents*nparts + (eegset-1)*(nparts) + i_part).times<0,these_trials),3),2));
                
                %%%test = (18 electrodes x 2000 time points x 180 trials)
                test = ALLEEG((i_set-1)*nevents*nparts + (eegset-1)*(nparts) + i_part).data(:, :,these_trials) ;
                power = [];
                phase = [];
                for i_pick = 1:pick_trials
                    EEG.srate = 1000;
                    
                    %%%this will only look at the voltages at each time
                    %%%point (2000) for one electrode and one trial
                    tempdat = test(electrode,:,i_pick);
                    [power(:,i_pick) phase(:,i_pick) freqs] = kyle_fft(tempdat,EEG.srate,30);
                    %                     power(2:end,i_pick) = power(2:end,i_pick) - mean(power(2:end,i_pick,1)); %subtract mean spectra
                end
                
                %%%this will calculate the average power at each frequency
                %%%for all 180 trials
                %%%power_out = 61 freqs x 24 parts x 2 conds
                power_out(:,i_part,i_set,i_perm) = mean(power(2:end,:),2);
                
                
            end
            
        end
    end
end
eeglab redraw

%%%gets the average power across parts
%%%61 freqs x 2 conds
mean_power_out = squeeze(mean(power_out,2));
stderr_power_out = squeeze(std(power_out,[],2))./sqrt(nparts);
figure; boundedline(freqs(2:end),mean_power_out(:,1),stderr_power_out(:,1), 'b', freqs(2:end),mean_power_out(:,2),stderr_power_out(:,2), 'r' ); axis tight
%
figure;
subplot(3,1,1);
rms_perm_mean = squeeze(mean(rms_out,1));
hist(rms_perm_mean(1,:),50);
hold on; hist(rms_perm_mean(2,:),50); %hold on; hist(rms_perm_mean(3,:),50);
g=findobj(gca,'Type','patch');
set(g(1),'FaceColor',[.9 0 0],'EdgeColor','k');
% set(g(2),'FaceColor',[0 .9 0],'EdgeColor','k');
% set(g(3),'FaceColor',[0 0 .9],'EdgeColor','k');

subplot(3,1,2);
rms_erp_perm_mean = squeeze(mean(rms_erp_out,1));
hist(rms_erp_perm_mean(1,:),50);
hold on; hist(rms_erp_perm_mean(2,:),50); %hold on; hist(rms_erp_perm_mean(3,:),50);
g=findobj(gca,'Type','patch');
set(g(1),'FaceColor',[.9 0 0],'EdgeColor','k');
% set(g(2),'FaceColor',[0 .9 0],'EdgeColor','k');
% set(g(3),'FaceColor',[0 0 .9],'EdgeColor','k');

subplot(3,1,3);
mean_erp_out = squeeze(mean(erp_out,2));
rms_mean_erp_out = squeeze(rms(mean_erp_out,1));
hist(rms_mean_erp_out(1,:),50);
% hold on; hist(rms_mean_erp_out(2,:),50); hold on; hist(rms_mean_erp_out(3,:),50);
g=findobj(gca,'Type','patch');
set(g(1),'FaceColor',[.9 0 0],'EdgeColor','k');
% set(g(2),'FaceColor',[0 .9 0],'EdgeColor','k');
% set(g(3),'FaceColor',[0 0 .9],'EdgeColor','k');

legend(nsets);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%