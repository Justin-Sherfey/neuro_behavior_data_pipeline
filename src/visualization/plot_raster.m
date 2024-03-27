% Parameters 
% directoryPath: path to the directory containing the analysis files
% plot_raster: plots the raster for the given directory
function plot_raster(directoryPath)

    % check if the directory path is valid
    if ~isfolder(directoryPath)
        error('Invalid directory path');
    end

    % fetch all analysis files in the directory
    analysisFiles = dir(fullfile(directoryPath, '*_analysis.mat'));
    
    % arrays for storing trial data
    allLaserLeft = [];
    allLaserRight = [];
    allNonLaserLeft = [];
    allNonLaserRight = [];
    
    % loop through all files and pull trial data
    for i = 1:length(analysisFiles)
        dataPath = fullfile(analysisFiles(i).folder, analysisFiles(i).name);
        loadedData = load(dataPath);
        trialData = loadedData.trial_data; 
        laserTrials = trialData(trialData.IsLaserTrial, :);
        nonLaserTrials = trialData(~trialData.IsLaserTrial, :);
        
        % appends trials to appropriate arrays
        allLaserLeft = [allLaserLeft; laserTrials(laserTrials.TrialSide == "Left", :)];
        allLaserRight = [allLaserRight; laserTrials(laserTrials.TrialSide == "Right", :)];
        allNonLaserLeft = [allNonLaserLeft; nonLaserTrials(nonLaserTrials.TrialSide == "Left", :)];
        allNonLaserRight = [allNonLaserRight; nonLaserTrials(nonLaserTrials.TrialSide == "Right", :)];
    end
    
    % plot raster
    figure('Position', [100, 100, 1200, 800]);    
    subplot(2, 2, 1);
    plotTrials(allLaserLeft, 'Left Laser Trials');
    subplot(2, 2, 2);
    plotTrials(allLaserRight, 'Right Laser Trials');
    subplot(2, 2, 3);
    plotTrials(allNonLaserLeft, 'Left Non-Laser Trials');
    subplot(2, 2, 4);
    plotTrials(allNonLaserRight, 'Right Non-Laser Trials');
end

% plots the raster for the given trials
function plotTrials(trials, titleText)
    hold on;
    title(titleText);
    xlabel('Time (ms)');
    ylabel('Trial Number');
    xlim([0, 2000]); % change x axis limits if needed
    ylim([0.5, height(trials)+2]);

    for i = 1:height(trials)
        scatterLicks(trials.TimeStart(i), trials.LeftLickingTimestamps{i}, i, 'b');
        scatterLicks(trials.TimeStart(i), trials.RightLickingTimestamps{i}, i, 'r');
    end
    hold off;
end

% scatter licks on the raster plot
function scatterLicks(trialStartTime, lickTimes, trialNumber, color)
    if ~isempty(lickTimes)
        normalizedLickTimes = (lickTimes - trialStartTime) * 1000;
        y = repmat(trialNumber, length(normalizedLickTimes), 1);
        scatter(normalizedLickTimes, y, 10, color, 'filled');
    end
end
