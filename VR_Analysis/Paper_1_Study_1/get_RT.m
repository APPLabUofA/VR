ccc;

%initialize EEGLAB
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

parts= {'013';'014';'015';'016';'017';'018';'019';'020';'021';'022';'023';'024';'025';'026';'028';'029';'030';'031';'032';'033';'034';'035';'036';'037'}; %%%new vr
conds = {'auditory_nhs','auditory_hs','visual_nhs','visual_hs'};

rt.auditory.nhs.correct = [];
rt.auditory.hs.correct = [];
rt.visual.nhs.correct = [];
rt.visual.hs.correct = [];
total_rt_anhs = [];
total_rt_ahs = [];
total_rt_vnhs = [];
total_rt_vhs = [];
temp_anhs = [];
temp_ahs = [];
temp_vnhs = [];
temp_vhs = [];
rt_parts = {};
total_targets_parts = zeros(4,24);
pathname = 'M:\Data\VR_P3';

for i_part = 1:length(parts)
    for i_cond = 1:length(conds)
        filename =  [parts{i_part} '_' conds{i_cond} '.vhdr'];
        EEG = pop_loadbv(pathname, filename);
        allevents = length(EEG.event);
        
        for i_event = 2:allevents
            if strcmp(EEG.event(i_event - 1).type,'S255')
                if i_cond == 1
                    total_targets_parts(1,i_part) = total_targets_parts(1,i_part) + 1;
                elseif i_cond == 2
                    total_targets_parts(2,i_part) = total_targets_parts(2,i_part) + 1;
                elseif i_cond == 3
                    total_targets_parts(3,i_part) = total_targets_parts(3,i_part) + 1;
                elseif i_cond == 4
                    total_targets_parts(4,i_part) = total_targets_parts(4,i_part) + 1;
                end
            end
            if strcmp(EEG.event(i_event).type,'S153') & strcmp(EEG.event(i_event - 1).type,'S255')
                if strcmp(conds{i_cond},'auditory_nhs')
                    temp_anhs = [temp_anhs, EEG.event(i_event).latency - EEG.event(i_event - 1).latency];
                elseif strcmp(conds{i_cond},'auditory_hs')
                    temp_ahs = [temp_ahs, EEG.event(i_event).latency - EEG.event(i_event - 1).latency];
                elseif strcmp(conds{i_cond},'visual_nhs')
                    temp_vnhs = [temp_vnhs, EEG.event(i_event).latency - EEG.event(i_event - 1).latency];
                elseif strcmp(conds{i_cond},'visual_hs')
                    temp_vhs = [temp_vhs, EEG.event(i_event).latency - EEG.event(i_event - 1).latency];
                end
            elseif strcmp(EEG.event(i_event).type,'S153') & strcmp(EEG.event(i_event - 1).type,'S 85')
            end
        end
        
    end
    rt(i_part).auditory.nhs.correct = temp_anhs;
    rt(i_part).auditory.hs.correct = temp_ahs;
    rt(i_part).visual.nhs.correct = temp_vnhs;
    rt(i_part).visual.hs.correct = temp_vhs;
    rt_parts{1,i_part} = temp_anhs;
    rt_parts{2,i_part} = temp_ahs;
    rt_parts{3,i_part} = temp_vnhs;
    rt_parts{4,i_part} = temp_vhs;
    total_rt_anhs = [total_rt_anhs,temp_anhs];
    total_rt_ahs = [total_rt_ahs,temp_ahs];
    total_rt_vnhs = [total_rt_vnhs,temp_vnhs];
    total_rt_vhs = [total_rt_vhs,temp_vhs];
    temp_anhs = [];
    temp_ahs = [];
    temp_vnhs = [];
    temp_vhs = [];
end

%%%now let's determine the average RT for each participant%%%
avg_rt = [];
for i_part = 1:length(parts)
    avg_rt(1,i_part) = mean(rt(i_part).auditory.nhs.correct);
    avg_rt(2,i_part) = mean(rt(i_part).auditory.hs.correct);
    avg_rt(3,i_part) = mean(rt(i_part).visual.nhs.correct);
    avg_rt(4,i_part) = mean(rt(i_part).visual.hs.correct);
end

figure;hold on;

bar([mean(total_rt_anhs);mean(total_rt_ahs);mean(total_rt_vnhs);mean(total_rt_vhs)]);

errorbar([mean(total_rt_anhs),mean(total_rt_ahs),mean(total_rt_vnhs),mean(total_rt_vhs)],...
    [std(total_rt_anhs)/sqrt(length(parts)),std(total_rt_ahs)/sqrt(length(parts)),std(total_rt_vnhs)/sqrt(length(parts)),std(total_rt_vhs)/sqrt(length(parts))],'.');

title('Response Times for each task'); ylim([400,700]);hold off;

%%%now let's do some stats on the rt%%%
[mean(total_rt_anhs),std(total_rt_anhs);mean(total_rt_ahs),std(total_rt_ahs);mean(total_rt_vnhs),std(total_rt_vnhs);mean(total_rt_vhs),std(total_rt_vhs)]

%%%keep in mind the data is organised this way:
%%%1 = Auditory Non-VR
%%%2 = Auditory VR
%%%3 = Visual Non-VR
%%%4 = Visual VR
[p,tbl,stats] = anova1(avg_rt');

%%%c provides a matrix of the results from the multiple comparisons
%%% column 1 & 2 = items being compared
%%% column 3 = lower confidence interval
%%% column 4 = estimate
%%% column 5 = upper confidence interval
[c,m,h,gnames] = multcompare(stats,'CType','hsd');

[gnames(c(:,1)), gnames(c(:,2)), num2cell(c(:,3:6))]





