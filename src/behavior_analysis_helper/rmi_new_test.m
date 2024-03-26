% calculate rewards, incorrects, and mistrials for laser/no-laser trials
function resultsTable = rmi_new_test(trialData)
    % 5 x 7 matrix, 4 categories + total, 3 columns for percentages, 4 columns for counts
    categories = {'LeftNoLaser', 'RightNoLaser', 'LeftLaser', 'RightLaser'};
    results = zeros(length(categories), 7);

    % indices for results matrix
    TOTAL_IDX = 4; REWARD_IDX = 5; INCORRECT_IDX = 6; MISTRIAL_IDX = 7;

    % iterate through each trial and categorize by LEFT/RIGHT and LASER/NO-LASER in categoryIndex
    for i = 1:height(trialData)
        if trialData.TrialSide(i) == "Left" && ~trialData.IsLaserTrial(i)
            categoryIndex = 1;
        elseif trialData.TrialSide(i) == "Right" && ~trialData.IsLaserTrial(i)
            categoryIndex = 2;
        elseif trialData.TrialSide(i) == "Left" && trialData.IsLaserTrial(i)
            categoryIndex = 3;
        elseif trialData.TrialSide(i) == "Right" && trialData.IsLaserTrial(i)
            categoryIndex = 4;
        end

        % increment total count
        results(categoryIndex, TOTAL_IDX) = results(categoryIndex, TOTAL_IDX) + 1;

        % categorize trial by RMI
        switch trialData.RMI(i)
            case "reward"
                results(categoryIndex, REWARD_IDX) = results(categoryIndex, REWARD_IDX) + 1;
            case "incorrect"
                results(categoryIndex, INCORRECT_IDX) = results(categoryIndex, INCORRECT_IDX) + 1;
            case "mistrial"
                results(categoryIndex, MISTRIAL_IDX) = results(categoryIndex, MISTRIAL_IDX) + 1;
        end
    end

    % calculate percentages for all categories
    for i = 1:length(categories)
        totalTrials = results(i, TOTAL_IDX);
        if totalTrials > 0
            results(i, 1) = (results(i, REWARD_IDX) / totalTrials) * 100;
            results(i, 2) = (results(i, INCORRECT_IDX) / totalTrials) * 100;
            results(i, 3) = (results(i, MISTRIAL_IDX) / totalTrials) * 100;
        end
    end

    % calculate total percentages and counts
    totalOverallTrials = sum(results(:, TOTAL_IDX));
    if totalOverallTrials > 0
        results(5, TOTAL_IDX) = totalOverallTrials;
        results(5, REWARD_IDX) = sum(results(:, REWARD_IDX));
        results(5, INCORRECT_IDX) = sum(results(:, INCORRECT_IDX));
        results(5, MISTRIAL_IDX) = sum(results(:, MISTRIAL_IDX));

        results(5, 1) = (results(5, REWARD_IDX) / totalOverallTrials) * 100;
        results(5, 2) = (results(5, INCORRECT_IDX) / totalOverallTrials) * 100;
        results(5, 3) = (results(5, MISTRIAL_IDX) / totalOverallTrials) * 100;

    end

    % create table with results
    categoriesWithTotal = [categories, {'Total'}];
    resultsTable = array2table(results, ...
        'VariableNames', {'PercentageReward', 'PercentageIncorrect', 'PercentageMistrial', 'Total', 'Reward', 'Incorrect', 'Mistrial'}, ...
        'RowNames', categoriesWithTotal);
end
