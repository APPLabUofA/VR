ccc;

%initialize EEGLAB
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

parts = {'004';'005';'006';'007';'008';'009';'010';'012';'014';'015';'016';'017';'018';'019';'020';'021';'022';'023';'024'}; %%%Depth
% % parts = {'004';'005';'006';'007';'008';'009';'010';'012'};
conds = {'near','far'};
blocks = {'01';'02'};
pathname = 'M:\Data\VR_P3\Depth';

rt_near.cond.block.part = [];
rt_far.cond.block.part = [];

total_near = [];
total_far = [];
total_trials = [];

%%%First we loop through our conditions%%%
for i_cond = 1:length(conds)
    %%%now lets loop through our blocks%%%
    for i_block = 1:length(blocks)
        %%%now loop through participants%%%
        for i_part = 1:length(parts)
            if str2num(parts{i_part}) < 11 & i_block == 2
                continue
            else
                %%%setup filenames%%%
                %%%since parts 4-10 used one EEG for each condition%%%
                %%%need to use different names%%%
                if str2num(parts{i_part}) >= 11
                    filename =  [parts{i_part} '_' blocks{i_block} '_depth_p3_' conds{i_cond} '.vhdr'];
                elseif str2num(parts{i_part}) < 11
                    filename =  [parts{i_part} '_depth_p3_' conds{i_cond} '.vhdr'];
                end
                %%%now let's load our EEG file%%%
                if str2num(parts{i_part}) == 5 & strcmp(conds{i_cond},'near') == 1
                    filename1 =  [parts{i_part} '_01_depth_p3_' conds{i_cond} '.vhdr'];
                    filename2 =  [parts{i_part} '_02_depth_p3_' conds{i_cond} '.vhdr'];
                    EEG_part1 = pop_loadbv(pathname, filename1);
                    EEG_part2 = pop_loadbv(pathname, filename2);
                    EEG = pop_mergeset(EEG_part1,EEG_part2,1);
                else
                    EEG = pop_loadbv(pathname, filename);
                end
                
                %%%now we will loop through each of our events%%%
                temp_total_near = 0;
                temp_total_far = 0;
                temp_rt_near = [];
                temp_rt_far = [];
                allevents = length(EEG.event);
                for i_event = 2:allevents %skip the first
                    %%%check to see if there are duplicate response triggers%%%
                    %%%sometimes we get two response triggers overlapping%%%
                    EEG.event(i_event).type = num2str(str2num(EEG.event(i_event).type(2:end)));
                    if i_event+1 <= allevents
                        %%%for part 5, we need to change event triggers%%%
                        if strcmp(parts{i_part},'005') == 1
                            if strcmp(EEG.event(i_event).type, '5') == 1
                                EEG.event(i_event).type = '1';
                                if strcmp(EEG.event(i_event+1).type, 'S142') == 1 | strcmp(EEG.event(i_event+1).type, 'S143') == 1
                                    EEG.event(i_event+1).type = 'S138';
                                end
                            elseif strcmp(EEG.event(i_event).type, '6') == 1
                                EEG.event(i_event).type = '2';
                                if strcmp(EEG.event(i_event+1).type, 'S142') == 1 | strcmp(EEG.event(i_event+1).type, 'S143') == 1
                                    EEG.event(i_event+1).type = 'S139';
                                end
                            end
                        end
                        %%%here we will record the rt for responded trials%%%
                        if strcmp(EEG.event(i_event).type, '1') == 1
                            if strcmp(EEG.event(i_event+1).type, 'S138') == 1 | strcmp(EEG.event(i_event+1).type, 'S139') == 1
                                temp_rt_near = [temp_rt_near,(EEG.event(i_event+1).latency - EEG.event(i_event).latency)/EEG.srate];
                            end
                        elseif strcmp(EEG.event(i_event).type, '2') == 1
                            if strcmp(EEG.event(i_event+1).type, 'S138') == 1 | strcmp(EEG.event(i_event+1).type, 'S139') == 1
                                temp_rt_far = [temp_rt_far,(EEG.event(i_event+1).latency - EEG.event(i_event).latency)/EEG.srate];
                            end
                        end
                    end
                    %%%here we will keep track of the number of objects%%%
                    if strcmp(EEG.event(i_event).type, '1') == 1
                        temp_total_near = temp_total_near + 1;
                    elseif strcmp(EEG.event(i_event).type, '2') == 1
                        temp_total_far = temp_total_far + 1;
                    end
                end
                %%%now record the total number of trials for each condition etc%%%
                total_near(i_cond,i_block,i_part) = temp_total_near;
                total_far(i_cond,i_block,i_part) = temp_total_far;
                total_trials(i_cond,i_block,i_part) = temp_total_near + temp_total_far;
                %%%here we delete the rt%%%
                if isempty(temp_rt_near) == 1
                    rt_near(i_part).cond(i_cond).block(i_block).part(1,:) = 0;
                elseif isempty(temp_rt_near) == 0
                    rt_near(i_part).cond(i_cond).block(i_block).part(1,:) = temp_rt_near;
                end
                if isempty(temp_rt_far) == 1
                    rt_far(i_part).cond(i_cond).block(i_block).part(1,:) = 0;
                elseif isempty(temp_rt_far) == 0
                    rt_far(i_part).cond(i_cond).block(i_block).part(1,:) = temp_rt_far;
                end
                %%%delete the 2nd block for parts less than 11%%%
                %%%since both blocks are in one file%%%
                % %                             if str2num(parts{i_part}) < 11 & i_block == 2
                % %                                 rt_near(i_part).cond(i_cond).block(i_block).part(1,:) = 0;
                % %                                 rt_far(i_part).cond(i_cond).block(i_block).part(1,:) = 0;
                % %                                 % %                 rt_near(i_part).cond(i_cond).block(i_block).part(1) = 0;
                % %                                 % %                 rt_far(i_part).cond(i_cond).block(i_block).part(1) = 0;
                % %                             end
            end
        end
    end
end

%%%First, let's calculate the mean and SE for RT in conditions%%%
mean_rt_near = [];
mean_rt_far = [];
mean_rt_near_targets = [];
mean_rt_far_targets = [];
mean_rt_near_standards = [];
mean_rt_far_standards = [];

counts_near_targets = [];
counts_near_targets = [];
counts_far_standards = [];
counts_far_targets = [];


%%%First we loop through our conditions%%%
for i_cond = 1:length(conds)
    %%%now lets loop through our blocks%%%
    for i_block = 1:length(blocks)
        %%%now loop through participants%%%
        %%%for cond 1, targets are near and standards are far%%%
        %%%for cond 2, targets are far and standards are near%%%
        for i_part = 1:length(parts)
            %             if rt_near(i_part).cond(i_cond).block(i_block).part(1) == 0 | rt_far(i_part).cond(i_cond).block(i_block).part(1) == 0
            if str2num(parts{i_part}) < 11 & i_block == 2
                continue
            elseif strcmp(conds{i_cond},'near') == 1
                %%%here we group near targets and near standards%%%
                mean_rt_near = [mean_rt_near,rt_near(i_part).cond(1).block(i_block).part(1,:),rt_near(i_part).cond(2).block(i_block).part(1,:)];
                %%%just grab near targets%%%
                mean_rt_near_targets = [mean_rt_near_targets,rt_near(i_part).cond(1).block(i_block).part(1,:)];
                counts_near_targets(i_block,i_part) = length(rt_near(i_part).cond(1).block(i_block).part(1,:));
                %%%now grab near standards%%%
                mean_rt_near_standards = [mean_rt_near_standards,rt_near(i_part).cond(2).block(i_block).part(1,:)];
                counts_near_standards(i_block,i_part) = length(rt_near(i_part).cond(2).block(i_block).part(1,:));
            elseif strcmp(conds{i_cond},'far') == 1
                %%%group far targets and standards%%%
                mean_rt_far = [mean_rt_far,rt_far(i_part).cond(2).block(i_block).part(1,:),rt_far(i_part).cond(1).block(i_block).part(1,:)];
                %%%far targets%%%
                mean_rt_far_targets = [mean_rt_far_targets,rt_far(i_part).cond(2).block(i_block).part(1,:)];
                counts_far_targets(i_block,i_part) = length(rt_far(i_part).cond(2).block(i_block).part(1,:));
                %%%far standards%%%
                mean_rt_far_standards = [mean_rt_far_standards,rt_far(i_part).cond(1).block(i_block).part(1,:)];
                counts_far_standards(i_block,i_part) = length(rt_far(i_part).cond(1).block(i_block).part(1,:));
            end
        end
    end
end

%%%get rid of any 0 ms rt%%%
mean_rt_near(mean_rt_near == 0) = [];
mean_rt_far(mean_rt_far == 0) = [];
mean_rt_near_targets(mean_rt_near_targets == 0) = [];
mean_rt_far_targets(mean_rt_far_targets == 0) = [];
mean_rt_near_standards(mean_rt_near_standards == 0) = [];
mean_rt_far_standards(mean_rt_far_standards == 0) = [];

%%%Now we will plot our RT in some way%%%
figure;hold on;
label_names = categorical(["All Near" "All Far" "Near Standards" "Far Standards" "Near Targets" "Far Targets"]);
label_names = reordercats(label_names,{'All Near','All Far','Near Standards','Far Standards','Near Targets','Far Targets'});
bar(label_names,...
    [mean(mean_rt_near),mean(mean_rt_far),...
    mean(mean_rt_near_standards),mean(mean_rt_far_standards),...
    mean(mean_rt_near_targets),mean(mean_rt_far_targets)]);
errorbar([mean(mean_rt_near),mean(mean_rt_far),...
    mean(mean_rt_near_standards),mean(mean_rt_far_standards),...
    mean(mean_rt_near_targets),mean(mean_rt_far_targets)],...
    [std(mean_rt_near)/sqrt(length(parts)),std(mean_rt_far)/sqrt(length(parts)),...
    std(mean_rt_near_standards)/sqrt(length(parts)),std(mean_rt_far_standards)/sqrt(length(parts)),...
    std(mean_rt_near_targets)/sqrt(length(parts)),std(mean_rt_far_targets)/sqrt(length(parts))],'.');
ylim([0.5,0.8]);title('RT for Near and Far Stimuli');
hold off;

%%%since we will also want to calculate rt for individual parts%%%
%%%we will remove rt that are zero%%%
%%%First we loop through our conditions%%%
for i_cond = 1:length(conds)
    %%%now lets loop through our blocks%%%
    for i_block = 1:length(blocks)
        %%%now loop through participants%%%
        %%%for cond 1, targets are near and standards are far%%%
        %%%for cond 2, targets are far and standards are near%%%
        for i_part = 1:length(parts)
            rt_near(i_part).cond(1).block(i_block).part(1,rt_near(i_part).cond(1).block(i_block).part(1,:) == 0) = [];
            rt_far(i_part).cond(1).block(i_block).part(1,rt_far(i_part).cond(1).block(i_block).part(1,:) == 0) = [];
        end
    end
end

% % for i_test = 1:3
% %     i_test = 8;
% %     disp(i_test)
% %
% % end
% % far_count = 0;
% % near_count = 0;
% % for i_event = 2:length(EEG.event)
% %     if  strcmp(EEG.event(i_event).type,'S  1') == 1
% %         near_count = near_count + 1;
% %     elseif strcmp(EEG.event(i_event).type,'S  2') == 1
% %         far_count = far_count + 1;
% %     end
% % end