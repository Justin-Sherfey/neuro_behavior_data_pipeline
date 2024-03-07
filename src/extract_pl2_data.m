% Extract pl2 data and
function extract_pl2_data(filename)
    fprintf('Starting extraction of PL2 Data\n');
    % event data (EVT06, EVT07, EVT08)
    laser_on_evt05 = PL2EventTs(filename, 'EVT05'); % laser on
    evt06 = PL2EventTs(filename, 'EVT06'); % start and end time
    right_sounds_evt07 = PL2EventTs(filename, 'EVT07'); % evt07
    left_sounds_evt08 = PL2EventTs(filename, 'EVT08'); % evt08

    % calculate start and end time of each trial
    [start_time, end_time] = calculate_start_end(evt06);
    
    % right licks data (Channel 3)
    ad_ai03 = PL2Ad(filename, 'AI03');
    timestamps_ai03 = (0:(length(ad_ai03.Values)-1))' / ad_ai03.ADFreq;
    right_lick_data_ai03 = [timestamps_ai03, ad_ai03.Values];
    [right_licks_count, right_licks_timestamps] = extract_lick_timestamps(ad_ai03.Values, timestamps_ai03);

    % left licks data (Channel 4)
    ad_ai04 = PL2Ad(filename, 'AI04');
    timestamps_ai04 = (0:(length(ad_ai04.Values)-1))' / ad_ai04.ADFreq;
    left_lick_data_ai04 = [timestamps_ai04, ad_ai04.Values];
    [left_licks_count, left_licks_timestamps] = extract_lick_timestamps(ad_ai04.Values, timestamps_ai04);

    % extract data from ai05 channel
    ad_ai05 = PL2Ad(filename, 'AI05');
    timestamps_ai05 = (0:(length(ad_ai05.Values)-1))' / ad_ai05.ADFreq;
    camera_data_ai05 = [timestamps_ai05, ad_ai05.Values];

    % save counts to a counts struct
    lick_counts = struct('right_licks_count', right_licks_count, 'left_licks_count', left_licks_count);

    outputDir = './output_data/raw_data/';
    if ~exist(outputDir, 'dir')
        mkdir(outputDir);
    end

    % save to raw data .mat file
    [~,name,~] = fileparts(filename);
    outputFilename = fullfile(outputDir, [name, '.mat']);
    save(outputFilename, 'laser_on_evt05', 'evt06', 'right_sounds_evt07', 'left_sounds_evt08', 'right_lick_data_ai03', ...
        'left_lick_data_ai04', "camera_data_ai05", "right_licks_timestamps", "lick_counts", ...
        "left_licks_timestamps", "start_time", "end_time");

    fprintf('PL2 data extracted and file and saved successfully\n');
end

