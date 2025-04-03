function plot_comparison_results(results, dimensions, problem_names)
    % Function to plot the comparison results as bar charts
    
    % Define algorithms
    algorithms = {'PSO', 'GA', 'SA'};
    
    % For each dimension
    for d_idx = 1:length(dimensions)
        D = dimensions(d_idx);
        
        % Create a figure for this dimension
        figure('Name', ['Comparison in ' num2str(D) ' dimensions'], 'Position', [100, 100, 1200, 400]);
        
        % For each problem
        for p_idx = 1:length(problem_names)
            problem_name = problem_names{p_idx};
            
            % Get results for this problem and dimension
            results_struct = results.(problem_name).(sprintf('D%d', D));
            
            % Create a subplot for this problem
            subplot(1, length(problem_names), p_idx);
            
            % Prepare data for barplot
            mean_vals = zeros(1, length(algorithms));
            std_vals = zeros(1, length(algorithms));
            
            for a_idx = 1:length(algorithms)
                alg = algorithms{a_idx};
                mean_vals(a_idx) = results_struct.(alg).mean;
                std_vals(a_idx) = results_struct.(alg).std;
            end
            
            % Create a bar plot
            bar_handle = bar(mean_vals);
            title([problem_name ' (D=' num2str(D) ')']);
            set(gca, 'XTickLabel', algorithms);
            ylabel('Function Value');
            grid on;
            
            % Add error bars
            hold on;
            er = errorbar(1:length(algorithms), mean_vals, std_vals);
            er.Color = [0 0 0];
            er.LineStyle = 'none';
            hold off;
        end
        
        % Add a common legend
        sgtitle(['Algorithm Comparison in ' num2str(D) ' Dimensions']);
    end
end