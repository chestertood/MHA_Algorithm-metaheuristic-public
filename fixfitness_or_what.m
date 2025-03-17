% Optimization Algorithms Comparison
clear; clc; close all;

%% Problem Definition
problem.CostFunction = @(x) sum(100*(x(2:end)-x(1:end-1).^2).^2 + (x(1:end-1)-1).^2);
problem.nVar = 100;    % Dimention
problem.VarMin = -5.12;      % Lower Bound
problem.VarMax = 5.12;       % Upper Bound

%% Optimization Parameters
params.MaxIt = 200;           % Maximum Number of Iterations
params.nPop = 50;            % Population Size
params.Display = true;        % Display Flag


% Set random number generator seed for consistency
%rng(42);  % Set the same seed value for both algorithms
% Generate Initial Positions for Consistency
InitialPositions = unifrnd(problem.VarMin, problem.VarMax, params.nPop, problem.nVar);
% คำนวณ fitness สำหรับ initial positions
InitialFitness = zeros(params.nPop, 1); % เก็บ fitness ของแต่ละตำแหน่ง
for i = 1:params.nPop
    InitialFitness(i) = problem.CostFunction(InitialPositions(i, :));
end


%%Run algorithm

%disp('Initial Positions:');
%disp(InitialPositions);
% MHO
disp('Running MHO...');
[BestSol_MHO, BestCost_MHO, Conv_MHO] = MHO(problem, params, InitialPositions, InitialFitness);

% WO
disp('Running WO...');
[Best_Score, Best_Pos, Convergence_curve_WO] = WO_NEW(problem, params,InitialPositions,InitialFitness);
%disp('First Iteration MHO Objective Value:');
%disp(Conv_MHO(1));
%disp('First Iteration WO Objective Value:');
%disp(Convergence_curve_WO(1));

%% Results

% Plot Results
figure('Position',[100 100 800 600]);
semilogy(0:params.MaxIt, Conv_MHO, '-c', 'LineWidth', 1.5, 'DisplayName', 'MHO');
hold on;
semilogy(0:params.MaxIt, Convergence_curve_WO, 'LineWidth', 1.5, 'DisplayName', 'WO');
xlabel('Iteration');
ylabel('Best Cost (log)');
grid on;
legend('show');
title('Convergence Curves')
fprintf('\nFinal Results:\n');
fprintf('MHO Best Cost = %.4e\n', BestCost_MHO);
fprintf('WO Best Cost = %.4e\n', Best_Score);

%% MHO

function [BestSol, BestCost, Convergence] = MHO(problem, params,InitialPositions,InitialFitness)
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
    frontline_ratio = 1;
    support_ratio = 1;
    long_range_ratio = 2;
    
    % Calculate Group Sizes
    total_ratio = frontline_ratio + support_ratio + long_range_ratio;
    frontline = round(nPop * (frontline_ratio / total_ratio));
    support = round(nPop * (support_ratio / total_ratio));
    long_range = nPop - frontline - support;
    
    % Safety Distances
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
    Positions = initialization(nPop, nVar, VarMax, VarMin);
    % Initialize Convergence array
    Convergence = zeros(MaxIt+1, 1);
    Convergence(1) = min(InitialFitness);  % Set the first value to the best initial fitness
    % Debugging: Print the initial best cost
    disp('MHO Initial Best Cost:');
    disp(Convergence(1));

    
    for i = 1:nPop
        % Set Position from the initialization function
        pop(i).Position = Positions(i, :);
        %pop(i).Cost = InitialFitness(i);
        
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
    %disp('Initial Positions in MHO:');
    %disp(pop(1).Position);  % ตัวอย่างใน MHO
    


    
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
            if i <= frontline
                % Frontline Hunters (PSO-like movement)
                pop(i).Velocity = 0.5 * pop(i).Velocity + ...
                    rand(1, nVar) .*(pop(i).Best.Position - pop(i).Position) + ...
                    rand(1, nVar) .* (GlobalBest.Position - pop(i).Position);
                
                % Update Position
                pop(i).Position = pop(i).Position + pop(i).Velocity;
                
            elseif i <= frontline + support
                % Support Hunters (Maintain middle distance)
                direction = (2.*rand(1, nVar)-1).*pop(i).Position - frontline_center;
                if norm(direction) ~= 0
                    direction = direction / norm(direction);
                else
                    direction = (2.*rand(1, nVar)-1);
                    direction = direction / norm(direction);
                end
                pop(i).Position = frontline_center + direction * support_distance;
                
            else
                % Long-range Hunters (Maintain far distance)
                direction = (2.*rand(1, nVar)-1).*pop(i).Position - frontline_center;
                if norm(direction) ~= 0
                    direction = direction / norm(direction);
                else
                    direction = (2.*rand(1, nVar)-1);
                    direction = direction / norm(direction);
                end
                pop(i).Position = frontline_center + direction * long_range_distance;
            end
            
            % Apply Bounds
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
        Convergence(it+1) = GlobalBest.Cost;
        
        % Display Iteration Information
        if params.Display
            fprintf('MHO Iteration %d: Best Cost = %.4e\n', it, GlobalBest.Cost);
        end
        
    end
    
    BestCost = GlobalBest.Cost;
    BestSol = GlobalBest.Position;

    
end
%% Walrus optimazation

function [Best_Score, Best_Pos, Convergence_curve_WO] = WO_NEW(problem,params,InitialPositions,InitialFitness)
    % Extract parameters and problem definition
    nPop = params.nPop;      % Population size
    Maxit = params.MaxIt;            % Maximum number of iterations
    Varmin = problem.VarMin;                % Lower bound
    Varmax = problem.VarMax;                % Upper bound
    nVar = problem.nVar;                 % Number of variables
    fobj = problem.CostFunction;        % Objective function

    % Initialize Best_pos and Second_pos
    Best_Pos = zeros(1, nVar);
    Second_Pos = zeros(1, nVar);
    Best_Score = inf; 
    Second_Score = inf; % Change to -inf for maximization problems
    GBestX = repmat(Best_Pos, nPop, 1);
    X = initialization(nPop, nVar, Varmax, Varmin);

    %X = zeros(nPop, nVar); % Preallocate memory for X
    %Fitness = zeros(nPop, 1); % Preallocate fitness array
    for i = 1:nPop
        X(i, :) = InitialPositions(i, :);
        %Fitness(i) = InitialFitness(i); % Assign initial fitness values
    end
    
    % Initialize Convergence Curve
    Convergence_curve_WO = zeros(Maxit+1, 1);
    Convergence_curve_WO(1) = min(InitialFitness);  % Set the first value to the best initial fitness
    % Debugging: Print the initial best cost
    disp('WO Initial Best Cost:');
    disp(Convergence_curve_WO(1));


    % Proportion of females
    P = 0.4; 
    F_number = round(nPop * P); 
    M_number = F_number; 
    C_number = nPop - F_number - M_number;

    %disp('Initial Positions in WO:');
    %disp(X(1, :));  % ตัวอย่างใน WO
    % Optimization loop
    it = 0;
    while it < Maxit
        for i = 1:size(X, 1)
            % Check boundaries
            Flag4ub = X(i, :) > Varmax;
            Flag4lb = X(i, :) < Varmin;
            X(i, :) = (X(i, :) .* (~(Flag4ub + Flag4lb))) + Varmax .* Flag4ub + Varmin .* Flag4lb;

            % Calculate objective function
            fitness = fobj(X(i, :));
            if fitness < Best_Score
                Best_Score = fitness;
                Best_Pos = X(i, :); % Update Best_pos
            end
            if fitness > Best_Score && fitness < Second_Score
                Second_Score = fitness;
                Second_Pos = X(i, :); % Update Second_pos
            end
        end


        % Update parameters
        Alpha = 1 - it / Maxit;
        Beta = 1 - 1 / (1 + exp((1 / 2 * Maxit - it) / Maxit * 10));
        A = 2 * Alpha;
        r1 = rand();
        R = 2 * r1 - 1;
        Danger_signal = A * R;
        r2 = rand();
        Satey_signal = r2;

        % Movement strategy
        if abs(Danger_signal) >= 1
            r3 = rand();
            Rs = size(X, 1);
            Migration_step = (Beta * r3^2) * (X(randperm(Rs), :) - X(randperm(Rs), :));
            X = X + Migration_step;
        elseif abs(Danger_signal) < 1
            if Satey_signal >= 0.5
                for i = 1:M_number
                    xy = zeros(M_number, 0);
                    base = 7;
                    xy(i, 1) = hal(i, base);
                    M = [];
                    m1 = xy(i, :);
                    m1 = Varmin + m1 .* (Varmax - Varmin);
                    M = [M; m1];
                    X(i, :) = M;
                end
                for j = M_number + 1:M_number + F_number
                    X(j, :) = X(j, :) + Alpha * (X(i, :) - X(j, :)) + (1 - Alpha) * (GBestX(j, :) - X(j, :));
                end
                for i = nPop - C_number + 1:nPop
                    P = rand;
                    o = GBestX(i, :) + X(i, :) .* levyFlight(nVar);
                    X(i, :) = P * (o - X(i, :));
                end
            end

            if Satey_signal < 0.5 && abs(Danger_signal) >= 0.5
                for i = 1:nPop
                    r4 = rand;
                    X(i, :) = X(i, :) * R - abs(GBestX(i, :) - X(i, :)) * r4^2;
                end
            end

            if Satey_signal < 0.5 && abs(Danger_signal) < 0.5
                for i = 1:size(X, 1)
                    for j = 1:size(X, 2)
                        theta1 = rand();
                        a1 = Beta * rand() - Beta;
                        b1 = tan(theta1 .* pi);
                        X1 = Best_Pos(j) - a1 * b1 * abs(Best_Pos(j) - X(i, j));

                        theta2 = rand();
                        a2 = Beta * rand() - Beta;
                        b2 = tan(theta2 .* pi);
                        X2 = Second_Pos(j) - a2 * b2 * abs(Second_Pos(j) - X(i, j));

                        X(i, j) = (X1 + X2) / 2;
                    end
                end
            end
        end

    it = it + 1;
    Convergence_curve_WO(it+1) = Best_Score;
    if it == 1
        disp('First Iteration Best Score in WO:');
        disp(Best_Score);
    end
   
    if params.Display
        fprintf('WO Iteration %d: Best Cost = %.4e\n', it, Best_Score);
    end

    end

end