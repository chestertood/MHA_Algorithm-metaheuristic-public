clc
bounds = [-10 10; -10 10]; % Specify the search space
max_iter = 30;         % Set the number of iterations
fitnessFunc = @(x) sum(x.^2,2); % Define a fitness function (e.g., Sphere function)
SearchAgents_no = 30; 
Max_iter = 30; 
lb = -10; 
ub = 10; 
dim = 2;

% Objective Function (e.g., Sphere Function)
objective = @(x) sum(x.^2);

% Bounds of Variables
lower_bounds = -10;
upper_bounds = 10;
x_bounds = [lower_bounds; upper_bounds];

% GA Parameters
num_chromosomes = 50;     % Population size
num_generations = 30;    % Number of generations
mutation_rate = 0.1;      % Probability of mutation

% Run Genetic Algorithm

nVar = 5;                     % Number of Decision Variables
VarMin = -10;                 % Lower Bound of Variables
VarMax = 10;                  % Upper Bound of Variables

% ABC Parameters
MaxIt = 30;    % Maximum Number of Iterations
nPop = 50;     % Population Size




% Call the MonsterHunterOptimization_OFF function
[Gbest, best_fitness, max_iter, convergence] = MHO_code(lb, ub,dim, max_iter, fitnessFunc);

[gbest_value,fitness_history_PSO] = PSO(lb, ub, max_iter, fitnessFunc,dim);

[Alpha_score, Alpha_pos, Convergence_curve] = GWO(SearchAgents_no, Max_iter, lb, ub, dim,fitnessFunc);

[best_solution, best_fitness_GA,num_generations, best_fitness_history] = GA(fitnessFunc, lb, ub,dim, num_chromosomes, num_generations, mutation_rate);

[BestSol, BestCost] = ArtificialBeeColony(fitnessFunc, dim, VarMin, VarMax, MaxIt, nPop);

[Best_Score,Best_Pos,Convergence_curve_WO]=WO(SearchAgents_no,Max_iter,lb,ub,dim,fitnessFunc);




figure; % Create a new figure for combined plot

% Plot convergence curves for all algorithms
semilogy(1:max_iter, convergence, '-o', 'LineWidth', 1.5, 'DisplayName', 'Monster Hunter Optimization');
hold on; % Retain plots on the same figure

semilogy(1:max_iter, fitness_history_PSO, '-s', 'LineWidth', 1.5, 'DisplayName', 'PSO');
semilogy(1:max_iter, Convergence_curve, '-s', 'LineWidth', 1.5, 'DisplayName', 'GWO');
semilogy(1:max_iter, best_fitness_history, '-s', 'LineWidth', 2, 'DisplayName', 'Genetic Algorithm');
semilogy(1:max_iter, BestCost, '-s', 'LineWidth', 2, 'DisplayName', 'Artificial Bee Colony');
semilogy(1:max_iter, Convergence_curve_WO, '-^', 'LineWidth', 2, 'DisplayName', 'Walrus Optimizer (WO)');

% Add labels, title, legend, and grid
xlabel('Iteration/Generation');
ylabel('Best Fitness/Cost');
title('Convergence Comparison of Optimization Algorithms');
legend('Location', 'best'); % Automatically position legend
grid on;
hold off;



[lb,ub,dim,fobj] = Functions("F1");



[Gbest, best_fitness, max_iter, convergence] = MHO_code(lb, ub,dim, max_iter, fobj);

[gbest_value,fitness_history_PSO] = PSO(lb, ub, max_iter, fobj,dim);

[Alpha_score, Alpha_pos, Convergence_curve] = GWO(SearchAgents_no, Max_iter, lb, ub, dim,fobj);

[best_solution, best_fitness_GA,num_generations, best_fitness_history] = GA(fobj, lb, ub,dim, num_chromosomes, num_generations, mutation_rate);

[BestSol, BestCost] = ArtificialBeeColony(fobj, dim, VarMin, VarMax, MaxIt, nPop);

figure; % Create a new figure for combined plot

% Plot convergence curves for all algorithms
hold on; % Retain plots on the same figure
semilogy(1:max_iter, convergence, '-o', 'LineWidth', 1.5, 'DisplayName', 'Monster Hunter Optimization');
semilogy(1:30, fitness_history_PSO, '-x', 'LineWidth', 1.5, 'DisplayName', 'PSO');
semilogy(1:length(Convergence_curve), Convergence_curve, '-s', 'LineWidth', 1.5, 'DisplayName', 'GWO');
semilogy(1:num_generations, best_fitness_history, '-d', 'LineWidth', 2, 'DisplayName', 'Genetic Algorithm');
semilogy(1:length(BestCost), BestCost, '-^', 'LineWidth', 2, 'DisplayName', 'Artificial Bee Colony');

% Add labels, title, legend, and grid
xlabel('Iteration/Generation');
ylabel('Best Fitness/Cost');
title('Convergence Comparison of Optimization Algorithms');
legend('Location', 'best'); % Automatically position legend
grid on;
hold off;


[lb,ub,dim,fobj] = Functions("F2");



%%[Gbest, best_fitness, max_iter, convergence] = MHO_code(lb, ub,dim, max_iter, fobj);

[gbest_value,fitness_history_PSO] = PSO(lb, ub, max_iter, fobj,dim);

[Alpha_score, Alpha_pos, Convergence_curve] = GWO(SearchAgents_no, Max_iter, lb, ub, dim,fobj);

[best_solution, best_fitness_GA,num_generations, best_fitness_history] = GA(fobj, lb, ub,dim, num_chromosomes, num_generations, mutation_rate);

[BestSol, BestCost] = ArtificialBeeColony(fobj, dim, VarMin, VarMax, MaxIt, nPop);

figure; % Create a new figure for combined plot

% Plot convergence curves for all algorithms
hold on; % Retain plots on the same figure
semilogy(1:max_iter, convergence, '-o', 'LineWidth', 1.5, 'DisplayName', 'Monster Hunter Optimization');
semilogy(1:30, fitness_history_PSO, '-x', 'LineWidth', 1.5, 'DisplayName', 'PSO');
semilogy(1:length(Convergence_curve), Convergence_curve, '-s', 'LineWidth', 1.5, 'DisplayName', 'GWO');
semilogy(1:num_generations, best_fitness_history, '-d', 'LineWidth', 2, 'DisplayName', 'Genetic Algorithm');
semilogy(1:length(BestCost), BestCost, '-^', 'LineWidth', 2, 'DisplayName', 'Artificial Bee Colony');

% Add labels, title, legend, and grid
xlabel('Iteration/Generation');
ylabel('Best Fitness/Cost');
title('Convergence Comparison of Optimization Algorithms');
legend('Location', 'best'); % Automatically position legend
grid on;
hold off;




    
% Display Results




