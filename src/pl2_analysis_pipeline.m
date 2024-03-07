function pl2_analysis_pipeline(pl2_filename, laser_delay)
    % extract data and save to .mat file
    extract_pl2_data(pl2_filename);
    
    % wait three seconds
    pause(3);
    
    [pathstr, name, ~] = fileparts(pl2_filename);
    matfile = fullfile(pathstr, [name '.mat']);

    % analyze behavior
    % do not use laser delay if not provided
    if nargin < 2
        laser_delay = -1;
    end
    behavior_analysis(matfile, laser_delay);
end
