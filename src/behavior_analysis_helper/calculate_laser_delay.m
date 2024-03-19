function laserDelay = calculate_laser_delay(lasers, right_sounds, left_sounds)
    all_sounds = sort([right_sounds.Ts; left_sounds.Ts]);
    
    % vectors to store all laser delays
    delays = zeros(length(lasers.Ts), 1);
    
    % iterate through and caluclate delay for each laser event
    for i = 1:length(lasers.Ts)
        laser_ts = lasers.Ts(i);
        
        % closest proceding sound event
        sound_diffs = laser_ts - all_sounds;
        sound_diffs(sound_diffs > 0) = -inf; 
        [~, closestIdx] = max(sound_diffs);
        
        if ~isempty(closestIdx) && closestIdx > 0
            delays(i) = laser_ts - all_sounds(closestIdx);
        else
            % ignore if no sound event proceding laser
            delays(i) = NaN;
        end
    end
    
    % average delay, ignore NaNs
    laserDelay = mean(delays, 'omitnan');
end