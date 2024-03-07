function [correct_lick_percentage, lick_before_delay_percentage, lick_after_delay_percentage] = lick_percentages(trialStartTime, trialEndTime, rightSounds, leftSounds, rightLicks, leftLicks, laserDelay)
    
    % check if laser delay is defined
    if nargin < 7
        laserDelay = -1;
    end

    % determine right or left trial
    if ismember(trialStartTime, rightSounds)
        correctLicks = rightLicks;
        incorrectLicks = leftLicks;
    elseif ismember(trialStartTime, leftSounds)
        correctLicks = leftLicks;
        incorrectLicks = rightLicks;
    else
        error('Trial start time does not match any right or left sound times.');
    end

    % filter for only trial licks
    correctLicksInTrial = correctLicks(correctLicks > trialStartTime & correctLicks <= trialEndTime);
    incorrectLicksInTrial = incorrectLicks(incorrectLicks > trialStartTime & incorrectLicks <= trialEndTime);
    numLicksTrial = length(correctLicksInTrial) + length(incorrectLicksInTrial);

    % Initialize percentages
    correct_lick_percentage = 0;
    lick_before_delay_percentage = 0;
    lick_after_delay_percentage = 0;

    if numLicksTrial > 0
        % percentage for total licks
        correct_lick_percentage = length(correctLicksInTrial) / numLicksTrial * 100;

        % percentage for laser delays
        if laserDelay > -1
            licksBeforeDelay = correctLicksInTrial(correctLicksInTrial <= trialStartTime + laserDelay);
            licksAfterDelay = correctLicksInTrial(correctLicksInTrial > trialStartTime + laserDelay);  
            totalLicksBeforeDelay = length(licksBeforeDelay) + length(incorrectLicksInTrial(incorrectLicksInTrial <= trialStartTime + laserDelay));
            totalLicksAfterDelay = length(licksAfterDelay) + length(incorrectLicksInTrial(incorrectLicksInTrial > trialStartTime + laserDelay));

            lick_before_delay_percentage = length(licksBeforeDelay) / totalLicksBeforeDelay * 100;
            lick_after_delay_percentage = length(licksAfterDelay) / totalLicksAfterDelay * 100;
        else
            lick_before_delay_percentage = NaN;
            lick_after_delay_percentage = NaN;
        end
    end
end
