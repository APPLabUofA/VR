allevents = length(EEG.event);

for i_event = 2:allevents %skip the first
    EEG.event(i_event).type = num2str(str2num(EEG.event(i_event).type(2:end)));
end


%%%%%Get first high and low tone after picture onset%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pic_break = 0;
tone_break = 0;
events = [];

for i_event = 2:allevents %skip the first
    if isempty(str2num(EEG.event(i_event-1).type)) == 1
        %%%%%Check for nature pictures%%%%%
    elseif isempty(find([101:150] == str2num(EEG.event(i_event-1).type))) ~= 1
        pic_break = pic_break + 1;
        %%%%%Check for tone type%%%%%
        if str2num(EEG.event(i_event).type) == 21
            events = [events,i_event];
            EEG.event(i_event).type = num2str(151);
            i_next = 0;
            while str2num(EEG.event(i_event+i_next).type) ~= 22 && i_event + i_next < allevents
                i_next = i_next + 1;
                if isempty(str2num(EEG.event(i_event+i_next).type)) == 1 || isempty(find([101:150] == str2num(EEG.event(i_event+i_next).type))) ~= 1
                    break
                end
            end
            if str2num(EEG.event(i_event+i_next).type) == 22
                EEG.event(i_event+i_next).type = num2str(152);
                events = [events,i_event];
            end
        elseif str2num(EEG.event(i_event).type) == 22
            events = [events,i_event];
            EEG.event(i_event).type = num2str(152);
            i_next = 0;
            while str2num(EEG.event(i_event+i_next).type) ~= 21 && i_event + i_next < allevents
                i_next = i_next + 1;
                if isempty(str2num(EEG.event(i_event+i_next).type)) == 1 || isempty(find([101:150] == str2num(EEG.event(i_event+i_next).type))) ~= 1
                    break
                end
            end
            if str2num(EEG.event(i_event+i_next).type) == 21
                EEG.event(i_event+i_next).type = num2str(151);
                events = [events,i_event];
            end
        end
        %%%%%Check for urban pictures%%%%%
    elseif isempty(find([201:250] == str2num(EEG.event(i_event-1).type))) ~= 1
        pic_break = pic_break + 1;
        %%%%%Check for tone type%%%%%
        if str2num(EEG.event(i_event).type) == 31
            events = [events,i_event];
            EEG.event(i_event).type = num2str(251);
            i_next = 0;
            while str2num(EEG.event(i_event+i_next).type) ~= 32 && i_event + i_next < allevents
                i_next = i_next + 1;
                if isempty(str2num(EEG.event(i_event+i_next).type)) == 1 || isempty(find([201:250] == str2num(EEG.event(i_event+i_next).type))) ~= 1
                    break
                end
            end
            if str2num(EEG.event(i_event+i_next).type) == 32
                EEG.event(i_event+i_next).type = num2str(252);
                events = [events,i_event];
            end
        elseif str2num(EEG.event(i_event).type) == 32
            events = [events,i_event];
            EEG.event(i_event).type = num2str(252);
            i_next = 0;
            while str2num(EEG.event(i_event+i_next).type) ~= 31 && i_event + i_next < allevents
                i_next = i_next + 1;
                if isempty(str2num(EEG.event(i_event+i_next).type)) == 1 || isempty(find([201:250] == str2num(EEG.event(i_event+i_next).type))) ~= 1
                    break
                end
            end
            if str2num(EEG.event(i_event+i_next).type) == 31
                EEG.event(i_event+i_next).type = num2str(251);
                events = [events,i_event];
            end
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%Get first 5 tones after picture onset%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pic_break = 0;
tone_break = 0;
events = [];

for i_event = 2:allevents %skip the first
    if isempty(str2num(EEG.event(i_event-1).type)) == 1
        %%%%%Check for nature pictures%%%%%
    elseif isempty(find([101:150] == str2num(EEG.event(i_event-1).type))) ~= 1
        pic_break = pic_break + 1;
%         events = [events,i_event-1];
        %%%%%Check for tone type%%%%%
        i_trig = 0;
        while i_trig ~= 5
            if str2num(EEG.event(i_event+i_trig).type) == 21
                EEG.event(i_event+i_trig).type = num2str(151);
                i_trig = i_trig + 1;
                events = [events,i_event];
            elseif str2num(EEG.event(i_event+i_trig).type) == 22
                EEG.event(i_event+i_trig).type = num2str(152);
                i_trig = i_trig + 1;
                events = [events,i_event];
            else
                i_trig = i_trig + 1;
            end
        end
        %%%%%Check for urban pictures%%%%%
    elseif isempty(find([201:250] == str2num(EEG.event(i_event-1).type))) ~= 1
        pic_break = pic_break + 1;
%         events = [events,i_event-1];
        %%%%%Check for tone type%%%%%
        i_trig = 0;
        while i_trig ~= 5
            if str2num(EEG.event(i_event+i_trig).type) == 31
                EEG.event(i_event+i_trig).type = num2str(251);
                i_trig = i_trig + 1;
                events = [events,i_event];
            elseif str2num(EEG.event(i_event+i_trig).type) == 32
                EEG.event(i_event+i_trig).type = num2str(252);
                i_trig = i_trig + 1;
                events = [events,i_event];
            else
                i_trig = i_trig + 1;
            end
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%152,151,152,151,151
%%%151,151,152,152,151


%%%%%%%%%%%%%%%%%%%OLDOLDOLDOLDOLDOLDOLDOLDOLDOLDOLDOLDOLD%%%%%%%%%%%%%%%%%
% %             for i_event = 2:allevents %skip the first
% %                 if isempty(str2num(EEG.event(i_event-1).type)) == 1
% %                     %%%%%Check for nature pictures%%%%%
% %                 elseif isempty(find([101:150] == str2num(EEG.event(i_event-1).type))) ~= 1
% %                     %%%%%Check for tone type%%%%%
% %                     if str2num(EEG.event(i_event).type) == 21
% %                         EEG.event(i_event).type = num2str(151);
% %                         i_next = 0;
% %                         while str2num(EEG.event(i_event+i_next).type) ~= 2 && i_event + i_next < allevents
% %                             i_next = i_next + 1;
% %                             if isempty(str2num(EEG.event(i_event+i_next).type)) == 1 || isempty(find([101:150] == str2num(EEG.event(i_event+i_next).type))) ~= 1
% %                                 break
% %                             elseif str2num(EEG.event(i_event+i_next).type) == 22
% %                                 EEG.event(i_event+i_next).type = num2str(152);
% %                                 break
% %                             end
% %                         end
% %                     elseif str2num(EEG.event(i_event).type) == 22
% %                         EEG.event(i_event).type = num2str(152);
% %                         i_next = 0;
% %                         while str2num(EEG.event(i_event+i_next).type) ~= 1 && i_event + i_next < allevents
% %                             i_next = i_next + 1;
% %                             if isempty(str2num(EEG.event(i_event+i_next).type)) == 1 || isempty(find([101:150] == str2num(EEG.event(i_event+i_next).type))) ~= 1
% %                                 break
% %                             elseif str2num(EEG.event(i_event+i_next).type) == 21
% %                                 EEG.event(i_event+i_next).type = num2str(151);
% %                                 break
% %                             end
% %                         end
% %                     end
% %                     %%%%%Check for urban pictures%%%%%
% %                 elseif isempty(find([201:250] == str2num(EEG.event(i_event-1).type))) ~= 1
% %                     %%%%%Check for tone type%%%%%
% %                     if str2num(EEG.event(i_event).type) == 31
% %                         EEG.event(i_event).type = num2str(251);
% %                         i_next = 0;
% %                         while str2num(EEG.event(i_event+i_next).type) ~= 2 && i_event + i_next < allevents
% %                             i_next = i_next + 1;
% %                             if isempty(str2num(EEG.event(i_event+i_next).type)) == 1 || isempty(find([201:250] == str2num(EEG.event(i_event+i_next).type))) ~= 1
% %                                 break
% %                             elseif str2num(EEG.event(i_event+i_next).type) == 32
% %                                 EEG.event(i_event+i_next).type = num2str(252);
% %                                 break
% %                             end
% %                         end
% %                         
% %                     elseif str2num(EEG.event(i_event).type) == 32
% %                         EEG.event(i_event).type = num2str(252);
% %                         i_next = 0;
% %                         while str2num(EEG.event(i_event+i_next).type) ~= 1 && i_event + i_next < allevents
% %                             i_next = i_next + 1;
% %                             if isempty(str2num(EEG.event(i_event+i_next).type)) == 1 || isempty(find([201:250] == str2num(EEG.event(i_event+i_next).type))) ~= 1
% %                                 break
% %                             elseif str2num(EEG.event(i_event+i_next).type) == 31
% %                                 EEG.event(i_event+i_next).type = num2str(251);
% %                                 break
% %                             end
% %                         end
% %                     end
% %                 end
% %             end
