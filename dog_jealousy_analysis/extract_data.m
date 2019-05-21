function [stress_signals, interaction_with_owner, ...
            interaction_with_stranger, vocalizations, ...
            explore_room, look_at_object, interaction_with_object, ...
            chew, bite, orientation_to_door, attention_to_owner, ...
            attention_to_stranger, social_investigation, ...
            female_idx, male_idx] = extract_data(file_name)
        
%extract_data extracts data to behaviors' matrices.
% It accepts the CSV file name.
% It returns the times dogs spent on behaviors.

% Opens the csv file to read.
fid = fopen(file_name,'r') ;
if fid == -1
    error('Failed to open %s', filename);
end

% Initializes variables.
time_matrix = zeros(72, 74);
line_number = 0;
sex = {};

% Extracts data from csv file.
while ~feof(fid)
    line = fgets(fid);
    components = split(line,',');
    if isletter(components{1}) == 0
        sex = [sex, components{2}];
        for i = 7:length(components)
            time_matrix(line_number, i - 6) = str2double(components{i});
        end        
    end    
    line_number = line_number + 1;
end

% Closes the file.
if fclose(fid) == -1
    error('Failed to close study1.csv');
end
                        
% Gets indices for male and female.
male_idx = [];
female_idx = [];
for i = 1:length(sex)
    if strcmp(sex{i}, 'F')
        female_idx = [female_idx, i]
    elseif strcmp(sex{i}, 'M')
        male_idx = [male_idx, i]
    else
        error('% did not match any of the gender.', sex{i});
    end
end

% Gets the time spent on each behavior.
behaviors = {'stress_signals', 'interaction_with_owner', ...
            'interaction_with_stranger', 'vocalizations', 'explore_room', ...
            'look_at_object', 'interaction_with_object', 'chew', 'bite', ...
            'orientation_to_door'};

for behavior_index = 1:10
    eval(sprintf('%s = time_matrix(:, %d:%d)', ...
                    behaviors{behavior_index}, ...
                    behavior_index + 5 * (behavior_index - 1), ...
                    behavior_index + 5 * behavior_index));
end

attention_to_owner = time_matrix(:, 63:68);
attention_to_stranger = time_matrix(:, 69:74);
social_investigation = time_matrix(:, 61:62);

end