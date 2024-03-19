function behavior_analysis(matfile)
    % load data
    raw_data = load(matfile);
    
    % Call functions to extract analysis data
    % can be refactored to use querying from behavior_table
    rmi_results = rmi(raw_data);

    % May not be necessary any more
    behavior_results = calculate_lick_metrics(raw_data);

    % TODO - this is a placeholder, need to confirm with non laser delay values
    % in raw data, check if laser delay values (laser_on_evt05) are present, set to -1 if not
    if isempty(raw_data.laser_on_evt05.Ts)
        laser_delay = -1;
    else
        laser_delay = 1;
    end

    % TODO , need to fix, laser delay seems to be off
    fprintf('Laser delay found: %d \n', laser_delay);
    btable = behavior_table(matfile,laser_delay);
    
    outputDir = './output_data/';

    [~, name, ~] = fileparts(matfile);
    filename = fullfile(outputDir, [name, '_analysis.mat']);

    % generate plot and save
    if ~exist('./graphs/', 'dir')
        mkdir('./graphs/');
    end
    filename_figure = fullfile('./graphs/', [name, '_figure.fig']);
    plot_lick_behavior(raw_data, filename_figure);

    % TODO - Add raster plot and other visualizations here

    % Save all outputs at once
    save(filename, 'rmi_results', 'behavior_results', 'btable');
end

