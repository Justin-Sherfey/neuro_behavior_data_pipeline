function behavior_analysis(matfile)
    % check if matfile exists
    if ~exist(matfile, 'file')
        fprintf('%s does not exist.\n', matfile);
        return;
    end

    % load data
    raw_data = load(matfile);
    fprintf('Starting analysis of data... \n');

    % Call functions to extract analysis data
    % can be refactored to use querying from behavior_table
    % May not be necessary any more
    behavior_results = calculate_lick_metrics(raw_data);

    % TODO - this is a placeholder, need to confirm with non laser delay values
    % in raw data, check if laser delay values (laser_on_evt05) are present, set to -1 if not
    if isempty(raw_data.laser_on_evt05.Ts)
        laser_delay = -1;
    else
        laser_delay = 1;
    end

    % TODO , need to fix, laser delay seems to be off (FIXED I think)
    fprintf('Laser delay found: %d \n', laser_delay);
    trial_data = behavior_table(matfile,laser_delay);
    rmi_results = rmi_new_test(trial_data);
    

    [~, name, ~] = fileparts(matfile);

    outputDir = ['./', name, '/'];

    if ~exist(outputDir, 'dir')
        mkdir(outputDir);
    end

    filename = fullfile(outputDir, [name, '_analysis.mat']);

    plot_lick_behavior(raw_data, name);

    % TODO - Add raster plot and other visualizations here

    % Save all outputs at once
    save(filename, 'rmi_results', 'behavior_results', 'trial_data');
    fprintf('Saved analysis results to %s \n', filename);
end

