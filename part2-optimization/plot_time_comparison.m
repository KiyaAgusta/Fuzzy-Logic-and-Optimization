function plot_time_comparison(results, dimensions, problem_names)
    % Function to plot computation time comparison
    
    % Define algorithms
    algorithms = {'PSO', 'GA', 'SA'};
    
    % For each dimension
    for d_idx = 1:length(dimensions)
        D = dimensions(d_idx);
        
        % Create a figure for this dimension
        figure('Name', ['Computation Time Comparison (D=' num2str(D) ')'], 'Position', [100, 100, 800, 600]);
        
        % Prepare data for the bar plot
        time_data = zeros(length(problem_names), length(algorithms));
        
        for p_idx = 1:length(problem_names)
            problem_name = problem_names{p_idx};
            
            % Get results for this problem and dimension
            results_struct = results.(problem_name).(sprintf('D%d', D));
            
            for a_idx = 1:length(algorithms)
                alg = algorithms{a_idx};
                time_data(p_idx, a_idx) = results_struct.(alg).avg_time;
            end
        end
        
        % Create a grouped bar chart
        bar(time_data);
        
        % Add labels and title
        xlabel('Problem');
        set(gca, 'XTickLabel', problem_names);
        ylabel('Average Time (seconds)');
        title(['Computation Time Comparison (D=' num2str(D) ')']);
        legend(algorithms, 'Location', 'best');
        grid on;
    end
end