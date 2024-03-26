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
    
    figure; % Create a new figure for plotting
    hold on; % Hold on to plot multiple lines
    yticks([-0.5, 0.5]); % Set Y ticks for left and right licks
    yticklabels({'Left Lick', 'Right Lick'}); % Label Y ticks
    xlabel('Time (s)'); % Label X-axis
    title('Normalized Licks by Trial Type'); % Set title
    
    % Differentiate left and right sound trials
    for i = find(selectedTrials)'
        if trialData.TrialSide(i) == "Left"
            % For left sound trials, plot left licks in blue and right licks in red
            if ~isempty(trialData.LeftLickingTimestamps{i})
                plot(trialData.LeftLickingTimestamps{i} - trialData.TimeStart(i), repmat(-0.5, size(trialData.LeftLickingTimestamps{i})), 'b|');
            end
            if ~isempty(trialData.RightLickingTimestamps{i})
                plot(trialData.RightLickingTimestamps{i} - trialData.TimeStart(i), repmat(0.5, size(trialData.RightLickingTimestamps{i})), 'r|');
            end
        elseif trialData.TrialSide(i) == "Right"
            % For right sound trials, plot right licks in green and left licks in magenta
            if ~isempty(trialData.LeftLickingTimestamps{i})
                plot(trialData.LeftLickingTimestamps{i} - trialData.TimeStart(i), repmat(-0.5, size(trialData.LeftLickingTimestamps{i})), 'm|');
            end
            if ~isempty(trialData.RightLickingTimestamps{i})
                plot(trialData.RightLickingTimestamps{i} - trialData.TimeStart(i), repmat(0.5, size(trialData.RightLickingTimestamps{i})), 'g|');
            end
        end
    end
    
    legend({'Left Lick - Left Sound', 'Right Lick - Left Sound', 'Left Lick - Right Sound', 'Right Lick - Right Sound'}, 'Location', 'bestoutside');
    hold off; % Release the plot
end
