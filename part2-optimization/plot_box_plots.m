function plot_box_plots(results, dimensions, problem_names)
    % Function to plot box plots showing the distribution of results
    
    % Define algorithms
    algorithms = {'PSO', 'GA', 'SA'};
    
    % For each dimension
    for d_idx = 1:length(dimensions)
        D = dimensions(d_idx);
        
        % Create a figure for this dimension
        figure('Name', ['Result Distributions (D=' num2str(D) ')'], 'Position', [100, 100, 1200, 800]);
        
        % For each problem
        for p_idx = 1:length(problem_names)
            problem_name = problem_names{p_idx};
            
            % Get results for this problem and dimension
            results_struct = results.(problem_name).(sprintf('D%d', D));
            
            % Create a subplot for this problem
            subplot(length(problem_names), 1, p_idx);
            
            % Prepare data for boxplot
            boxplot_data = [];
            group_labels = [];
            
            for a_idx = 1:length(algorithms)
                alg = algorithms{a_idx};
                boxplot_data = [boxplot_data; results_struct.(alg).all_vals];
                group_labels = [group_labels; repmat({alg}, length(results_struct.(alg).all_vals), 1)];
            end
            
            % Create a boxplot
            boxplot(boxplot_data, group_labels);
            title([problem_name ' (D=' num2str(D) ')']);
            ylabel('Function Value');
            grid on;
        end
        
        % Add overall title
        sgtitle(['Result Distributions in ' num2str(D) ' Dimensions']);
    end
end