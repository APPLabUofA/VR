

%% Characterising Gitter

% % % % erp_part_max2 = zeros(2,2,19)
% % % % for tone_part = 1:2
% % % %     for cond_part = 1:2
% % % %         for i_part = 1:length(exp.participants)
% % % %             erp_part_max2(tone_part,cond_part,i_part) = max(erpdata_parts(tone_part,cond_part).cond([1301:1551],i_part));
% % % %         end
% % % %     end
% % % % end
%% Latency of maxes between conditions for each participants for high tones only  %%

timea = 1301;
timeb = 1551;
erp_part_max_latency_diff = zeros(2,24);
for cond_part = 1:2
    for i_part = 1:length(exp.participants)
        erp_part_max_latency_diff(cond_part,i_part) = find(erpdata_parts(cond_part,2).cond([timea:timeb],i_part) == max(erpdata_parts(cond_part,2).cond([timea:timeb],i_part)),1);
    end
end

col = ['k','b';'k','r'];
%%%%% Pick your condition 1 = no headset; 2 = headset%%%%%
cond1 = 1;
cond2 = 1;
%%%%%Pick your tone 1 = low; 2 = high%%%%%
tone1 = 2;
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
    line([erp_part_max_latency_diff(cond1,i_part)+301 erp_part_max_latency_diff(cond1,i_part)+301],[-10 10],'color','k'); %%%%use this to help find ERP regions
    line([-200 1000],[0 0],'color','k');
    title(['Participant ' num2str(i_part)]);
end
 hold off;

 
%% Latency differences of maxes between conditions for each participants %%

timea = 1301
timeb = 1551
erp_part_max_latency_diff = zeros(2,24);
for cond_part = 1:2
    for i_part = 1:length(exp.participants)
        erp_part_max_latency_diff(cond_part,i_part) = find((erpdata_parts(cond_part,2).cond([timea:timeb],i_part))-(erpdata_parts(cond_part,1).cond([timea:timeb],i_part))...
            == max((erpdata_parts(cond_part,2).cond([timea:timeb],i_part))-(erpdata_parts(cond_part,1).cond([timea:timeb],i_part))));
    end
end
erp_part_max_latency_diff

latency_mean_nhs = mean(erp_part_max_latency_diff(1,:))+timea
erp_part_nhs_min = latency_mean_nhs+timea-100;
erp_part_nhs_max = latency_mean_nhs+timea+100;
latency_std_nhs = std(erp_part_max_latency_diff(1,:))

latency_mean_hs = mean(erp_part_max_latency_diff(2,:))+timea
erp_part_hs_min = latency_mean_hs+timea-100;
erp_part_hs_max = latency_mean_hs+timea+100;
latency_std_hs = std(erp_part_max_latency_diff(2,:))

[h p ci stat] = ttest(mean(erp_part_max_latency_diff(1,:),1),mean(erp_part_max_latency_diff(2,:),1),.05,'both',2); %% For headset - no headset %%
disp(['h-val: ', num2str(h),' p-val: ', num2str(p),' ci-val: ', num2str(ci),' stat.tstat-val: ', num2str(stat.tstat),' stat.df-val: ' num2str(stat.df),' stat.sd-val: ' num2str(stat.sd)])


%% Voltage differences of maxes between conditions for each participants %%

erp_part_max_voltage_diff = zeros(2,24);
for cond_part = 1:2
    for i_part = 1:length(exp.participants)
        erp_part_max_voltage_diff(cond_part,i_part) = max((erpdata_parts(2,cond_part).cond([timea:timeb],i_part))-(erpdata_parts(1,cond_part).cond([timea:timeb],i_part)));
    end
end
erp_part_max_voltage_diff

voltage_mean_nhs = mean(erp_part_max_voltage_diff(1,:))
voltage_std_nhs = std(erp_part_max_voltage_diff(1,:))

voltage_mean_hs = mean(erp_part_max_voltage_diff(2,:))
voltage_std_hs = std(erp_part_max_voltage_diff(2,:))

%% Now I need the average within the window(if you want amp. diff. measure) %%

erp_part_nhs_min 
erp_part_nhs_max 

erp_part_hs_min 
erp_part_hs_max 




