% Main file

% Define parameters
dimensions = [2, 10, 50, 100];
num_runs = 15;
max_evaluations = 10000;

% Define search bounds for each function
bounds_F1 = [-100, 100];
bounds_F9 = [-5, 5];
bounds_F6 = [-100, 100];

% Initialize results storage
results = struct();

% For each dimension
for d_idx = 1:length(dimensions)
    D = dimensions(d_idx);
    
    % Define problem structure for each function
    problem_F1 = struct('objective', @(x) F1_ShiftedSphere(x), 'lb', bounds_F1(1)*ones(1,D), 'ub', bounds_F1(2)*ones(1,D), 'nvars', D);
    problem_F9 = struct('objective', @(x) F9_ShiftedRastrigin(x), 'lb', bounds_F9(1)*ones(1,D), 'ub', bounds_F9(2)*ones(1,D), 'nvars', D);
    problem_F6 = struct('objective', @(x) F6_ShiftedRosenbrock(x), 'lb', bounds_F6(1)*ones(1,D), 'ub', bounds_F6(2)*ones(1,D), 'nvars', D);
    
    % List of problems to solve
    problems = {problem_F1, problem_F9, problem_F6};
    problem_names = {'F1_Sphere', 'F9_Rastrigin', 'F6_Rosenbrock'};
    
    % Algorithm options
    options_pso = optimoptions('particleswarm', 'Display', 'off', 'MaxIterations', floor(max_evaluations/30), 'FunctionTolerance', 1e-6);
    options_ga = optimoptions('ga', 'Display', 'off', 'MaxGenerations', floor(max_evaluations/50), 'FunctionTolerance', 1e-6, 'PopulationSize', 50);
    options_sa = optimoptions('simulannealbnd', 'Display', 'off', 'MaxFunctionEvaluations', max_evaluations, 'FunctionTolerance', 1e-6);
    
    % For each problem
    for p_idx = 1:length(problems)
        problem = problems{p_idx};
        problem_name = problem_names{p_idx};
        
        fprintf('Dimension: %d, Problem: %s\n', D, problem_name);
        
        % Initialize results for this problem and dimension
        results.(problem_name).(sprintf('D%d', D)) = struct();
        
        % Run PSO
        fprintf('  Running PSO...\n');
        pso_best_vals = zeros(num_runs, 1);
        pso_times = zeros(num_runs, 1);
        
        for run = 1:num_runs
            tic;
            [~, fval] = particleswarm(problem.objective, problem.nvars, problem.lb, problem.ub, options_pso);
            pso_times(run) = toc;
            pso_best_vals(run) = fval;
        end
        
        results.(problem_name).(sprintf('D%d', D)).PSO = struct(...
            'best', min(pso_best_vals), ...
            'worst', max(pso_best_vals), ...
            'mean', mean(pso_best_vals), ...
            'std', std(pso_best_vals), ...
            'avg_time', mean(pso_times), ...
            'all_vals', pso_best_vals);
        
        % Run GA
        fprintf('  Running GA...\n');
        ga_best_vals = zeros(num_runs, 1);
        ga_times = zeros(num_runs, 1);
        
        for run = 1:num_runs
            tic;
            [~, fval] = ga(problem.objective, problem.nvars, [], [], [], [], problem.lb, problem.ub, [], options_ga);
            ga_times(run) = toc;
            ga_best_vals(run) = fval;
        end
        
        results.(problem_name).(sprintf('D%d', D)).GA = struct(...
            'best', min(ga_best_vals), ...
            'worst', max(ga_best_vals), ...
            'mean', mean(ga_best_vals), ...
            'std', std(ga_best_vals), ...
            'avg_time', mean(ga_times), ...
            'all_vals', ga_best_vals);
        
        % Run SA
        fprintf('  Running SA...\n');
        sa_best_vals = zeros(num_runs, 1);
        sa_times = zeros(num_runs, 1);
        
        for run = 1:num_runs
            % Initial point for SA (random point within bounds)
            x0 = problem.lb + (problem.ub - problem.lb) .* rand(1, problem.nvars);
            
            tic;
            [~, fval] = simulannealbnd(problem.objective, x0, problem.lb, problem.ub, options_sa);
            sa_times(run) = toc;
            sa_best_vals(run) = fval;
        end
        
        results.(problem_name).(sprintf('D%d', D)).SA = struct(...
            'best', min(sa_best_vals), ...
            'worst', max(sa_best_vals), ...
            'mean', mean(sa_best_vals), ...
            'std', std(sa_best_vals), ...
            'avg_time', mean(sa_times), ...
            'all_vals', sa_best_vals);
    end
end

% Display results
disp('Results Summary:');
for d_idx = 1:length(dimensions)
    D = dimensions(d_idx);
    disp(['===== Dimension: ' num2str(D) ' =====']);
    
    for p_idx = 1:length(problem_names)
        problem_name = problem_names{p_idx};
        disp(['Problem: ' problem_name]);
        
        % Get results for this problem and dimension
        results_struct = results.(problem_name).(sprintf('D%d', D));
        
        % Display results for each algorithm
        algorithms = {'PSO', 'GA', 'SA'};
        for a_idx = 1:length(algorithms)
            alg = algorithms{a_idx};
            disp(['  ' alg ':']);
            disp(['    Best: ' num2str(results_struct.(alg).best)]);
            disp(['    Worst: ' num2str(results_struct.(alg).worst)]);
            disp(['    Mean: ' num2str(results_struct.(alg).mean)]);
            disp(['    Std: ' num2str(results_struct.(alg).std)]);
            disp(['    Avg Time: ' num2str(results_struct.(alg).avg_time) ' seconds']);
        end
    end
end

% Save results to file
save('optimization_results.mat', 'results');

% Plot visualizations
plot_comparison_results(results, dimensions, problem_names);
plot_box_plots(results, dimensions, problem_names);
plot_dimensionality_analysis(results, dimensions, problem_names);
plot_time_comparison(results, dimensions, problem_names);