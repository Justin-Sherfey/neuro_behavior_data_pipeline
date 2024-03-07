% Automate laser retrieval, would be existence of evt05, (evt05 - evt07/evt08)
% add as column
% Not all animal have laser

% raster plot, visualization
% align all to zero, bar where laser is on
% dont have something to have when laser is off

% ai 01 - gavo mirror, should be -2 when off, 0 when on. How long galvo to test how long laser on, at 0
% ai 02 - piezo mirror, change angle using piezo effect, change intensity 

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
        
        % populate first lick latency, which is the time of the first lick after the sound
        trialData.FirstLickLatency(i) = min([right_licks_in_trial; left_licks_in_trial]) - current_sound_time;

        % populate number of licks, between current sound and next sound time
        trialData.NumLicks(i) = length(right_licks_in_trial) + length(left_licks_in_trial);

        % populate lick duration, which is the time between first and last lick in the trial, trial is over when next sound is played
        trialData.LickDuration(i) = max([right_licks_in_trial; left_licks_in_trial]) - min([right_licks_in_trial; left_licks_in_trial]);
    
        % populate right and left licking timestamps
        trialData.RightLickingTimestamps(i) = {right_licks_in_trial};
        trialData.LeftLickingTimestamps(i) = {left_licks_in_trial};

        % populate laser trial and lesay delay if defined
        if laser_delay > -1
            % is laser trial
            trialData.IsLaserTrial(i) = any(abs(raw_data.laser_on_evt05.Ts - current_sound_time) <= 0.5);

            % laser delay
            if trialData.IsLaserTrial(i)
                trialData.LaserDelay(i) = laser_delay;
            else
                trialData.LaserDelay(i) = NaN;
            end
        end
    end
    
    % save to mat file
    save('ProcessedTrialData.mat', 'trialData');

    fprintf('Processed %s\n', matfile);
end

