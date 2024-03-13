function resultsTable = rmi(raw_data)

    right_sounds_evt07 = raw_data.right_sounds_evt07;
    left_sounds_evt08 = raw_data.left_sounds_evt08;
    right_licks_timestamps = raw_data.right_licks_timestamps;
    left_licks_timestamps = raw_data.left_licks_timestamps;
    laser_on_evt05 = raw_data.laser_on_evt05.Ts;

    counters = struct('left_reward', 0, 'right_reward', 0, ...
                     'left_laser_reward', 0, 'right_laser_reward', 0, ...
                     'left_mistrial', 0, 'right_mistrial', 0, ...
                     'left_laser_mistrial', 0, 'right_laser_mistrial', 0, ...
                     'left_incorrect', 0, 'right_incorrect', 0, ...
                     'left_laser_incorrect', 0, 'right_laser_incorrect', 0);
    
    % combine and sort sounds
    sounds = sort([right_sounds_evt07.Ts; left_sounds_evt08.Ts]);

    % go through each sound and determine if it was a correct, incorrect, or mistrial
    for i = 1:length(sounds)-1
        sound_time = sounds(i);
        is_laser_trial = any(abs(laser_on_evt05 - sound_time) <= 0.5);

        % extract licks in the next 0.5 seconds from the sound
        right_licks_in_window = right_licks_timestamps(right_licks_timestamps > sound_time & right_licks_timestamps <= sound_time + 0.5);
        left_licks_in_window = left_licks_timestamps(left_licks_timestamps > sound_time & left_licks_timestamps <= sound_time + 0.5);

        % find the first lick and its side
        first_lick_side = 'none';
        if ~isempty(right_licks_in_window)
            first_lick_right = min(right_licks_in_window);
            first_lick_side = 'right';
        end
        if ~isempty(left_licks_in_window)
            first_lick_left = min(left_licks_in_window);
            if strcmp(first_lick_side, 'none') || first_lick_left < first_lick_right
                first_lick_side = 'left';
            end
        end

        % laser trials
        if is_laser_trial
            % sound in right/left side corresponds to the first lick
            if (ismember(sound_time, right_sounds_evt07.Ts) && strcmp(first_lick_side, 'right')) || ...
               (ismember(sound_time, left_sounds_evt08.Ts) && strcmp(first_lick_side, 'left'))
                if strcmp(first_lick_side, 'right')
                    counters.right_laser_reward = counters.right_laser_reward + 1;
                else
                    counters.left_laser_reward = counters.left_laser_reward + 1;
                end
            % no licks in the window
            elseif isempty(right_licks_in_window) && isempty(left_licks_in_window)
                if strcmp(first_lick_side, 'right')
                    counters.right_laser_mistrial = counters.right_laser_mistrial + 1;
                else
                    counters.left_laser_mistrial = counters.left_laser_mistrial + 1;
                end
            % licks in the window but first lick not in the correct side
            else
                if strcmp(first_lick_side, 'right')
                    counters.right_laser_incorrect = counters.right_laser_incorrect + 1;
                else
                    counters.left_laser_incorrect = counters.left_laser_incorrect + 1;
                end
            end
        % non laser trials, same logic as above, can be refactored in future
        else
            if (ismember(sound_time, right_sounds_evt07.Ts) && strcmp(first_lick_side, 'right')) || ...
               (ismember(sound_time, left_sounds_evt08.Ts) && strcmp(first_lick_side, 'left'))
                if strcmp(first_lick_side, 'right')
                    counters.right_reward = counters.right_reward + 1;
                else
                    counters.left_reward = counters.left_reward + 1;
                end
            elseif isempty(right_licks_in_window) && isempty(left_licks_in_window)
                if strcmp(first_lick_side, 'right')
                    counters.right_mistrial = counters.right_mistrial + 1;
                else
                    counters.left_mistrial = counters.left_mistrial + 1;
                end
            else
                if strcmp(first_lick_side, 'right')
                    counters.right_incorrect = counters.right_incorrect + 1;
                else
                    counters.left_incorrect = counters.left_incorrect + 1;
                end
            end
        end
    end
    % totals and percents
    total_left_no_laser = counters.left_reward + counters.left_mistrial + counters.left_incorrect;
    total_right_no_laser = counters.right_reward + counters.right_mistrial + counters.right_incorrect;
    total_left_laser = counters.left_laser_reward + counters.left_laser_mistrial + counters.left_laser_incorrect;
    total_right_laser = counters.right_laser_reward + counters.right_laser_mistrial + counters.right_laser_incorrect;

    total_all = total_left_no_laser + total_right_no_laser + total_left_laser + total_right_laser;
    total_reward = counters.left_reward + counters.right_reward + counters.left_laser_reward + counters.right_laser_reward;
    total_incorrect = counters.left_incorrect + counters.right_incorrect + counters.left_laser_incorrect + counters.right_laser_incorrect;
    total_mistrial = counters.left_mistrial + counters.right_mistrial + counters.left_laser_mistrial + counters.right_laser_mistrial;

    percentage_total = ((total_reward) / (total_all)) * 100;
    percentage_incorrect = ((total_incorrect) / (total_all)) * 100;
    percentage_mistrial = ((total_mistrial) / (total_all)) * 100;

    percentage_left_no_laser = (counters.left_reward / total_left_no_laser) * 100;
    percentage_right_no_laser = (counters.right_reward / total_right_no_laser) * 100;
    percentage_left_laser = (counters.left_laser_reward / total_left_laser) * 100;
    percentage_right_laser = (counters.right_laser_reward / total_right_laser) * 100;

    percentage_left_no_laser_incorrect = (counters.left_incorrect / total_left_no_laser) * 100;
    percentage_right_no_laser_incorrect = (counters.right_incorrect / total_right_no_laser) * 100;
    percentage_left_laser_incorrect = (counters.left_laser_incorrect / total_left_laser) * 100;
    percentage_right_laser_incorrect = (counters.right_laser_incorrect / total_right_laser) * 100;

    percentage_left_no_laser_mistrial = (counters.left_mistrial / total_left_no_laser) * 100;
    percentage_right_no_laser_mistrial = (counters.right_mistrial / total_right_no_laser) * 100;
    percentage_left_laser_mistrial = (counters.left_laser_mistrial / total_left_laser) * 100;
    percentage_right_laser_mistrial = (counters.right_laser_mistrial / total_right_laser) * 100;

    % output table with results
    resultsTable = table([percentage_left_no_laser; percentage_right_no_laser; percentage_left_laser; percentage_right_laser; percentage_total],...
                         [percentage_left_no_laser_incorrect; percentage_right_no_laser_incorrect; percentage_left_laser_incorrect; percentage_right_laser_incorrect; percentage_incorrect],...
                         [percentage_left_no_laser_mistrial; percentage_right_no_laser_mistrial; percentage_left_laser_mistrial; percentage_right_laser_mistrial; percentage_mistrial],...
                         [total_left_no_laser; total_right_no_laser; total_left_laser; total_right_laser; total_all],...
                         [counters.left_reward; counters.right_reward; counters.left_laser_reward; counters.right_laser_reward; total_reward],...
                         [counters.left_incorrect; counters.right_incorrect; counters.left_laser_incorrect; counters.right_laser_incorrect; total_incorrect],...
                         [counters.left_mistrial; counters.right_mistrial; counters.left_laser_mistrial; counters.right_laser_mistrial; total_mistrial],...
                         'VariableNames', {'Percentage Reward','Percentage Incorrect','Percentage Mistrial', 'Total', 'Reward', 'Incorrect', 'Mistrial'},...
                         'RowNames', {'LeftNoLaser', 'RightNoLaser', 'LeftLaser', 'RightLaser', 'Total'});
    
end