% count licks and record timestamps 
function [licks_count, licks_timestamps] = extract_lick_timestamps(data, timestamps)
    licks_count = 0;
    licking = false;
    
    % preallocate array memory
    estimated_max_licks = ceil(length(data)/2);  
    licks_timestamps = NaN(estimated_max_licks, 1);  
    
    % iterate through the data and record the timestamps of the licks
    for i = 1:length(data)
        if data(i) > 4 && ~licking
            licking = true;
            licks_count = licks_count + 1; 
            licks_timestamps(licks_count) = timestamps(i);  
        elseif data(i) <= 4
            licking = false;
        end
    end
    
    % remove the unused preallocated space
    licks_timestamps = licks_timestamps(1:licks_count);
end