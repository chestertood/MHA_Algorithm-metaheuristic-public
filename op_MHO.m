clc;
clear;
close all;

% Select Benchmark Function
F = 'F1'; % Change this to any function ID from 'F1' to 'F23'

% Load Benchmark Function
[lb, ub, dim, fobj] = Functions(F);

% Problem Definition
problem.CostFunction = fobj;   % Cost Function
problem.nVar = 2;            % Number of Variables
problem.VarMin = lb;           % Lower Bound
problem.VarMax = ub;           % Upper Bound

% MHO Parameters
params.MaxIt = 30;            % Maximum Iterations
params.nPop = 50;              % Population Size
params.Display = true;         % Display Iteration Info

% Run MHO Algorithm
[BestSol, BestCost, Convergence] = MHO(problem, params);

% Display Results
fprintf('\nBest Solution: %.4f\n', BestSol);
fprintf('Best Cost: %.4e\n', BestCost);

% Plot Convergence
figure;
semilogy(Convergence, 'LineWidth', 2);
xlabel('Iteration');
ylabel('Best Cost');
title(['Convergence Curve for ', F]);
grid on;

function [BestSol, BestCost, Convergence] = MHO(problem, params)
    % Monster Hunter Optimization Algorithm
    
    % Extract Problem Information
    CostFunction = problem.CostFunction;
    nVar = problem.nVar;            % Number of Decision Variables
    VarMin = problem.VarMin;        % Lower Bound of Variables
    VarMax = problem.VarMax;        % Upper Bound of Variables
    
    % Algorithm Parameters
    MaxIt = params.MaxIt;    % Maximum Number of Iterations
    nPop = params.nPop;      % Population Size
    
    % Hunter Group Ratios
    
    frontline_roaming_ratio = 1; % New roaming group ratio
    frontline_ratio = 1;
    support_ratio = 1;
    long_range_ratio = 1;
    
    
    % Calculate Group Sizes
    total_ratio = frontline_ratio + support_ratio + long_range_ratio + frontline_roaming_ratio;
    frontline_roaming = round(nPop * (frontline_roaming_ratio / total_ratio)); % Remaining hunters assigned to roaming
    frontline = round(nPop * (frontline_ratio / total_ratio));
    support = round(nPop * (support_ratio / total_ratio));
    long_range = round(nPop * (long_range_ratio / total_ratio));%nPop - frontline - support - long_range;
    
    
    % Safety Distances
    frontline_distance =  0.05 * (VarMax - VarMin);
    support_distance = 0.1 * (VarMax - VarMin);
    long_range_distance = 0.2 * (VarMax - VarMin);
    
    % Initialize Population Array
    empty_hunter.Position = [];
    empty_hunter.Cost = [];
    empty_hunter.Velocity = [];
    empty_hunter.Best.Position = [];
    empty_hunter.Best.Cost = [];
    
    % Create Population Array
    pop = repmat(empty_hunter, nPop, 1);
    
    % Initialize Best Solution Ever Found
    GlobalBest.Cost = inf;
    
    % Initialize Population Members using initialization function
    Positions = initialization(nPop, nVar, VarMax, VarMin);  % Initialize positions
    for i = 1:nPop
        % Set Position from the initialization function
        pop(i).Position = Positions(i, :);
        
        % Initialize Velocity (for Frontline Hunters)
        pop(i).Velocity = zeros(1, nVar);
        
        % Evaluate
        pop(i).Cost = CostFunction(pop(i).Position);
        
        % Update Personal Best
        pop(i).Best.Position = pop(i).Position;
        pop(i).Best.Cost = pop(i).Cost;
        
        % Update Global Best
        if pop(i).Best.Cost < GlobalBest.Cost
            GlobalBest = pop(i).Best;
        end
    end
    
    % Array to Hold Best Cost Values at Each Iteration
    Convergence = zeros(MaxIt, 1);
    
    % Main Loop
    for it = 1:MaxIt
        
        % Calculate Frontline Center
        frontline_positions = zeros(frontline, nVar);
        for i = 1:frontline
            frontline_positions(i,:) = pop(i).Position;
        end
        frontline_center = mean(frontline_positions);
        
        % Update Hunters
        for i = 1:nPop
            if i <= frontline_roaming
                % Frontline Hunters (PSO-like movement)
                pop(i).Velocity = 0.1 * pop(i).Velocity + ...
                    rand(1, nVar) .* (pop(i).Best.Position - pop(i).Position) + ...
                    rand(1, nVar) .* (GlobalBest.Position - pop(i).Position);
                
                % Update Position
                pop(i).Position = pop(i).Position + pop(i).Velocity;
            elseif i <= frontline + frontline_roaming
                % Frontline Hunters (PSO-like movement)
                pop(i).Velocity = 0.5 * pop(i).Velocity + ...
                    rand(1, nVar) .* (pop(i).Best.Position - pop(i).Position) + ...
                    rand(1, nVar) .* (GlobalBest.Position - pop(i).Position);
                
                % Update Position
                pop(i).Position = pop(i).Position + pop(i).Velocity;
                
            elseif i <= frontline + support + frontline_roaming
                % Support Hunters (Maintain middle distance)
                direction = (2.*rand(1, nVar)-1) .* (pop(i).Position - frontline_center);
                if norm(direction) ~= 0
                    direction = direction / norm(direction);
                else
                    direction = randn(1, nVar);
                    direction = direction / norm(direction);
                end
                pop(i).Position = frontline_center + direction .* support_distance; % Use element-wise multiplication
            %else  
            elseif i <= frontline + support + long_range + frontline_roaming
                % Long-range Hunters (Maintain far distance)
                direction = (2.*rand(1, nVar)-1) .* (pop(i).Position - frontline_center);
                if norm(direction) ~= 0
                    direction = direction / norm(direction);
                else
                    direction = randn(1, nVar);
                    direction = direction / norm(direction);
                end
                pop(i).Position = frontline_center + direction .* long_range_distance; % Use element-wise multiplication
            end
            
            % Apply Bounds to ensure positions are within the defined limits
            pop(i).Position = max(pop(i).Position, VarMin);
            pop(i).Position = min(pop(i).Position, VarMax);
            
            % Evaluation
            pop(i).Cost = CostFunction(pop(i).Position);
            
            % Update Personal Best
            if pop(i).Cost < pop(i).Best.Cost
                pop(i).Best.Position = pop(i).Position;
                pop(i).Best.Cost = pop(i).Cost;
                
                % Update Global Best
                if pop(i).Best.Cost < GlobalBest.Cost
                    GlobalBest = pop(i).Best;
                end
            end
        end
        
        % Store Best Cost
        Convergence(it) = GlobalBest.Cost;
        
        % Display Iteration Information
        if params.Display
            fprintf('MHO Iteration %d: Best Cost = %.4e\n', it, GlobalBest.Cost);
        end
        
    end
    
    BestCost = GlobalBest.Cost;
    BestSol = GlobalBest.Position;
    
end
