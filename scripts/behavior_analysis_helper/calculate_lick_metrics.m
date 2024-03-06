function results = calculate_lick_metrics(data)
    % extract data from matfile
    right_sounds_evt07 = data.right_sounds_evt07;
    left_sounds_evt08 = data.left_sounds_evt08;
    laser_trials_evt05 = data.laser_on_evt05; 
    right_licks_timestamps = data.right_licks_timestamps;
    left_licks_timestamps = data.left_licks_timestamps;
    end_time = data.end_time;

    % initialize starting variables
    counts = struct('total_right', 0, 'total_left', 0, 'correct_right', 0, 'correct_left', 0, ...
                    'laser_total_right', 0, 'laser_total_left', 0, 'laser_correct_right', 0, 'laser_correct_left', 0);

    all_sounds = sort([right_sounds_evt07.Ts; left_sounds_evt08.Ts]);

    for i = 1:length(all_sounds)
        current_sound_time = all_sounds(i);
        
        if i < length(all_sounds)
            next_sound_time = all_sounds(i + 1);
        else
            next_sound_time = end_time; 
        end

        % determine laser trial, connected to other trial by half a second
        is_laser_trial = any(abs(laser_trials_evt05.Ts - current_sound_time) <= 0.5);

        right_licks = right_licks_timestamps(right_licks_timestamps > current_sound_time & right_licks_timestamps < next_sound_time);
        left_licks = left_licks_timestamps(left_licks_timestamps > current_sound_time & left_licks_timestamps < next_sound_time);

        % count total licks
        if ismember(current_sound_time, right_sounds_evt07.Ts)
            if is_laser_trial
                counts.laser_total_right = counts.laser_total_right + length(right_licks);
                counts.laser_correct_right = counts.laser_correct_right + length(right_licks); 
                counts.laser_total_left = counts.laser_total_left + length(left_licks);
            else
                counts.total_right = counts.total_right + length(right_licks);
                counts.correct_right = counts.correct_right + length(right_licks); 
                counts.total_left = counts.total_left + length(left_licks);
            end
        elseif ismember(current_sound_time, left_sounds_evt08.Ts)
            if is_laser_trial
                counts.laser_total_left = counts.laser_total_left + length(left_licks);
                counts.laser_correct_left = counts.laser_correct_left + length(left_licks); 
                counts.laser_total_right = counts.laser_total_right + length(right_licks);
            else
                counts.total_left = counts.total_left + length(left_licks);
                counts.correct_left = counts.correct_left + length(left_licks);
                counts.total_right = counts.total_right + length(right_licks);
            end
        end
    end

    % calculate lick percentages
    if counts.total_right > 0
        counts.right_lick_percentage = (counts.correct_right / counts.total_right) * 100;
    else
        counts.right_lick_percentage = 0;
    end

    if counts.total_left > 0
        counts.left_lick_percentage = (counts.correct_left / counts.total_left) * 100;
    else
        counts.left_lick_percentage = 0;
    end

    if counts.laser_total_right > 0
        counts.laser_right_lick_percentage = (counts.laser_correct_right / counts.laser_total_right) * 100;
    else
        counts.laser_right_lick_percentage = 0;
    end

    if counts.laser_total_left > 0
        counts.laser_left_lick_percentage = (counts.laser_correct_left / counts.laser_total_left) * 100;
    else
        counts.laser_left_lick_percentage = 0;
    end

    results = counts; 
end