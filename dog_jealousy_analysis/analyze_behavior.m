function [gender_significance, mode_gender_significance] = analyze_behavior(behavior, female_idx, male_idx, ...
                                female_color, male_color, phases)
% means_female_behavior analyzes the means of time spent on doing the
% behavior.

% Calculates the means of time each gender spent on the behavior.      
[means_female_behavior, female_conf_intervals] = cal_stats(behavior, ...
                                                            female_idx);
[means_male_behavior, male_conf_intervals] = cal_stats(behavior, ...
                                                            male_idx);

disp('Means female behavior');
disp(phases);
disp(means_female_behavior);

disp('Female confidence intervals');
disp(phases);
disp(female_conf_intervals);

disp('Means male behavior');
disp(phases);
disp(means_male_behavior);

disp('Male confidence intervals');
disp(phases);
disp(male_conf_intervals);
% Plots the means of time.
plot_stats(means_female_behavior, female_color, '-', false);
hold on;
plot_stats(means_female_behavior + female_conf_intervals, female_color, ...
            '--', true);
hold on;
plot_stats(means_female_behavior - female_conf_intervals, female_color, ...
            '--', true);
hold on;
plot_stats(means_male_behavior, male_color, '-', false);
hold on;
plot_stats(means_male_behavior + male_conf_intervals, male_color, '--', ...
            true);
hold on;
plot_stats(means_male_behavior - male_conf_intervals, male_color, '--', ...
            true);

set(gca, 'XTick', 1:6, 'XTickLabel', phases);
legend('Female', 'Male');

gender_significance = [];
% Compares the means of time between males and females.
for i = 1:length(means_female_behavior)
    if means_female_behavior(i) > means_male_behavior(i)
        gender_significance = [gender_significance, "F"];
    elseif means_female_behavior(i) < means_male_behavior(i)
        gender_significance = [gender_significance, "M"];
    elseif means_female_behavior(i) == 0 && means_male_behavior(i) == 0
        gender_significance = [gender_significance, "-"];
    else
        gender_significance = [gender_significance, "E"];
    end

end

mode_gender_significance = find_mode(gender_significance);

end

function [means_gender_behavior, conf_intervals] = cal_stats(behavior,...
                                                                gender_idx)
% means_gender_behavior calculates the means of time each gender
% spent on the behavior.  

% Gets the matrix of times of the gender.
gender_behavior = behavior(gender_idx, :);

% Calculates the mean of the matrix -> means of each column
% which are the means of time spent on 6 phases.
means_gender_behavior = mean(gender_behavior);

conf_intervals = [];

for i = 1:size(gender_behavior, 2)
    s = std(gender_behavior(:,i));
    se = s/sqrt(length(gender_behavior(:,i)));
    t = tinv(1-0.025, length(gender_behavior(:,i)) -1);
    conf_intervals = [conf_intervals, t*se];
end

end

function plot_stats(value, color, line_style, legend_off)

style = sprintf('%s%s', line_style, color);

p = plot(value, style);

if legend_off
    set(get(get(p,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
end

end

function mode_string = find_mode(gender_significance)
    gender_significance_values = unique(gender_significance);
    frequency = [];
    for i = 1:length(gender_significance_values)
        idx = strfind(gender_significance, gender_significance_values(i));
        idx = find(not(cellfun('isempty', idx)));
        frequency = [frequency, length(idx)];        
    end
    
    max_frequency = max(frequency);
    index_mode = find(frequency == max_frequency);
    mode_array = gender_significance_values(index_mode);
    
    mode_string = mode_array(1);
    if length(mode_array) > 1
        for i = 2:length(mode_array)
            mode_string = strcat(mode_string,", ",mode_array(i));
        end
    end
end