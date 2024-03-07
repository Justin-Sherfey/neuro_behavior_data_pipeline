function read_arduino(text_file)
    leftTrialCount = 0;
    rightTrialCount = 0;
    rewardDeliveryCount = 0;
    incorrectLickCount = 0;
    missTrialCount = 0;
    
    fid = fopen(text_file, 'r'); 
    
    if fid == -1
        error('File cannot be opened');
    end
    
    while ~feof(fid)
        line = fgetl(fid);
        if contains(line, 'LEFTTrial')
            leftTrialCount = leftTrialCount + 1;
        elseif contains(line, 'RIGHTTrial')
            rightTrialCount = rightTrialCount + 1;
        elseif contains(line, 'RewardDelivery')
            rewardDeliveryCount = rewardDeliveryCount + 1;
        elseif contains(line, 'IncorretLick') 
            incorrectLickCount = incorrectLickCount + 1;
        elseif contains(line, 'MissTrial')
            missTrialCount = missTrialCount + 1;
        end
    end
    
    fclose(fid);
    
    fprintf('Number of Left Trials: %d\n', leftTrialCount);
    fprintf('Number of Right Trials: %d\n', rightTrialCount);
    fprintf('Number of Reward Deliveries: %d\n', rewardDeliveryCount);
    fprintf('Number of Incorrect Licks: %d\n', incorrectLickCount);
    fprintf('Number of Miss Trials: %d\n', missTrialCount);
end
