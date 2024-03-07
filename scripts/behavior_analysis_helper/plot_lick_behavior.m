function plot_lick_behavior(data, filename)
    % load data from extracted files
    right_sounds_evt07 = data.right_sounds_evt07;
    left_sounds_evt08 = data.left_sounds_evt08;
    right_licks_timestamps = data.right_licks_timestamps;
    left_licks_timestamps = data.left_licks_timestamps;
    experiment_start_time = data.start_time;
    experiment_end_time = data.end_time;

    % filter licks to experiment window
    right_licks_time = right_licks_timestamps(right_licks_timestamps >= experiment_start_time & right_licks_timestamps <= experiment_end_time);
    right_lick_sounds = right_sounds_evt07.Ts(right_sounds_evt07.Ts >= experiment_start_time & right_sounds_evt07.Ts <= experiment_end_time);
    left_licks_time = left_licks_timestamps(left_licks_timestamps >= experiment_start_time & left_licks_timestamps <= experiment_end_time);
    left_lick_sounds = left_sounds_evt08.Ts(left_sounds_evt08.Ts >= experiment_start_time & left_sounds_evt08.Ts <= experiment_end_time);
    
    figure;
    hold on;
    title('Lick Behavior Analysis');
    xlabel('Time (s)');
    ylabel('Event Type');

    orange = [1, 0.5, 0]; 
    purple = [0.5, 0, 0.5]; 
    blue = [0, 0, 1]; 
    red = [1, 0, 0]; 
    
    scatter(right_licks_time, ones(size(right_licks_time)), 50, 'o', 'MarkerEdgeColor', orange, 'MarkerFaceColor', orange); % Right Licks as orange circles
    scatter(left_licks_time, ones(size(left_licks_time)), 50, 'o', 'MarkerEdgeColor', purple, 'MarkerFaceColor', purple); % Left Licks as blue circles
    scatter(right_lick_sounds, ones(size(right_lick_sounds)), 50, 'v', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', red); % Right Sounds as red triangles with black border
    scatter(left_lick_sounds, ones(size(left_lick_sounds)), 50, 'v', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', blue); % Left Sounds as purple stars

    yticks([]);
    xlim([experiment_start_time, experiment_end_time]);
    legend('Right Licks','Left Licks','Right Sounds', 'Left Sounds');
    hold off;

    outputDir = './graphs/';
    [~, name, ~] = fileparts(filename);
    savefig(fullfile(outputDir, [name '.fig']));
end
