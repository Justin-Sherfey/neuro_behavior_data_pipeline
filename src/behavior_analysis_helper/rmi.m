function results = rmi(raw_data)

    right_sounds_evt07 = raw_data.right_sounds_evt07;
    left_sounds_evt08 = raw_data.left_sounds_evt08;
    right_licks_timestamps = raw_data.right_licks_timestamps;
    left_licks_timestamps = raw_data.left_licks_timestamps;
    laser_on_evt05 = raw_data.laser_on_evt05.Ts;

    results = struct('left_reward', 0, 'right_reward', 0, ...
                     'left_laser_reward', 0, 'right_laser_reward', 0, ...
                     'left_mistrial', 0, 'right_mistrial', 0, ...
                     'left_laser_mistrial', 0, 'right_laser_mistrial', 0, ...
                     'left_incorrect', 0, 'right_incorrect', 0, ...
                     'left_laser_incorrect', 0, 'right_laser_incorrect', 0);
    
    % combine and sort sounds
    sounds = sort([right_sounds_evt07.Ts; left_sounds_evt08.Ts]);

    for i = 1:length(sounds)-1
        sound_time = sounds(i);
        is_laser_trial = any(abs(laser_on_evt05 - sound_time) <= 0.5);

        % Extract licks that occur after the sound and before 500 ms
        right_licks_in_window = right_licks_timestamps(right_licks_timestamps > sound_time & right_licks_timestamps <= sound_time + 0.5);
        left_licks_in_window = left_licks_timestamps(left_licks_timestamps > sound_time & left_licks_timestamps <= sound_time + 0.5);

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

        if is_laser_trial
            if (ismember(sound_time, right_sounds_evt07.Ts) && strcmp(first_lick_side, 'right')) || ...
               (ismember(sound_time, left_sounds_evt08.Ts) && strcmp(first_lick_side, 'left'))
                if strcmp(first_lick_side, 'right')
                    results.right_laser_reward = results.right_laser_reward + 1;
                else
                    results.left_laser_reward = results.left_laser_reward + 1;
                end
            elseif isempty(right_licks_in_window) && isempty(left_licks_in_window)
                if strcmp(first_lick_side, 'right')
                    results.right_laser_mistrial = results.right_laser_mistrial + 1;
                else
                    results.left_laser_mistrial = results.left_laser_mistrial + 1;
                end
            else
                if strcmp(first_lick_side, 'right')
                    results.right_laser_incorrect = results.right_laser_incorrect + 1;
                else
                    results.left_laser_incorrect = results.left_laser_incorrect + 1;
                end
            end
        else
            if (ismember(sound_time, right_sounds_evt07.Ts) && strcmp(first_lick_side, 'right')) || ...
               (ismember(sound_time, left_sounds_evt08.Ts) && strcmp(first_lick_side, 'left'))
                if strcmp(first_lick_side, 'right')
                    results.right_reward = results.right_reward + 1;
                else
                    results.left_reward = results.left_reward + 1;
                end
            elseif isempty(right_licks_in_window) && isempty(left_licks_in_window)
                if strcmp(first_lick_side, 'right')
                    results.right_mistrial = results.right_mistrial + 1;
                else
                    results.left_mistrial = results.left_mistrial + 1;
                end
            else
                if strcmp(first_lick_side, 'right')
                    results.right_incorrect = results.right_incorrect + 1;
                else
                    results.left_incorrect = results.left_incorrect + 1;
                end
            end
        end
    end
end