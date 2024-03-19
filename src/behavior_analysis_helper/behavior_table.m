function trialData = behavior_table(matfile, laser_delay)
    
    fprintf('Processing %s\n', matfile);

    % load data
    raw_data = load(matfile);

    % check if laser
    if nargin < 2
        laser_delay = -1;
    end

    % initialiize table
    numTrials = length(raw_data.right_sounds_evt07.Ts) + length(raw_data.left_sounds_evt08.Ts);
    trialData = table('Size', [numTrials, 15], ...
        'VariableTypes', {'int32', 'categorical', 'logical', 'double', 'categorical', ...
                          'double', 'double', 'double', 'double', 'double', 'double', ...
                          'double','double','cell', 'cell'}, ...
        'VariableNames', {'TrialNumber', 'TrialSide', 'IsLaserTrial', 'LaserDelay', 'RMI', ...
                          'TimeStart', 'TimeEnd', 'CorrectLickPercentage', 'CorrectLickBefore', ...
                          'CorrectLickAfter', 'FirstLickLatency', 'NumLicks', 'LickDuration', 'RightLickingTimestamps', ...
                          'LeftLickingTimestamps'});
    
    % sort all sounds
    trial_sounds = sort([raw_data.right_sounds_evt07.Ts; raw_data.left_sounds_evt08.Ts]);

    % populate table
    for i = 1:numTrials
        % populate trial number
        trialData.TrialNumber(i) = i;
        
        % trial start and end time
        current_sound_time = trial_sounds(i);
        next_sound_time = raw_data.end_time;

        if i < length(trial_sounds)
            next_sound_time = trial_sounds(i + 1);
        end

        trialData.TimeStart(i) = current_sound_time;
        trialData.TimeEnd(i) = next_sound_time;

        % right or left trial
        if ismember(current_sound_time, raw_data.right_sounds_evt07.Ts)
            trialData.TrialSide(i) = 'Right';
        else
            trialData.TrialSide(i) = 'Left';
        end

        % populate RMI
        trialData.RMI(i) = classify_trial(current_sound_time, raw_data.right_sounds_evt07.Ts, ...
            raw_data.left_sounds_evt08.Ts, raw_data.right_licks_timestamps, raw_data.left_licks_timestamps);

        % populate correct lick percentage
        [trialData.CorrectLickPercentage(i), trialData.CorrectLickBefore(i), trialData.CorrectLickAfter(i)] = lick_percentages(current_sound_time, ...
            next_sound_time, raw_data.right_sounds_evt07.Ts, raw_data.left_sounds_evt08.Ts, ...
            raw_data.right_licks_timestamps, raw_data.left_licks_timestamps, laser_delay);

        % licks in trial
        right_licks_in_trial = raw_data.right_licks_timestamps(raw_data.right_licks_timestamps > current_sound_time & ...
            raw_data.right_licks_timestamps < next_sound_time);
        left_licks_in_trial = raw_data.left_licks_timestamps(raw_data.left_licks_timestamps > current_sound_time & ...
            raw_data.left_licks_timestamps < next_sound_time);
        
        
        combined_licks_in_trial = [right_licks_in_trial; left_licks_in_trial];

        % populate first lick latency and lick duration
        if isempty(combined_licks_in_trial)
            trialData.FirstLickLatency(i) = NaN;
            trialData.LickDuration(i) = NaN;
        else
            firstLickTime = min(combined_licks_in_trial);
            lastLickTime = max(combined_licks_in_trial);
            trialData.FirstLickLatency(i) = firstLickTime - current_sound_time;
            trialData.LickDuration(i) = lastLickTime - firstLickTime;
        end

        % populate number of licks, between current sound and next sound time
        trialData.NumLicks(i) = length(right_licks_in_trial) + length(left_licks_in_trial);

        trialData.LickDuration(i) = max([right_licks_in_trial; left_licks_in_trial]) - min([right_licks_in_trial; left_licks_in_trial]);
    
        % populate right and left licking timestamps
        trialData.RightLickingTimestamps(i) = {right_licks_in_trial};
        trialData.LeftLickingTimestamps(i) = {left_licks_in_trial};

        % populate laser trial and lesay delay if defined
        if laser_delay > -1
            % Find the valid laser delay for this trial
            laserDifferences = raw_data.laser_on_evt05.Ts - current_sound_time;
            validLaserDifferences = laserDifferences(laserDifferences > 0 & laserDifferences <= 0.5);
            trialData.IsLaserTrial(i) = ~isempty(validLaserDifferences);
        
            % minimum delay
            if trialData.IsLaserTrial(i)
                trialData.LaserDelay(i) = min(validLaserDifferences);
            else
                trialData.LaserDelay(i) = NaN;
            end
        else
            trialData.IsLaserTrial(i) = false;
            trialData.LaserDelay(i) = NaN;
        end
    end
    
    % save to mat file
    save('ProcessedTrialData.mat', 'trialData');

    fprintf('Processed %s\n', matfile);
end

