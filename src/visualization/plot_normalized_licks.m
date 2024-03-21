function plot_normalized_licks(trialData, selectionCriteria)
    % cases for selectionCriteria
    switch selectionCriteria
        case 'all'
            selectedTrials = true(height(trialData), 1);
        case 'laser'
            selectedTrials = trialData.IsLaserTrial;
        case 'nonLaser'
            selectedTrials = ~trialData.IsLaserTrial;
        otherwise
            error('Invalid selectionCriteria');
    end

    leftLicks = [];
    rightLicks = [];

    % process the selected trials
    for i = find(selectedTrials)'
        % normalize and accumulate left lick timestamps
        if ~isempty(trialData.LeftLickingTimestamps{i})
            leftLicks = [leftLicks; trialData.LeftLickingTimestamps{i} - trialData.TimeStart(i), ...
                repmat(-0.5, length(trialData.LeftLickingTimestamps{i}), 1)];
        end
        if ~isempty(trialData.RightLickingTimestamps{i})
            rightLicks = [rightLicks; trialData.RightLickingTimestamps{i} - trialData.TimeStart(i), ...
                repmat(0.5, length(trialData.RightLickingTimestamps{i}), 1)];
        end
    end

    allLicks = [leftLicks; rightLicks];
    allLicks = sortrows(allLicks, 1);

    % plot the normalized licks
    figure;
    ylim([-1.5, 1.5]);
    scatter(allLicks(:, 1), allLicks(:, 2), 25, 'filled');
    yticks([-1,0,1]);
    yticklabels({'Left', 'None', 'Right'});
    xlabel('Time (s)');
    title('Normalized Licks');
end