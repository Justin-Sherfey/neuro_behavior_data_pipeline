function pl2_analysis_pipeline(pl2_filename)
    % extract data and save to .mat file
    extract_pl2_data(pl2_filename);
    
    % wait three seconds
    pause(3);
    
    [pathstr, name, ~] = fileparts(pl2_filename);
    matfile = fullfile(pathstr, [name '.mat']);

    % not correct, needs to be implemented with start_end
    %experiment_start_time = min(evt06.Ts);  
    %n = length(right_sounds_evt07.Ts) + length(left_sounds_evt08.Ts);  
    
    % plot lick behavior and save outfile
    %data = load(matfile);

    %behavior_analysis(data, matfile);

    %plot_lick_behavior(data, matfile);
    
    % metrics on licking, defaulted to whole file can adjust later
    %[right_lick_percentage, left_lick_percentage, total_right_licks, total_left_licks, right_correct_licks, left_correct_licks] = calculate_lick_metrics(data);
    
    % calculate rewards, mistrials, incorrects (Needs to be compared to
    % arduino
    %[rewards, mistrials, incorrects] = rmi(data);
    
    % calculate 

    % save results to out file
    %results_filename = fullfile('./output_data/', [name '_results.mat']);
    %save(results_filename, 'right_lick_percentage', 'left_lick_percentage', 'total_right_licks', 'total_left_licks', 'right_correct_licks', 'left_correct_licks', 'rewards', 'mistrials', 'incorrects');
    behavior_analysis(matfile);
end
