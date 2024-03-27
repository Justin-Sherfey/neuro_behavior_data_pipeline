% DONE: Automate laser retrieval, would be existence of evt05, (evt05 - evt07/evt08)
% add as column
% Not all animal have laser

% DEBUG LASER DELAY, DEBUG UNEVEN RIGHT AND LEFT SIDES

% TODO: licking behavior graph average, average of all laser trials etc

% TODO: raster plot, visualization
% align all to zero, bar where laser is on
% dont have something to have when laser is off

% TODO: video synchronization scripts

% TODO: spike interface with recording data

% TODO: Modify pipeline to remove repeated logic
% TODO: Modify save file to be folder with experiment name in output folder with all related data in folder

% NOTES
% ai 01 - gavo mirror, should be -2 when off, 0 when on. How long galvo to test how long laser on, at 0
% ai 02 - piezo mirror, change angle using piezo effect, change intensity 

function pl2_analysis_pipeline(pl2_filename)
    % extract data and save to .mat file
    extract_pl2_data(pl2_filename);
    
    % wait three seconds
    pause(3);
    
    [pathstr, name, ~] = fileparts(pl2_filename);
    matfile = fullfile(pathstr, [name '.mat']);

    % analyze behavior
    behavior_analysis(matfile);

    fprintf('Creating Visualizations\n');
    %plot_raster('./' + name + '/');

end
