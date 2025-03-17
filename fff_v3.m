% Optimization Algorithms Comparison
clear; clc; close all;


Problems = arrayfun(@(x) ['F', num2str(x)], 1:23, 'UniformOutput', false);
for i = Problems
    [lb,ub,dim,fobj] = Functions(i{1});   
   

    %% Problem Definition
    problem.CostFunction = fobj;
    problem.nVar = dim;    % Dimention
    problem.VarMin = lb;      % Lower Bound
    problem.VarMax = ub;       % Upper Bound
    
    %% Optimization Parameters
    params.MaxIt = 30;           % Maximum Number of Iterations
    params.nPop = 50;            % Population Size
    params.Display = true;        % Display Flag

    %% Run Algorithms
    % GA
    disp('Running GA...');
    [BestSol_GA, BestCost_GA, Conv_GA] = GA(problem, params);
    % Statistics for GA
    max_GA = max(Conv_GA);
    min_GA = min(Conv_GA);
    mean_GA = mean(Conv_GA);

    
    % PSO
    disp('Running PSO...');
    [BestSol_PSO, BestCost_PSO, Conv_PSO] = PSO(problem, params);
    max_PSO = max(Conv_PSO);
    min_PSO = min(Conv_PSO);
    mean_PSO = mean(Conv_PSO);

    % GWO
    disp('Running GWO...');
    [BestSol_GWO, BestCost_GWO, Conv_GWO] = GWO(problem, params);
    max_GWO = max(Conv_GWO);
    min_GWO = min(Conv_GWO);
    mean_GWO = mean(Conv_GWO);

    
    % ABC
    disp('Running ABC...');
    [BestSol_ABC, BestCost_ABC, Conv_ABC] = ABC(problem, params);
    max_ABC = max(Conv_ABC);
    min_ABC = min(Conv_ABC);
    mean_ABC = mean(Conv_ABC);
    
    
    % SA
    disp('Running SA...');
    [BestSol_SA, BestCost_SA, Conv_SA] = SA(problem, params);
    max_SA = max(Conv_SA);
    min_SA = min(Conv_SA);
    mean_SA = mean(Conv_SA);
    
    % MHO
    disp('Running MHO...');
    [BestSol_MHO, BestCost_MHO, Conv_MHO] = MHO(problem, params);
    max_MHO = max(Conv_MHO);
    min_MHO = min(Conv_MHO);
    mean_MHO = mean(Conv_MHO);
    
    % WO
    disp('Running WO...');
    [Best_Score, Best_Pos, Convergence_curve_WO] = WO_NEW(problem, params);
    max_WO = max(Convergence_curve_WO);
    min_WO = min(Convergence_curve_WO);
    mean_WO = mean(Convergence_curve_WO);
    
    %Puma
    disp('Running Puma...');
    [Puma_X, Puma_C, Convergence_PUMA] = Puma_new(params, problem);
    max_PUMA = max(Convergence_PUMA);
    min_PUMA = min(Convergence_PUMA);
    mean_PUMA = mean(Convergence_PUMA);
    
    disp('Running HBO...');
    [Leader_score, Leader_pos, Convergence_curve_HBO] = HBO(problem, params);
    max_HBO = max(Convergence_curve_HBO);
    min_HBO = min(Convergence_curve_HBO);
    mean_HBO = mean(Convergence_curve_HBO);
    
    disp('Running WOA...');
    [Leader_score_WOA, Leader_pos_WOA, Convergence_curve_WOA] = WOA(problem, params);
    max_WOA = max(Convergence_curve_WOA);
    min_WOA = min(Convergence_curve_WOA);
    mean_WOA = mean(Convergence_curve_WOA);
    
    
    
    %% Results
    
    % Plot Results
    figure('Position',[100 100 800 600]);
    semilogy(Conv_MHO,'-c','LineWidth',1.5, 'DisplayName','MHO');
    
    hold on;
    semilogy(Conv_PSO,'-b','LineWidth',1.5, 'DisplayName','PSO');
    semilogy(Conv_GWO,'-g','LineWidth',1.5, 'DisplayName','GWO');
    semilogy(Conv_ABC,'-k','LineWidth',1.5, 'DisplayName','ABC');
    semilogy(Conv_SA,'-m','LineWidth',1.5, 'DisplayName','SA');
    semilogy(Conv_GA,'-r','LineWidth',1.5, 'DisplayName','GA');
    semilogy(Convergence_curve_WO,'LineWidth',1.5, 'DisplayName','WO');
    semilogy(Convergence_PUMA,'LineWidth',1.5, 'DisplayName','PUMA');
    semilogy(Convergence_curve_HBO,'LineWidth',1.5, 'DisplayName','HBO');
    semilogy(Convergence_curve_WOA,'LineWidth',1.5, 'DisplayName','WOA');
    
    xlabel('Iteration');
    ylabel('Best Cost (log)');
    grid on;
    legend('show');
    title('Convergence Curves');
    
    % Display Final Results
    fprintf('\nFinal Results:\n');
    fprintf('GA  Best Cost = %.4e\n', BestCost_GA);
    fprintf('PSO Best Cost = %.4e\n', BestCost_PSO);
    fprintf('GWO Best Cost = %.4e\n', BestCost_GWO);
    fprintf('ABC Best Cost = %.4e\n', BestCost_ABC);
    fprintf('SA  Best Cost = %.4e\n', BestCost_SA);
    fprintf('MHO Best Cost = %.4e\n', BestCost_MHO);
    fprintf('WO Best Cost = %.4e\n', Best_Score);
    fprintf('Puma Best Cost = %.4e\n', Puma_C);
    fprintf('HBO Best Cost = %.4e\n', Leader_score);
    fprintf('WOA Best Cost = %.4e\n', Leader_score_WOA);
    
    % Save Results
    results.GA = struct('BestSol', BestSol_GA, 'BestCost', BestCost_GA, 'Convergence', Conv_GA...
                            ,'Max_value',max_GA, 'Min_value',min_GA,'Mean_value',mean_GA);
    results.PSO = struct('BestSol', BestSol_PSO, 'BestCost', BestCost_PSO, 'Convergence', Conv_PSO...
                            ,'Max_value',max_PSO, 'Min_value',min_PSO,'Mean_value',mean_PSO);
    results.GWO = struct('BestSol', BestSol_GWO, 'BestCost', BestCost_GWO, 'Convergence', Conv_GWO...
                            ,'Max_value',max_GWO, 'Min_value',min_GWO,'Mean_value',mean_GWO);
    results.ABC = struct('BestSol', BestSol_ABC, 'BestCost', BestCost_ABC, 'Convergence', Conv_ABC...
                            ,'Max_value',max_ABC, 'Min_value',min_ABC,'Mean_value',mean_ABC);
    results.SA = struct('BestSol', BestSol_SA, 'BestCost', BestCost_SA, 'Convergence', Conv_SA...
                            ,'Max_value',max_SA, 'Min_value',min_SA,'Mean_value',mean_SA);
    results.MHO = struct('BestSol', BestSol_MHO, 'BestCost', BestCost_MHO, 'Convergence', Conv_MHO...
                            ,'Max_value',max_MHO, 'Min_value',min_MHO,'Mean_value',mean_MHO);
    results.WO = struct('BestSol', Best_Pos, 'BestCost', Best_Score, 'Convergence', Convergence_curve_WO...
                            ,'Max_value',max_WO, 'Min_value',min_WO,'Mean_value',mean_WO);
    results.Puma = struct('BestSol', Puma_X, 'BestCost', Puma_C, 'Convergence', Convergence_PUMA...
                            ,'Max_value',max_PUMA, 'Min_value',min_PUMA,'Mean_value',mean_PUMA);
    results.HBO = struct('BestSol', Leader_pos, 'BestCost', Leader_score, 'Convergence', Convergence_curve_HBO...
                            ,'Max_value',max_HBO, 'Min_value',min_HBO,'Mean_value',mean_HBO);
    results.WOA = struct('BestSol', Leader_pos_WOA, 'BestCost', Leader_score_WOA, 'Convergence', Convergence_curve_WOA...
                            ,'Max_value',max_WOA, 'Min_value',min_WOA,'Mean_value',mean_WOA);
    
    
    save('optimization_results.mat', 'results');
end


%% GA Function
function [BestSol, BestCost, Convergence] = GA(problem, params)
    % Extract Problem Info
    CostFunction = problem.CostFunction;
    nVar = problem.nVar;
    VarMin = problem.VarMin;
    VarMax = problem.VarMax;
    
    % GA Parameters    
    MaxIt = params.MaxIt;
    nPop = params.nPop;    
    pCrossover = 0.7;
    nCrossover = 2*round(pCrossover*nPop/2);
    pMutation = 0.3;
    nMutation = round(pMutation*nPop);
    mu = 0.02;
    
    % Initialize
    empty_individual.Position = [];
    empty_individual.Cost = [];
    pop = repmat(empty_individual, nPop, 1);
    
    % Create Initial Population
    for i = 1:nPop
        pop(i).Position = unifrnd(VarMin, VarMax, [1 nVar]);
        pop(i).Cost = CostFunction(pop(i).Position);
    end
    
    % Sort and Select Best
    [~, SortOrder] = sort([pop.Cost]);
    pop = pop(SortOrder);
    BestSol = pop(1);
    
    % Main Loop
    Convergence = zeros(MaxIt, 1);
    for it = 1:MaxIt
        % Crossover
        popc = repmat(empty_individual, nCrossover, 1);
        for k = 1:2:nCrossover
            p1 = pop(randi([1 nPop]));
            p2 = pop(randi([1 nPop]));
            [popc(k).Position, popc(k+1).Position] = ...
                GA_Crossover(p1.Position, p2.Position);
            popc(k).Cost = CostFunction(popc(k).Position);
            popc(k+1).Cost = CostFunction(popc(k+1).Position);
        end
        
        % Mutation
        popm = repmat(empty_individual, nMutation, 1);
        for k = 1:nMutation
            p = pop(randi([1 nPop]));
            popm(k).Position = GA_Mutate(p.Position, mu, VarMin, VarMax);
            popm(k).Cost = CostFunction(popm(k).Position);
        end
        
        % Merge and Sort
        pop = [pop; popc; popm];
        [~, SortOrder] = sort([pop.Cost]);
        pop = pop(SortOrder);
        pop = pop(1:nPop);
        
        % Update Best
        BestSol = pop(1);
        Convergence(it) = BestSol.Cost;
        
        % Display Iteration Info
        if params.Display
            fprintf('GA Iteration %d: Best Cost = %.4e\n', it, BestSol.Cost);
        end
    end
    
    BestCost = BestSol.Cost;
    BestSol = BestSol.Position;
end

function [y1, y2] = GA_Crossover(x1, x2)
    alpha = rand(size(x1));
    y1 = alpha.*x1 + (1-alpha).*x2;
    y2 = alpha.*x2 + (1-alpha).*x1;
end

function y = GA_Mutate(x, mu, VarMin, VarMax)
    nVar = numel(x);               % Number of variables
    nMu = ceil(mu * nVar);         % Number of mutated variables
    j = randsample(nVar, nMu);     % Randomly select which variables to mutate
    y = x;                         % Copy the original position

    % Apply mutation to the selected variables
    for idx = 1:nMu
        % Check if bounds are scalar or vector
        if numel(VarMin) == 1 && numel(VarMax) == 1
            % Scalar bounds (e.g., VarMin = -2, VarMax = 2)
            y(j(idx)) = unifrnd(VarMin, VarMax);
        else
            % Vector bounds (e.g., VarMin = [-5, 0], VarMax = [10, 15])
            y(j(idx)) = unifrnd(VarMin(j(idx)), VarMax(j(idx)));
        end
    end
end
%% PSO Function
function [BestSol, BestCost, Convergence] = PSO(problem, params)
    % Extract Problem Info
    CostFunction = problem.CostFunction;
    nVar = problem.nVar;
    VarMin = problem.VarMin;
    VarMax = problem.VarMax;
    
    % PSO Parameters
    MaxIt = params.MaxIt;
    nPop = params.nPop;
    w = 1;              % Inertia Weight
    wdamp = 0.99;       % Damping Ratio
    c1 = 1.5;           % Personal Acceleration
    c2 = 2.0;           % Social Acceleration
    
    % Velocity Limits
    VelMax = 0.1*(VarMax-VarMin);
    VelMin = -VelMax;
    
    % Initialize
    empty_particle.Position = [];
    empty_particle.Velocity = [];
    empty_particle.Cost = [];
    empty_particle.Best.Position = [];
    empty_particle.Best.Cost = [];
    
    particle = repmat(empty_particle, nPop, 1);
    GlobalBest.Cost = inf;
    
    % Initialize Population
    for i = 1:nPop
        particle(i).Position = unifrnd(VarMin, VarMax, [1 nVar]);
        particle(i).Velocity = zeros(1, nVar);
        particle(i).Cost = CostFunction(particle(i).Position);
        particle(i).Best.Position = particle(i).Position;
        particle(i).Best.Cost = particle(i).Cost;
        
        if particle(i).Best.Cost < GlobalBest.Cost
            GlobalBest = particle(i).Best;
        end
    end
    
    % Main Loop
    Convergence = zeros(MaxIt, 1);
    for it = 1:MaxIt
        for i = 1:nPop
            % Update Velocity
            particle(i).Velocity = w*particle(i).Velocity ...
                + c1*rand(1,nVar).*(particle(i).Best.Position-particle(i).Position) ...
                + c2*rand(1,nVar).*(GlobalBest.Position-particle(i).Position);
            
            % Apply Velocity Limits
            particle(i).Velocity = max(particle(i).Velocity, VelMin);
            particle(i).Velocity = min(particle(i).Velocity, VelMax);
            
            % Update Position
            particle(i).Position = particle(i).Position + particle(i).Velocity;
            
            % Apply Position Limits
            particle(i).Position = max(particle(i).Position, VarMin);
            particle(i).Position = min(particle(i).Position, VarMax);
            
            % Evaluation
            particle(i).Cost = CostFunction(particle(i).Position);
            
            % Update Personal Best
            if particle(i).Cost < particle(i).Best.Cost
                particle(i).Best.Position = particle(i).Position;
                particle(i).Best.Cost = particle(i).Cost;
                
                % Update Global Best
                if particle(i).Best.Cost < GlobalBest.Cost
                    GlobalBest = particle(i).Best;
                end
            end
        end
        
        Convergence(it) = GlobalBest.Cost;
        
        if params.Display
            fprintf('PSO Iteration %d: Best Cost = %.4e\n', it, GlobalBest.Cost);
        end
        
        w = w * wdamp;
    end
    
    BestCost = GlobalBest.Cost;
    BestSol = GlobalBest.Position;
end

%% GWO Function
function [BestSol, BestCost, Convergence] = GWO(problem, params)
    % Extract Problem Info
    CostFunction = problem.CostFunction;
    nVar = problem.nVar;
    VarMin = problem.VarMin;
    VarMax = problem.VarMax;
    
    % Parameters
    MaxIt = params.MaxIt;
    nPop = params.nPop;
    
    % Initialize Alpha, Beta, and Delta
    Alpha.Cost = inf;
    Beta.Cost = inf;
    Delta.Cost = inf;
    
    % Initialize Population
    empty_wolf.Position = [];
    empty_wolf.Cost = [];
    wolf = repmat(empty_wolf, nPop, 1);
    
    for i = 1:nPop
        wolf(i).Position = unifrnd(VarMin, VarMax, [1 nVar]);
        wolf(i).Cost = CostFunction(wolf(i).Position);
        
        if wolf(i).Cost < Alpha.Cost
            Delta = Beta;
            Beta = Alpha;
            Alpha = wolf(i);
        elseif wolf(i).Cost < Beta.Cost
            Delta = Beta;
            Beta = wolf(i);
        elseif wolf(i).Cost < Delta.Cost
            Delta = wolf(i);
        end
    end
    
    % Main Loop
    Convergence = zeros(MaxIt, 1);
    for it = 1:MaxIt
        a = 2 - it * (2/MaxIt);
        
        for i = 1:nPop
            for j = 1:nVar
                % Update Alpha
                r1 = rand(); r2 = rand();
                A1 = 2*a*r1-a;
                C1 = 2*r2;
                D_alpha = abs(C1*Alpha.Position(j) - wolf(i).Position(j));
                X1 = Alpha.Position(j) - A1*D_alpha;
                
                % Update Beta
                r1 = rand(); r2 = rand();
                A2 = 2*a*r1-a;
                C2 = 2*r2;
                D_beta = abs(C2*Beta.Position(j) - wolf(i).Position(j));
                X2 = Beta.Position(j) - A2*D_beta;
                
                % Update Delta
                r1 = rand(); r2 = rand();
                A3 = 2*a*r1-a;
                C3 = 2*r2;
                D_delta = abs(C3*Delta.Position(j) - wolf(i).Position(j));
                X3 = Delta.Position(j) - A3*D_delta;
                
                % Position Update
                wolf(i).Position(j) = (X1 + X2 + X3)/3;
            end
            
            % Apply Bounds
            wolf(i).Position = max(wolf(i).Position, VarMin);
            wolf(i).Position = min(wolf(i).Position, VarMax);
            
            % Evaluation
            wolf(i).Cost = CostFunction(wolf(i).Position);
            
            % Update Alpha, Beta, Delta
            if wolf(i).Cost < Alpha.Cost
                Delta = Beta;
                Beta = Alpha;
                Alpha = wolf(i);
            elseif wolf(i).Cost < Beta.Cost
                Delta = Beta;
                Beta = wolf(i);
            elseif wolf(i).Cost < Delta.Cost
                Delta = wolf(i);
            end
        end
        
        Convergence(it) = Alpha.Cost;
        
        if params.Display
            fprintf('GWO Iteration %d: Best Cost = %.4e\n', it, Alpha.Cost);
        end
    end
    
    BestCost = Alpha.Cost;
    BestSol = Alpha.Position;
end

%% ABC Function
function [BestSol, BestCost, Convergence] = ABC(problem, params)
    % Extract Problem Info
    CostFunction = problem.CostFunction;
    nVar = problem.nVar;
    VarMin = problem.VarMin;
    VarMax = problem.VarMax;
    
    % Parameters
    MaxIt = params.MaxIt;
    nPop = params.nPop;
    nOnlooker = nPop;
    L = round(0.6 * nVar * nPop); % Limit for scout
    
    % Initialize
    empty_bee.Position = [];
    empty_bee.Cost = [];
    empty_bee.Trial = 0;
    
    % Initialize Population
    pop = repmat(empty_bee, nPop, 1);
    BestSol.Cost = inf;
    
    % Create Initial Population
    for i = 1:nPop
        pop(i).Position = unifrnd(VarMin, VarMax, [1 nVar]);
        pop(i).Cost = CostFunction(pop(i).Position);
        pop(i).Trial = 0;
        
        if pop(i).Cost < BestSol.Cost
            BestSol = pop(i);
        end
    end
    
    % Main Loop
    Convergence = zeros(MaxIt, 1);
    for it = 1:MaxIt
        
        % Employed Bees
        for i = 1:nPop
            % Choose k randomly, not equal to i
            K = [1:i-1 i+1:nPop];
            k = K(randi([1 numel(K)]));
            
            % New Bee Position
            phi = unifrnd(-1, +1, [1 nVar]);
            newbee.Position = pop(i).Position ...
                + phi.*(pop(i).Position - pop(k).Position);
            
            % Apply Bounds
            newbee.Position = max(newbee.Position, VarMin);
            newbee.Position = min(newbee.Position, VarMax);
            
            % Evaluation
            newbee.Cost = CostFunction(newbee.Position);
            
            % Comparison
            if newbee.Cost <= pop(i).Cost
                pop(i).Position = newbee.Position;
                pop(i).Cost = newbee.Cost;
                pop(i).Trial = 0;
            else
                pop(i).Trial = pop(i).Trial + 1;
            end
        end
        
        % Calculate Fitness Values and Selection Probabilities
        F = zeros(nPop, 1);
        MeanCost = mean([pop.Cost]);
        for i = 1:nPop
            F(i) = exp(-pop(i).Cost/MeanCost);
        end
        P = F/sum(F);
        
        % Onlooker Bees
        for m = 1:nOnlooker
            % Select Source Site
            i = RouletteWheelSelection(P);
            
            % Choose k randomly, not equal to i
            K = [1:i-1 i+1:nPop];
            k = K(randi([1 numel(K)]));
            
            % New Bee Position
            phi = unifrnd(-1, +1, [1 nVar]);
            newbee.Position = pop(i).Position ...
                + phi.*(pop(i).Position - pop(k).Position);
            
            % Apply Bounds
            newbee.Position = max(newbee.Position, VarMin);
            newbee.Position = min(newbee.Position, VarMax);
            
            % Evaluation
            newbee.Cost = CostFunction(newbee.Position);
            
            % Comparison
            if newbee.Cost <= pop(i).Cost
                pop(i).Position = newbee.Position;
                pop(i).Cost = newbee.Cost;
                pop(i).Trial = 0;
            else
                pop(i).Trial = pop(i).Trial + 1;
            end
        end
        
        % Scout Bees
        for i = 1:nPop
            if pop(i).Trial >= L
                pop(i).Position = unifrnd(VarMin, VarMax, [1 nVar]);
                pop(i).Cost = CostFunction(pop(i).Position);
                pop(i).Trial = 0;
            end
        end
        
        % Update Best Solution Ever Found
        for i = 1:nPop
            if pop(i).Cost <= BestSol.Cost
                BestSol = pop(i);
            end
        end
        
        Convergence(it) = BestSol.Cost;
        
        if params.Display
            fprintf('ABC Iteration %d: Best Cost = %.4e\n', it, BestSol.Cost);
        end
    end
    
    BestCost = BestSol.Cost;
    BestSol = BestSol.Position;
end

function i = RouletteWheelSelection(P)
    r = rand;
    c = cumsum(P);
    i = find(r <= c, 1, 'first');
end

%% SA Function
function [BestSol, BestCost, Convergence] = SA(problem, params)
    % Extract Problem Info
    CostFunction = problem.CostFunction;
    nVar = problem.nVar;
    VarMin = problem.VarMin;
    VarMax = problem.VarMax;
    
    % SA Parameters
    MaxIt = params.MaxIt;
    T0 = 100;                % Initial Temperature
    alpha = 0.99;            % Cooling Rate
    nMove = 5;               % Number of Neighbors per Temperature
    
    % Initialize Best Solution
    x.Position = unifrnd(VarMin, VarMax, [1 nVar]);
    x.Cost = CostFunction(x.Position);
    BestSol = x;
    
    % Array to Hold Best Costs
    Convergence = zeros(MaxIt, 1);
    
    % SA Main Loop
    T = T0;
    for it = 1:MaxIt
        for move = 1:nMove
            % Create New Solution
            xnew.Position = x.Position + unifrnd(-1, 1, size(x.Position)) .* T;
            
            % Apply Bounds
            xnew.Position = max(xnew.Position, VarMin);
            xnew.Position = min(xnew.Position, VarMax);
            
            % Evaluation
            xnew.Cost = CostFunction(xnew.Position);
            
            % Calculate Delta E
            DE = xnew.Cost - x.Cost;
            
            % Accept or Reject
            if DE <= 0 || rand <= exp(-DE/T)
                x = xnew;
            end
            
            % Update Best Solution
            if x.Cost <= BestSol.Cost
                BestSol = x;
            end
        end
        
        % Store Best Cost
        Convergence(it) = BestSol.Cost;
        
        % Display Iteration Information
        if params.Display
            fprintf('SA Iteration %d: Best Cost = %.4e\n', it, BestSol.Cost);
        end
        
        % Update Temperature
        T = alpha * T;
    end
    
    BestCost = BestSol.Cost;
    BestSol = BestSol.Position;
end



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


function [Best_Score, Best_Pos, Convergence_curve_WO] = WO_NEW(problem,params)
    % Extract parameters and problem definition
    SearchAgents_no = params.nPop;      % Population size
    Max_iter = params.MaxIt;            % Maximum number of iterations
    lb = problem.VarMin;                % Lower bound
    ub = problem.VarMax;                % Upper bound
    dim = problem.nVar;                 % Number of variables
    fobj = problem.CostFunction;        % Objective function

    % Initialize Best_pos and Second_pos
    Best_Pos = zeros(1, dim);
    Second_Pos = zeros(1, dim);
    Best_Score = inf; 
    Second_Score = inf; % Change to -inf for maximization problems
    GBestX = repmat(Best_Pos, SearchAgents_no, 1);

    % Initialize the positions of search agents
    X = initialization(SearchAgents_no, dim, ub, lb);
    Convergence_curve_WO = zeros(1, Max_iter);

    % Proportion of females
    P = 0.4; 
    F_number = round(SearchAgents_no * P); 
    M_number = F_number; 
    C_number = SearchAgents_no - F_number - M_number;

    % Optimization loop
    t = 0;
    while t < Max_iter
        for i = 1:size(X, 1)
            % Check boundaries
            Flag4ub = X(i, :) > ub;
            Flag4lb = X(i, :) < lb;
            X(i, :) = (X(i, :) .* (~(Flag4ub + Flag4lb))) + ub .* Flag4ub + lb .* Flag4lb;

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
        Alpha = 1 - t / Max_iter;
        Beta = 1 - 1 / (1 + exp((1 / 2 * Max_iter - t) / Max_iter * 10));
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
                    m1 = lb + m1 .* (ub - lb);
                    M = [M; m1];
                    X(i, :) = M;
                end
                for j = M_number + 1:M_number + F_number
                    X(j, :) = X(j, :) + Alpha * (X(i, :) - X(j, :)) + (1 - Alpha) * (GBestX(j, :) - X(j, :));
                end
                for i = SearchAgents_no - C_number + 1:SearchAgents_no
                    P = rand;
                    o = GBestX(i, :) + X(i, :) .* levyFlight(dim);
                    X(i, :) = P * (o - X(i, :));
                end
            end

            if Satey_signal < 0.5 && abs(Danger_signal) >= 0.5
                for i = 1:SearchAgents_no
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

        t = t + 1;
        Convergence_curve_WO(t) = Best_Score;
    end
end


function [Puma_X, Puma_C, Convergence_PUMA] = Puma_new(params, problem)
    % Extract parameters
    nSol = params.nPop;                 % Number of solutions
    MaxIter = params.MaxIt;           % Maximum number of iterations
    lb = problem.VarMin;                    % Lower bounds
    ub = problem.VarMax;                    % Upper bounds
    dim = problem.nVar;                  % Problem dimensions
    CostFunction = problem.CostFunction;% Objective function

    % Parameter setting
    UnSelected = ones(1, 2); % 1:Exploration 2:Exploitation
    F3_Explore = 0; 
    F3_Exploit = 0;
    Seq_Time_Explore = ones(1, 3);
    Seq_Time_Exploit = ones(1, 3);
    Seq_Cost_Explore = ones(1, 3);
    Seq_Cost_Exploit = ones(1, 3); 
    Score_Explore = 0; 
    Score_Exploit = 0;
    PF = [0.5, 0.5, 0.3];  % 1&2 for intensification (F1, F2), 3 for diversification (F3)
    PF_F3 = [];
    Mega_Explor = 0.99;
    Mega_Exploit = 0.99;

    % Initialization
    for i = 1:nSol
        Sol(i).X = unifrnd(lb, ub, 1, dim); %#ok
        Sol(i).Cost = CostFunction(Sol(i).X); %#ok
    end
    [~, ind] = min([Sol.Cost]);
    Best = Sol(ind);
    Flag_Change = 1;
    Initial_Best = Best;

    %% Unexperienced Phase
    for Iter = 1:3
        Sol_Explor = Exploration(Sol, lb, ub, dim, nSol, CostFunction); % Run Exploration Phase
        Costs_Explor(1, Iter) = min([Sol_Explor.Cost]); %#ok
        Sol_Exploit = Exploitation(Sol, lb, ub, dim, nSol, Best, MaxIter, Iter, CostFunction); % Run Exploitation Phase
        Costs_Exploit(1, Iter) = min([Sol_Exploit.Cost]); %#ok
        Sol = [Sol Sol_Explor Sol_Exploit]; %#ok
        [~, sind] = sort([Sol.Cost]);
        Sol = Sol(sind(1:nSol));
        Best = Sol(1);
        Convergence_PUMA(Iter) = Best.Cost; %#ok
        disp(['Iteration: ' num2str(Iter) ' Best Cost = ' num2str(Best.Cost)]);
    end

    % Hyper Initialization
    Seq_Cost_Explore(1) = abs(Initial_Best.Cost - Costs_Explor(1)); % Eq (5)
    Seq_Cost_Exploit(1) = abs(Initial_Best.Cost - Costs_Exploit(1)); % Eq (8)
    Seq_Cost_Explore(2) = abs(Costs_Explor(2) - Costs_Explor(1)); % Eq (6)
    Seq_Cost_Exploit(2) = abs(Costs_Exploit(2) - Costs_Exploit(1)); % Eq (9)
    Seq_Cost_Explore(3) = abs(Costs_Explor(3) - Costs_Explor(2)); % Eq (7)
    Seq_Cost_Exploit(3) = abs(Costs_Exploit(3) - Costs_Exploit(2)); % Eq (10)

    for i = 1:3
        if Seq_Cost_Explore(i) ~= 0
            PF_F3 = [PF_F3, Seq_Cost_Explore(i)]; %#ok
        end
        if Seq_Cost_Exploit(i) ~= 0
            PF_F3 = [PF_F3, Seq_Cost_Exploit(i)]; %#ok
        end
    end

    % F1 and F2 Exploration/Exploitation Calculations
    F1_Explor = PF(1) * (Seq_Cost_Explore(1) / Seq_Time_Explore(1)); % Eq (1)
    F1_Exploit = PF(1) * (Seq_Cost_Exploit(1) / Seq_Time_Exploit(1)); % Eq (2)
    F2_Explor = PF(2) * (sum(Seq_Cost_Explore) / sum(Seq_Time_Explore)); % Eq (3)
    F2_Exploit = PF(2) * (sum(Seq_Cost_Exploit) / sum(Seq_Time_Exploit)); % Eq (4)

    Score_Explore = (PF(1) * F1_Explor) + (PF(2) * F2_Explor); % Eq (11)
    Score_Exploit = (PF(1) * F1_Exploit) + (PF(2) * F2_Exploit); % Eq (12)

    %% Experienced Phase
    for Iter = 4:MaxIter
        % Exploration vs Exploitation Decision
        if Score_Explore > Score_Exploit
            SelectFlag = 1;
            Sol = Exploration(Sol, lb, ub, dim, nSol, CostFunction);
            UnSelected(2) = UnSelected(2) + 1;
            UnSelected(1) = 1;
            F3_Explore = PF(3);
            [~, TBind] = min([Sol.Cost]);
            TBest = Sol(TBind);
            Seq_Cost_Explore = circshift(Seq_Cost_Explore, 1);
            Seq_Cost_Explore(1) = abs(Best.Cost - TBest.Cost);
            if Seq_Cost_Explore(1) ~= 0
                PF_F3 = [PF_F3, Seq_Cost_Explore(1)]; %#ok
            end
            if TBest.Cost < Best.Cost
                Best = TBest;
            end
        else
            SelectFlag = 2;
            Sol = Exploitation(Sol, lb, ub, dim, nSol, Best, MaxIter, Iter, CostFunction);
            UnSelected(1) = UnSelected(1) + 1;
            UnSelected(2) = 1;
            F3_Exploit = PF(3);
            [~, TBind] = min([Sol.Cost]);
            TBest = Sol(TBind);
            Seq_Cost_Exploit = circshift(Seq_Cost_Exploit, 1);
            Seq_Cost_Exploit(1) = abs(Best.Cost - TBest.Cost);
            if Seq_Cost_Exploit(1) ~= 0
                PF_F3 = [PF_F3, Seq_Cost_Exploit(1)]; %#ok
            end
            if TBest.Cost < Best.Cost
                Best = TBest;
            end
        end

        % Update Hyperparameters
        if Flag_Change ~= SelectFlag
            Flag_Change = SelectFlag;
            Seq_Time_Explore = circshift(Seq_Time_Explore, 1);
            Seq_Time_Explore(1) = UnSelected(1);
            Seq_Time_Exploit = circshift(Seq_Time_Exploit, 1);
            Seq_Time_Exploit(1) = UnSelected(2);
        end

        % Update Scores
        Mega_Explor = max((Mega_Explor - 0.01), 0.01);
        Mega_Exploit = max((Mega_Exploit - 0.01), 0.01);
        Score_Explore = (Mega_Explor * F1_Explor) + (Mega_Explor * F2_Explor) + ((1 - Mega_Explor) * (min(PF_F3) * F3_Explore));
        Score_Exploit = (Mega_Exploit * F1_Exploit) + (Mega_Exploit * F2_Exploit) + ((1 - Mega_Exploit) * (min(PF_F3) * F3_Exploit));

        % Store Best Cost
        Convergence_PUMA(Iter) = Best.Cost;
        disp(['Iteration: ' num2str(Iter) ' Best Cost = ' num2str(Best.Cost)]);
    end

    Puma_C = Best.Cost;
    Puma_X = Best.X;
end





function [Leader_score, Leader_pos, Convergence_curve_HBO] = HBO(problem, params)
    % Extract Problem Details
    CostFunction = problem.CostFunction;
    nVar = problem.nVar;
    VarMin = problem.VarMin;
    VarMax = problem.VarMax;

    % Extract Parameters
    Max_iter = params.MaxIt;
    searchAgents = params.nPop;

    % Initialize Variables
    global cycles
    global degree
    cycles = floor(Max_iter / 25); % Default cycle value
    degree = 3; % Default degree value

    treeHeight = ceil((log10(searchAgents * degree - searchAgents + 1) / log10(degree)));
    fevals = 0;

    % Initialize leader position and score
    Leader_pos = zeros(1, nVar);
    Leader_score = inf;

    % Initialize search agent positions
    Solutions = initialization(searchAgents, nVar, VarMax, VarMin);

    % Initialize fitness heap
    fitnessHeap = zeros(searchAgents, 2) + inf;

    % Build initial heap
    for c = 1:searchAgents
        fitness = CostFunction(Solutions(c, :));
        fevals = fevals + 1;
        fitnessHeap(c, 1) = fitness;
        fitnessHeap(c, 2) = c;

        % Heapify
        t = c;
        while t > 1
            parentInd = floor((t + 1) / degree);
            if fitnessHeap(t, 1) >= fitnessHeap(parentInd, 1)
                break;
            else
                tempFitness = fitnessHeap(t, :);
                fitnessHeap(t, :) = fitnessHeap(parentInd, :);
                fitnessHeap(parentInd, :) = tempFitness;
            end
            t = parentInd;
        end

        % Update leader
        if fitness <= Leader_score
            Leader_score = fitness;
            Leader_pos = Solutions(c, :);
        end
    end

    % Main loop
    Convergence_curve_HBO = zeros(1, Max_iter);
    itPerCycle = Max_iter / cycles;
    qtrCycle = itPerCycle / 4;
    colleaguesLimits = colleaguesLimitsGenerator(degree, searchAgents);

    for it = 1:Max_iter
        gamma = abs(2 - (mod(it, itPerCycle) / qtrCycle));

        for c = searchAgents:-1:2
            if c == 1
                continue;
            else
                parentInd = floor((c + 1) / degree);
                curSol = Solutions(fitnessHeap(c, 2), :);
                parentSol = Solutions(fitnessHeap(parentInd, 2), :);

                if colleaguesLimits(c, 2) > searchAgents
                    colleaguesLimits(c, 2) = searchAgents;
                end
                colleagueInd = c;
                while colleagueInd == c
                    colleagueInd = randi([colleaguesLimits(c, 1) colleaguesLimits(c, 2)]);
                end
                colleagueSol = Solutions(fitnessHeap(colleagueInd, 2), :);

                % Update position
                for j = 1:nVar
                    p1 = (1 - it / Max_iter);
                    p2 = p1 + (1 - p1) / 2;
                    r = rand();
                    rn = (2 * rand() - 1);

                    if r < p1
                        continue;
                    elseif r < p2
                        D = abs(parentSol(j) - curSol(j));
                        curSol(1, j) = parentSol(j) + rn * gamma * D;
                    else
                        if fitnessHeap(colleagueInd, 1) < fitnessHeap(c, 1)
                            D = abs(colleagueSol(j) - curSol(j));
                            curSol(1, j) = colleagueSol(j) + rn * gamma * D;
                        else
                            D = abs(colleagueSol(j) - curSol(j));
                            curSol(1, j) = curSol(j) + rn * gamma * D;
                        end
                    end
                end
            end

            % Boundary check
            Flag4ub = curSol(1, :) > VarMax;
            Flag4lb = curSol(1, :) < VarMin;
            curSol(1, :) = (curSol(1, :) .* (~(Flag4ub + Flag4lb))) + VarMax .* Flag4ub + VarMin .* Flag4lb;

            % Fitness evaluation
            newFitness = CostFunction(curSol);
            fevals = fevals + 1;
            if newFitness < fitnessHeap(c, 1)
                fitnessHeap(c, 1) = newFitness;
                Solutions(fitnessHeap(c, 2), :) = curSol;
            end
            if newFitness < Leader_score
                Leader_score = newFitness;
                Leader_pos = curSol;
            end

            % Heapify
            t = c;
            while t > 1
                parentInd = floor((t + 1) / degree);
                if fitnessHeap(t, 1) >= fitnessHeap(parentInd, 1)
                    break;
                else
                    tempFitness = fitnessHeap(t, :);
                    fitnessHeap(t, :) = fitnessHeap(parentInd, :);
                    fitnessHeap(parentInd, :) = tempFitness;
                end
                t = parentInd;
            end
        end

        Convergence_curve_HBO(it) = Leader_score;
        [fevals, Leader_score];
    end
end



function [Leader_score_WOA, Leader_pos_WOA, Convergence_curve_WOA] = WOA(problem, params)
    % Extract problem and parameters
    fobj = problem.CostFunction;        % Objective function
    SearchAgents_no = params.nPop;      % Number of search agents
    Max_iter = params.MaxIt;            % Maximum number of iterations
    lb = problem.VarMin;                % Lower bound
    ub = problem.VarMax;                % Upper bound
    dim = problem.nVar;                 % Dimension of the problem
    
    % Initialize position vector and score for the leader
    Leader_pos_WOA = zeros(1, dim);
    Leader_score_WOA = inf;                 % Change this to -inf for maximization problems
    
    % Initialize the positions of search agents
    Positions = initialization(SearchAgents_no, dim, ub, lb);
    Convergence_curve_WOA = zeros(1, Max_iter);
    t = 0; % Loop counter
    
    % Main loop
    while t < Max_iter
        for i = 1:size(Positions, 1)
            % Return back the search agents that go beyond the boundaries of the search space
            Flag4ub = Positions(i, :) > ub;
            Flag4lb = Positions(i, :) < lb;
            Positions(i, :) = (Positions(i, :) .* ~(Flag4ub + Flag4lb)) + ub .* Flag4ub + lb .* Flag4lb;
            
            % Calculate objective function for each search agent
            fitness = fobj(Positions(i, :));
            
            % Update the leader
            if fitness < Leader_score_WOA % Change this to > for maximization problems
                Leader_score_WOA = fitness; % Update alpha
                Leader_pos_WOA = Positions(i, :);
            end
        end
        
        a = 2 - t * ((2) / Max_iter); % a decreases linearly from 2 to 0 in Eq. (2.3)
        
        % a2 linearly decreases from -1 to -2 to calculate t in Eq. (3.12)
        a2 = -1 + t * ((-1) / Max_iter);
        
        % Update the Position of search agents
        for i = 1:size(Positions, 1)
            r1 = rand(); % r1 is a random number in [0, 1]
            r2 = rand(); % r2 is a random number in [0, 1]
            
            A = 2 * a * r1 - a;  % Eq. (2.3) in the paper
            C = 2 * r2;          % Eq. (2.4) in the paper
            
            b = 1;               % Parameters in Eq. (2.5)
            l = (a2 - 1) * rand + 1;   % Parameters in Eq. (2.5)
            
            p = rand();          % p in Eq. (2.6)
            
            for j = 1:size(Positions, 2)
                if p < 0.5   
                    if abs(A) >= 1
                        rand_leader_index = floor(SearchAgents_no * rand() + 1);
                        X_rand = Positions(rand_leader_index, :);
                        D_X_rand = abs(C * X_rand(j) - Positions(i, j)); % Eq. (2.7)
                        Positions(i, j) = X_rand(j) - A * D_X_rand;      % Eq. (2.8)
                    elseif abs(A) < 1
                        D_Leader = abs(C * Leader_pos_WOA(j) - Positions(i, j)); % Eq. (2.1)
                        Positions(i, j) = Leader_pos_WOA(j) - A * D_Leader;      % Eq. (2.2)
                    end
                elseif p >= 0.5
                    distance2Leader = abs(Leader_pos_WOA(j) - Positions(i, j));
                    % Eq. (2.5)
                    Positions(i, j) = distance2Leader * exp(b .* l) .* cos(l .* 2 * pi) + Leader_pos_WOA(j);
                end
            end
        end
        
        t = t + 1;
        Convergence_curve_WOA(t) = Leader_score_WOA;
        disp([t, Leader_score_WOA]);
    end
end


