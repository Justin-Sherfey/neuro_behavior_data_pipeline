function behavior_analysis(matfile)
    % load data
    raw_data = load(matfile);
    
    % Call functions to extract analysis data
    rmi_results_struct = rmi(raw_data);
    behavior_results_struct = calculate_lick_metrics(raw_data);
    
    outputDir = './output_data/';

    [~, name, ~] = fileparts(matfile);
    filename = fullfile(outputDir, [name, '_analysis.mat']);

    % generate plot and save
    if ~exist('./graphs/', 'dir')
        mkdir('./graphs/');
    end
    filename_figure = fullfile('./graphs/', [name, '_figure.fig']);
    plot_lick_behavior(raw_data, filename_figure);

    rmi_results = rmi_results_struct;
    behavior_results = behavior_results_struct;

    % Save all outputs at once
    save(filename, 'rmi_results', 'behavior_results');
end

