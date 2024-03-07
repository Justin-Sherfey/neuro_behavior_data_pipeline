% calculate the start and end time of the experiment
function [start_time, end_time] = calculate_start_end(evt06)
    ts_array = evt06.Ts;
    start_time = NaN;
    end_time = NaN;
    for i = 1:(length(ts_array) - 1)
        if ts_array(i+1) - ts_array(i) > 30
            start_time = ts_array(i);
            end_time = ts_array(i+1);
            break; 
        end
    end
end
