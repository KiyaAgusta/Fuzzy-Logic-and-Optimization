function plot_dimensionality_analysis(results, dimensions, problem_names)
    % Function to plot how performance scales with dimension
    
    % Define algorithms
    algorithms = {'PSO', 'GA', 'SA'};
    alg_colors = {'b', 'r', 'g'};
    alg_markers = {'o', 's', 'd'};
    
    % For each problem
    for p_idx = 1:length(problem_names)
        problem_name = problem_names{p_idx};
        
        % Create a figure for this problem
        figure('Name', ['Dimensionality Analysis: ' problem_name], 'Position', [100, 100, 900, 700]);
        
        % Create subplots for different metrics
        subplot(2, 2, 1); % Best value vs dimension
        hold on;
        title(['Best Value vs. Dimension for ' problem_name]);
        xlabel('Dimension');
        ylabel('Best Function Value');
        grid on;
        
        subplot(2, 2, 2); % Mean value vs dimension
        hold on;
        title(['Mean Value vs. Dimension for ' problem_name]);
        xlabel('Dimension');
        ylabel('Mean Function Value');
        grid on;
        
        subplot(2, 2, 3); % Std deviation vs dimension
        hold on;
        title(['Std Deviation vs. Dimension for ' problem_name]);
        xlabel('Dimension');
        ylabel('Standard Deviation');
        grid on;
        
        subplot(2, 2, 4); % Computation time vs dimension
        hold on;
        title(['Computation Time vs. Dimension for ' problem_name]);
        xlabel('Dimension');
        ylabel('Average Time (seconds)');
        grid on;
        
        % For each algorithm
        for a_idx = 1:length(algorithms)
            alg = algorithms{a_idx};
            
            % Collect data across dimensions
            best_vals = zeros(1, length(dimensions));
            mean_vals = zeros(1, length(dimensions));
            std_vals = zeros(1, length(dimensions));
            time_vals = zeros(1, length(dimensions));
            
            for d_idx = 1:length(dimensions)
                D = dimensions(d_idx);
                field_name = sprintf('D%d', D);
                
                % Get results for this problem, dimension, and algorithm
                results_struct = results.(problem_name).(field_name).(alg);
                
                best_vals(d_idx) = results_struct.best;
                mean_vals(d_idx) = results_struct.mean;
                std_vals(d_idx) = results_struct.std;
                time_vals(d_idx) = results_struct.avg_time;
            end
            
            % Plot data in each subplot
            subplot(2, 2, 1);
            plot(dimensions, best_vals, [alg_colors{a_idx}, '-', alg_markers{a_idx}], 'LineWidth', 2, 'MarkerSize', 8);
            
            subplot(2, 2, 2);
            plot(dimensions, mean_vals, [alg_colors{a_idx}, '-', alg_markers{a_idx}], 'LineWidth', 2, 'MarkerSize', 8);
            
            subplot(2, 2, 3);
            plot(dimensions, std_vals, [alg_colors{a_idx}, '-', alg_markers{a_idx}], 'LineWidth', 2, 'MarkerSize', 8);
            
            subplot(2, 2, 4);
            plot(dimensions, time_vals, [alg_colors{a_idx}, '-', alg_markers{a_idx}], 'LineWidth', 2, 'MarkerSize', 8);
        end
        
        % Add legend to each subplot
        for i = 1:4
            subplot(2, 2, i);
            legend(algorithms, 'Location', 'best');
        end
    end
end