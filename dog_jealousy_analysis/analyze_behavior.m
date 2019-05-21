function [gender_significance, mode_gender_significance] = analyze_behavior( ...
                                        behavior, female_idx, male_idx, ...
                                        female_color, male_color, phases)
% means_female_behavior analyzes the means of time spent on doing the
% behavior.
% It accepts the times dogs spent on the behavior, the female and male dogs
% index, the colors for female and male on the plot and the name of phases.
% It displays the times and their 95% confidence intervals on a graph.
% It returns the genders which spent the most of time on phases and the 
% gender which spent the most of time on the behavior.

% Calculates the means of time each gender spent on the behavior
% and their 95% confidence intervals.      
[means_female_behavior, female_conf_intervals] = cal_stats(behavior, ...
                                                            female_idx);
[means_male_behavior, male_conf_intervals] = cal_stats(behavior, ...
                                                            male_idx);

% Prints the means of time female dogs spent on the behavior.                                                    
disp('Means female behavior');
disp(phases);
disp(means_female_behavior);

% Prints the 95% confidence intervals.    
disp('Female confidence intervals');
disp(phases);
disp(female_conf_intervals);

% Prints the means of time male dogs spent on the behavior. 
disp('Means male behavior');
disp(phases);
disp(means_male_behavior);

% Prints the 95% confidence intervals.
disp('Male confidence intervals');
disp(phases);
disp(male_conf_intervals);

% Plots the means of time and their 95% confidence intervals.
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

% Sets label for the X Axis and the legend.
set(gca, 'XTick', 1:6, 'XTickLabel', phases);
legend('Female', 'Male');

% Compares the means of time between males and females
% and decides which gender spent the most of time
% on each phase of the behavior.
gender_significance = [];

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

% Decides which gender spent the most of time on the behavior
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

% Calculates the 95% confidence intervals.
conf_intervals = [];

for i = 1:size(gender_behavior, 2)
    s = std(gender_behavior(:,i));
    se = s/sqrt(length(gender_behavior(:,i)));
    t = tinv(1-0.025, length(gender_behavior(:,i)) -1);
    conf_intervals = [conf_intervals, t*se];
end

end

function plot_stats(value, color, line_style, legend_off)
% plot_stats plots the statistics on the graph.

% Defines the style.
style = sprintf('%s%s', line_style, color);

% Plots the data on the graph with the defined style.
p = plot(value, style);

% Not display the legend.
if legend_off
    set(get(get(p,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
end

end

function mode_string = find_mode(gender_significance)
% find_mode finds the gender which spent the most of time on the behavior.
% It accepts list of genders that spent the most of time on 6 phases.
% It returns the gender which spent the most of time on the behavior.

% Gets the distinct values (genders) from the parameter input list.
gender_significance_values = unique(gender_significance);

% Calculates the number of times each gender appears in the list of
% behavior.
frequency = [];
for i = 1:length(gender_significance_values)
    idx = strfind(gender_significance, gender_significance_values(i));
    idx = find(not(cellfun('isempty', idx)));
    frequency = [frequency, length(idx)];        
end

% Compares the number of times each gender appears in the list of
% behavior and selects the highest number of times.
max_frequency = max(frequency);

% Finds the gender which has that highest number of times.
index_mode = find(frequency == max_frequency);
mode_array = gender_significance_values(index_mode);

% In case there are 2 modes -> returns both of them (F, M).
mode_string = mode_array(1);
if length(mode_array) > 1
    for i = 2:length(mode_array)
        mode_string = strcat(mode_string,", ",mode_array(i));
    end
end

end