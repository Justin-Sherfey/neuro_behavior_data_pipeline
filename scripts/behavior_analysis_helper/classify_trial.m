function trialResult = classify_trial(trialStartTime, rightSounds, leftSounds, rightLicks, leftLicks)
    % window in seconds to check for licks after the trial start
    checkWindow = 0.5; 

    % left or right sound
    if ismember(trialStartTime, rightSounds)
        trialType = 'right';
    elseif ismember(trialStartTime, leftSounds)
        trialType = 'left';
    else
        error('Trial start time not found in right or left sounds');
    end

    % find lick times within the window
    rightLicksInWindow = rightLicks(rightLicks > trialStartTime & rightLicks <= trialStartTime + checkWindow);
    leftLicksInWindow = leftLicks(leftLicks > trialStartTime & leftLicks <= trialStartTime + checkWindow);

    % classify trial based on first lick
    if strcmp(trialType, 'right')
        if isempty(rightLicksInWindow) && isempty(leftLicksInWindow)
            trialResult = 'mistrial';
        elseif ~isempty(rightLicksInWindow) && (isempty(leftLicksInWindow) || min(rightLicksInWindow) < min(leftLicksInWindow))
            trialResult = 'reward';
        else
            trialResult = 'incorrect';
        end
    elseif strcmp(trialType, 'left')
        if isempty(leftLicksInWindow) && isempty(rightLicksInWindow)
            trialResult = 'mistrial';
        elseif ~isempty(leftLicksInWindow) && (isempty(rightLicksInWindow) || min(leftLicksInWindow) < min(rightLicksInWindow))
            trialResult = 'reward';
        else
            trialResult = 'incorrect';
        end
    end
end
