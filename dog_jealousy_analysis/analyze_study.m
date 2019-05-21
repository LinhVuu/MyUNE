function analyze_study(file_name)
%analyze_study analyzes one csv file.
% It accepts the CSV file name.
% It displays the times dogs spent on behaviors,
% their 95% confidence intervals on graphs
% and builds a table to represent the gender which spent more time
% on the behavior in each phase and the mode of each behavior
% to see which gender spent more time on the behavior.

% Extracts data from the csv file.
[stress_signals, interaction_with_owner, ...
    interaction_with_stranger, vocalizations, ...
    explore_room, look_at_object, interaction_with_object, ...
    chew, bite, orientation_to_door, attention_to_owner, ...
    attention_to_stranger, social_investigation, ...
    female_idx, male_idx] = extract_data(file_name);

% Initializes the list of six phases.
six_phases = {'BOW', 'BSTR', 'FDOW', 'FDSTR', 'POW', 'PSTR'};

% Initializes other variables.
gender_significance_matrix = [];
gender_mode = [];

% Analyzes and plots the means of each behavior on the graphs.

% Attention to owner and stranger.
subplot(3, 4, 1);

disp('Attention to owner \n');
[gender_significance, mode] = analyze_behavior(attention_to_owner, ...
                            female_idx, male_idx, 'm', 'b', six_phases);
gender_significance_matrix = [gender_significance_matrix; ...
                                                    gender_significance];
gender_mode = [gender_mode; mode];
hold on;

disp('Attention to stranger \n');
[gender_significance, mode] = analyze_behavior(attention_to_stranger, ...
                                female_idx, male_idx, 'r', 'k', six_phases);
gender_significance_matrix = [gender_significance_matrix; ...
                                                    gender_significance];
gender_mode = [gender_mode; mode];
legend('Female - Attention to owner', 'Male - Attention to owner', ...
       'Female - Attention to stranger', 'Male - Attention to stranger');
title('Attention to owner and stranger');

% Interaction with owner and stranger.
subplot(3, 4, 2);

disp('Interaction with owner \n');
[gender_significance, mode] = analyze_behavior(interaction_with_owner, ...
                            female_idx, male_idx, 'm', 'b', six_phases);
gender_significance_matrix = [gender_significance_matrix; ...
                                                    gender_significance];
gender_mode = [gender_mode; mode];
hold on;

disp('Interaction with stranger \n');
[gender_significance, mode] = analyze_behavior(interaction_with_stranger, ...
                            female_idx, male_idx, 'r', 'k', six_phases);
gender_significance_matrix = [gender_significance_matrix; ...
                                                    gender_significance];
gender_mode = [gender_mode; mode];
legend('Female - Interaction with owner', 'Male - Interaction with owner', ...
       'Female - Interaction with stranger', 'Male - Interaction with stranger');
title('Interaction with owner and stranger');


% Social investigation.
two_phases = {'FDOW', 'FDSTR'};
subplot(3, 4, 3);
disp('Social investigation \n');
[gender_significance_two_phases, mode] = analyze_behavior(social_investigation, ...
                                    female_idx, male_idx, 'm', 'b', ...
                                    two_phases);
gender_significance_six_phases = {'-', '-', ...
                            gender_significance_two_phases{1},...
                            gender_significance_two_phases{2}, '-', '-'};
gender_significance_matrix = [gender_significance_matrix; ...
                                gender_significance_six_phases];
gender_mode = [gender_mode; mode];
title('Social investigation');

% Other behaviors.
behaviors = {'stress_signals', 'vocalizations', 'explore_room', ...
            'look_at_object', 'interaction_with_object', 'chew', ...
            'bite', 'orientation_to_door'};

titles = {'Stress signals', 'Vocalizations', 'Explore room', ...
    'Look at object', 'Interaction with object', 'Chew', ...
    'Bite', 'Orientation to door'};

for behavior_index = 1:8
    eval(sprintf('subplot(3, 4, %d)', behavior_index + 3));
    fprintf('%s \n', titles{behavior_index});
    [gender_significance, mode] = eval(sprintf(['analyze_behavior(%s, ', ...
                    'female_idx, male_idx, ''m'', ''b'', six_phases)'], ...
                                                behaviors{behavior_index}));
    gender_significance_matrix = [gender_significance_matrix; ...
                                                    gender_significance];
    gender_mode = [gender_mode; mode];
    eval(sprintf('title(''%s'')', titles{behavior_index}));
end

% Creates a table to compare the means of time between males and females.
bow = gender_significance_matrix(:, 1);
bstr = gender_significance_matrix(:, 2);
fdow = gender_significance_matrix(:, 3);
fdstr = gender_significance_matrix(:, 4);
pow = gender_significance_matrix(:, 5);
pstr = gender_significance_matrix(:, 6);

row_names = {'Attention to owner'; 'Attention to stranger'; ...
    'Interaction with owner'; 'Interaction with stranger'; ...
    'Social investigation'; 'Stress signals'; 'Vocalizations'; ...
    'Explore room'; 'Look at object'; 'Interaction with object'; ...
    'Chew'; 'Bite'; 'Orientation to door'};
gender_significance_table = table(categorical(bow), categorical(bstr), ...
            categorical(fdow), categorical(fdstr), categorical(pow), ...
            categorical(pstr), categorical(gender_mode), ...
            'VariableNames', [six_phases, 'Mode'], ...
            'RowNames', row_names);

% Displays the table that shows which gender spent 
% the most of time on each behavior
disp(gender_significance_table);

end