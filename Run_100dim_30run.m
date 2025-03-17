% Optimization Algorithms Comparison
clear; clc; close all;

% Optimization Algorithms Comparison

Problems = arrayfun(@(x) ['F', num2str(x)], 1:13, 'UniformOutput', false);
results = struct;  % Initialize the results structure
run_no = 30;

for p = 1:numel(Problems)
    i = Problems{p};  % Current problem identifier
    fprintf('Running Optimization for Problem %s\n', i);

    % Define problem
    [lb, ub, dim, fobj] = Functions_100(i);

    %% Problem Definition
    problem.CostFunction = fobj;
    problem.nVar = dim;    % Dimension
    problem.VarMin = lb;   % Lower Bound
    problem.VarMax = ub;   % Upper Bound

    %% Optimization Parameters
    params.MaxIt = 1000;    % Max Iterations
    params.nPop = 50;     % Population Size
    params.Display = false; % Disable intermediate display for better performance

    % Initialize structures to store multiple runs
    all_results = struct('GA', [], 'PSO', [], 'GWO', [], 'ACOR', [], 'SA', [], 'MHO', [], 'WO', [], 'Puma', [], 'HBO', [], 'WOA', [],'ACO',[],'SWO',[]);

    % Run each algorithm for 'run_no' times
    for run = 1:run_no
        fprintf('Run %d/%d for Problem %s\n', run, run_no, i);

        % Run MHO_Adaptive
        startCPU = cputime;
        [BestSol, BestCost, Convergence] = MHO_Adaptive(problem, params);
        cpuTimeMHO = cputime - startCPU;
        all_results.MHO = [all_results.MHO; struct('BestCost', BestCost, 'Convergence', Convergence ,'Cpu_times', cpuTimeMHO)];
        

        % Run GA
        startCPU = cputime;
        [BestSol_GA, BestCost_GA, Conv_GA] = GA(problem, params);
        cpuTimeGA = cputime - startCPU;
        all_results.GA = [all_results.GA; struct('BestCost', BestCost_GA, 'Convergence', Conv_GA,'Cpu_times', cpuTimeGA)];

        % Run PSO
        startCPU = cputime;
        [BestSol_PSO, BestCost_PSO, Conv_PSO] = PSO(problem, params);
        cpuTimePSO = cputime - startCPU;
        all_results.PSO = [all_results.PSO; struct('BestCost', BestCost_PSO, 'Convergence', Conv_PSO,'Cpu_times', cpuTimePSO)];

        % Run GWO
        startCPU = cputime;
        [BestSol_GWO, BestCost_GWO, Conv_GWO] = GWO(problem, params);
        cpuTimeGWO = cputime - startCPU;
        all_results.GWO = [all_results.GWO; struct('BestCost', BestCost_GWO, 'Convergence', Conv_GWO,'Cpu_times', cpuTimeGWO)];

        % Run ACOR
        startCPU = cputime;
        [BestCost_ACO, BestTour_ACO] = ACOR(problem, params);
        cpuTimeACOR = cputime - startCPU;
        all_results.ACOR = [all_results.ACOR; struct('BestCost', BestCost_ACO, 'Cpu_times', cpuTimeACOR)];

        % Run SA
        startCPU = cputime;
        [BestSol_SA, BestCost_SA, Conv_SA] = SA(problem, params);
        cpuTimeSA = cputime - startCPU;
        all_results.SA = [all_results.SA; struct('BestCost', BestCost_SA, 'Convergence', Conv_SA,'Cpu_times', cpuTimeSA)];

        % Run WO
        startCPU = cputime;
        [Best_Score, Best_Pos, Convergence_curve_WO] = WO_NEW(problem, params);
        cpuTimeWO = cputime - startCPU;
        all_results.WO = [all_results.WO; struct('BestCost', Best_Score, 'Convergence', Convergence_curve_WO,'Cpu_times', cpuTimeWO)];

        % Run Puma
        startCPU = cputime;
        [Puma_X, Puma_C, Convergence_PUMA] = Puma_new(params, problem);
        cpuTimePuma = cputime - startCPU;
        all_results.Puma = [all_results.Puma; struct('BestCost', Puma_C, 'Convergence', Convergence_PUMA,'Cpu_times', cpuTimePuma)];

        % Run HBO
        startCPU = cputime;
        [Leader_score, Leader_pos, Convergence_curve_HBO] = HBO(problem, params);
        cpuTimeHBO = cputime - startCPU;
        all_results.HBO = [all_results.HBO; struct('BestCost', Leader_score, 'Convergence', Convergence_curve_HBO,'Cpu_times', cpuTimeHBO)];

        % Run WOA
        startCPU = cputime;
        [Leader_score_WOA, Leader_pos_WOA, Convergence_curve_WOA] = WOA(problem, params);
        cpuTimeWOA = cputime - startCPU;
        all_results.WOA = [all_results.WOA; struct('BestCost', Leader_score_WOA, 'Convergence', Convergence_curve_WOA,'Cpu_times', cpuTimeWOA)];

        % Run SWO
        startCPU = cputime;
        [Best_score,Best_SW,Convergence_curve]=SWO(problem,params);
        cpuTimeSWO = cputime - startCPU;
        all_results.SWO = [all_results.SWO; struct('BestCost', Best_score, 'Convergence', Convergence_curve ,'Cpu_times', cpuTimeSWO)];
    end

    % Aggregate results for the current problem
    results(p).Problem = i;  % Save problem identifier
    results(p).GA = aggregate_results(all_results.GA);
    results(p).PSO = aggregate_results(all_results.PSO);
    results(p).GWO = aggregate_results(all_results.GWO);
%     results(p).ABC = aggregate_results(all_results.ABC);
    results(p).SA = aggregate_results(all_results.SA);
    results(p).MHO = aggregate_results(all_results.MHO);
    results(p).WO = aggregate_results(all_results.WO);
    results(p).Puma = aggregate_results(all_results.Puma);
    results(p).HBO = aggregate_results(all_results.HBO);
    results(p).WOA = aggregate_results(all_results.WOA);
    results(p).ACOR = aggregate_results(all_results.ACOR);
    results(p).SWO = aggregate_results(all_results.SWO);
end

% Save all results
save('optimization_results_13poblem_30runs_100dim.mat', 'results');

%% Helper function to aggregate results
function aggregated = aggregate_results(runs)
    costs = arrayfun(@(x) x.BestCost, runs);
    cpu_times = arrayfun(@(x) x.Cpu_times, runs);
    convergences = vertcat(costs);
    aggregated.BestCost = min(costs);
    aggregated.MeanCost = mean(costs);
    aggregated.StdCost = std(costs);
    aggregated.MeanCpuTime = mean(cpu_times);
    aggregated.Convergence = convergences; % Average convergence curve
end


%% MHO
function [BestSol, BestCost, Convergence] = MHO_Adaptive(problem, params)
    % Extract Problem Information
    CostFunction = problem.CostFunction;
    nVar = problem.nVar;            % Number of Decision Variables
    VarMin = problem.VarMin;        % Lower Bound of Variables
    VarMax = problem.VarMax;        % Upper Bound of Variables  

    % Algorithm Parameters
    MaxIt = params.MaxIt;           % Maximum Number of Iterations
    nPop = round(params.nPop);             % Population Size params.nPop   
   
    % Initialize Best Solution Ever Found
    Hunter1st_rank.Cost = inf;
   
    Convergence = zeros(MaxIt, 1);  % Array to store best cost at each iteration
    
    positions = VarMin + (VarMax - VarMin) .* rand(nPop, nVar);    
    if isequal(size(VarMax),[1,1])
        VarMin = VarMin .* ones(1,nVar);
        VarMax = VarMax .* ones(1,nVar);
    end
    mid_bound = (VarMax + VarMin)/2;
        
    IS_max = 0.9;
    IS_min = 0.2;
    safety_sum = 0;
    stun_gauge = 10 ;
    range_weapon = 0.2*(VarMax - VarMin); 



    Hunter = struct('role', [], 'Position', [], 'Cost', [] , 'Dim_chose',[]);
    
    role = {'BladeMaster' , 'frontline' , 'Supporter' , 'Ranger'};

    N = round(nPop/4);  
       
    for i = 1:nPop
        Hunter(i).Position = positions(i, :);  % นำตำแหน่งที่เรียงแล้วใส่ใน Hunter
        Hunter(i).Cost = CostFunction(Hunter(i).Position);  % เก็บค่า cost ที่เรียงแล้ว  
        Hunter(i).Best.Cost = inf;
        dim_choose = randi(nVar);
        Hunter(i).Dim_chose = dim_choose;
        
        if (i<=N)
            Hunter(i).role = role{1};                                
        elseif (i>N && i<=N*2)
            Hunter(i).role = role{2};
        elseif (i>N*2 && i<=N*3)
            Hunter(i).role = role{3};
        else 
            Hunter(i).role = role{4};
        end

        if Hunter(i).Cost < Hunter1st_rank.Cost
            Hunter1st_rank = Hunter(i);
        end

    end
   
    
    matches_BladeMaster = find(cellfun(@(b) isequal(b, 'BladeMaster'), {Hunter.role}));          
    matches_frontline = find(cellfun(@(b) isequal(b, 'frontline'), {Hunter.role}));          
    matches_Ranger = find(cellfun(@(b) isequal(b, 'Ranger'), {Hunter.role}));          
    matches_Supporter = find(cellfun(@(b) isequal(b, 'Supporter'), {Hunter.role}));

    [sortcost,indexcost] = sort([Hunter(1:nPop).Cost],'ascend');
    


    
    %ค้นหา และ ตีจุดอ่อน
    for u = 1:MaxIt

        %เคลื่อนที่ด้วยตัวเอง BladeMaster          
              
        %range_run = IS_max - IS_min;

        %IS1 = IS_max - range_run*(u-1)/((MaxIt));
        %IS2 =  IS_min + range_run*(u-1)/((MaxIt));
        
        for i = matches_BladeMaster            
            pos = Hunter(i).Position;     
            Delta1 = pos + 0.1*(Hunter1st_rank.Position - pos);
            Test_Delta1 = Delta1;  
            
            
            %ตีเช็ค
            if u < 30
                for j = 1:nVar
                    dim = Test_Delta1(j);
                    range_mid = mid_bound(j) - dim;
                    opposie_dim = mid_bound(j)+range_mid;                     
                    
                    new_dim_plus = dim + (0.8*rand()+0.1)*(opposie_dim-dim);
                    new_dim_minus = dim - (0.8*rand()+0.1)*(opposie_dim-dim);

                    new_dim_plus = max(VarMin(j), min(VarMax(j), new_dim_plus));
                    new_dim_minus = max(VarMin(j), min(VarMax(j), new_dim_minus));
                    

                    Test_Delta1(j) = new_dim_plus;
                    cost_plus = CostFunction(Test_Delta1); 
                    Test_Delta1(j) = new_dim_minus;
                    cost_minus = CostFunction(Test_Delta1);
                    if cost_plus < cost_minus
                        Test_Delta1(j) = new_dim_plus;
                    end
                    
                end 
                Hunter(i).Position = Test_Delta1;                
                Hunter(i).Cost = CostFunction(Hunter(i).Position);
                


            %สำรวจต่อ
            else
               for j = 1:nVar
                    dim = Test_Delta1(j);
                    range_mid = Hunter1st_rank.Position(j) - dim;
                    opposie_dim = Hunter1st_rank.Position(j)+range_mid;  
                   
                    
                    new_dim_plus = dim + (0.8*rand()+0.1)*(opposie_dim-dim);
                    new_dim_minus = dim - (0.8*rand()+0.1)*(opposie_dim-dim);

                    new_dim_plus = max(VarMin(j), min(VarMax(j), new_dim_plus));
                    new_dim_minus = max(VarMin(j), min(VarMax(j), new_dim_minus));
                    

                    Test_Delta1(j) = new_dim_plus;
                    cost_plus = CostFunction(Test_Delta1); 
                    Test_Delta1(j) = new_dim_minus;
                    cost_minus = CostFunction(Test_Delta1);
                    if cost_plus < cost_minus
                        Test_Delta1(j) = new_dim_plus;
                    end
                    
                end 
                Hunter(i).Position = Test_Delta1;                
                Hunter(i).Cost = CostFunction(Hunter(i).Position);
            end
            if Hunter(i).Cost < Hunter1st_rank.Cost
                Hunter1st_rank = Hunter(i);
            end
            
        end  
        
       
        
       %เคลื่อนที่ด้วย frontline            

       for i = matches_frontline            
            pos = Hunter(i).Position; 
            Delta1 = pos + 0.2 * (Hunter1st_rank.Position - pos);
            Test_Delta1 = Delta1;
            new_pos = Test_Delta1;
            r = rand();            
        
            if r > 0.5
                new_pos = Test_Delta1*exp(-0.1*(u-1));
            else
                for j = 1:nVar
                    sign = 2* randi([0,1]) - 1;
                    new_pos(j) = Test_Delta1(j) * sign;
                end
                

            end
            
            Hunter(i).Position = max(VarMin, min(VarMax, new_pos)); % จำกัดค่าขอบเขต
            Hunter(i).Cost = CostFunction(Hunter(i).Position); 
        
            if Hunter(i).Cost < Hunter1st_rank.Cost
                Hunter1st_rank = Hunter(i);
            end            
        end 

       

     %วงล้อมรอบจุดอ่อนที่ดีที่สุด เดี๋ยวมาหาใหม่ เอาวงกลมหุบกาง Ranger        
     

     Hbest = Hunter1st_rank.Position;

     
     for i = matches_Ranger
         
         safety_factor = rand()*4;
         pos = Hunter(i).Position;
         

         if safety_sum > stun_gauge %บอสติดสตั้น เลยเข้ามาตีใกล้ๆ
             new_pos_plus = Hbest +  (0.2*rand()+0.1) .* (pos - Hbest) ;
             new_pos_minus = Hbest -  (0.2*rand()+0.1) .* (pos - Hbest) ;
             new_pos_plus = max(VarMin, min(VarMax, new_pos_plus));
             new_pos_minus = max(VarMin, min(VarMax, new_pos_minus));
             cost_plus = CostFunction(new_pos_plus);
             cost_minus = CostFunction(new_pos_minus);
             
             if cost_plus < cost_minus && cost_plus<Hunter(i).Cost
                 Hunter(i).Position = new_pos_plus ;
             elseif cost_minus < cost_plus && cost_minus<Hunter(i).Cost
                 Hunter(i).Position = new_pos_minus;                     
             end
             
         elseif safety_sum < stun_gauge %บอสโจมตีไปมา ต้องทิ้งระยะเพื่อความปลอดภัย
             new_pos_plus = Hbest + rand() * (range_weapon) ;
             new_pos_minus = Hbest - rand() * (range_weapon) ;
             new_pos_plus = max(VarMin, min(VarMax, new_pos_plus));
             new_pos_minus = max(VarMin, min(VarMax, new_pos_minus));
             cost_plus = CostFunction(new_pos_plus);
             cost_minus = CostFunction(new_pos_minus);
             if cost_plus < cost_minus && cost_plus<Hunter(i).Cost
                 Hunter(i).Position = new_pos_plus ;
             elseif cost_minus < cost_plus && cost_minus<Hunter(i).Cost
                 Hunter(i).Position = new_pos_minus;
             end
             
                 
         end          
                    
         Hunter(i).Cost = CostFunction(Hunter(i).Position);
         if Hunter(i).Cost < Hunter1st_rank.Cost
            Hunter1st_rank = Hunter(i);
         end
         
     end
     if safety_sum>stun_gauge
         safety_sum = 0;
     end
     safety_sum = safety_sum + safety_factor;
     

         
       %เคลื่อนที่ด้วย Supporter      
       
    
       for i = matches_Supporter
           pos = Hunter(i).Position;
           
           distance_from_Hbest = pos - Hunter1st_rank.Position;

           if rand() < 0.5
               new_pos = Hunter1st_rank.Position + (0.4*rand()+0.1).*distance_from_Hbest;
           else
               new_pos = Hunter1st_rank.Position - (0.4*rand()+0.1).*distance_from_Hbest;
           end
           
           Hunter(i).Position = new_pos;
           Hunter(i).Position = max(VarMin, min(VarMax, Hunter(i).Position));
           Hunter(i).Cost = CostFunction(Hunter(i).Position);
           if Hunter(i).Cost < Hunter1st_rank.Cost
                Hunter1st_rank = Hunter(i);
           end
           
           
       end      
       
       
        Convergence(u) = Hunter1st_rank.Cost;
        
    end   
    
   
   
    
 % Store the best cost of this iteration in Convergence
disp(['Iteration ' num2str(u) ': Best Cost = ' num2str(Convergence(u))]);

BestSol = Hunter1st_rank.Position;

BestCost = Hunter1st_rank.Cost;
             
                 
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
            K = [1:i-1, i+1:nPop];
            if ~isempty(K)
                k = K(randi([1 numel(K)]));
            else
                k = randi([1 nPop]);
            end
            
            % New Bee Position
            phi = unifrnd(-1, +1, [1 nVar]);
            if ~isempty(pop(k).Position) % Check if k's position is not empty
                newbee.Position = pop(i).Position + phi .* (pop(i).Position - pop(k).Position);
            else
                continue; % Skip this iteration if k's position is empty
            end
            
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
        
        % Check for NaN or Inf in MeanCost
        if isinf(MeanCost) || isnan(MeanCost)
            error('MeanCost is NaN or Inf. Check the cost values.');
        end
        
        for i = 1:nPop
            F(i) = exp(-pop(i).Cost / MeanCost);
        end
        
        % Check if F contains valid values
        if any(isnan(F)) || any(isinf(F))
            error('Fitness values contain NaN or Inf. Check the cost values.');
        end
        
        P = F / sum(F);
        
        % Onlooker Bees
        for m = 1:nOnlooker
            % Select Source Site
            i = RouletteWheelSelection(P);
            
            % Choose k randomly, not equal to i
            K = [1:i-1, i+1:nPop];
            if ~isempty(K)
                k = K(randi([1 numel(K)]));
            else
                k = randi([1 nPop]);
            end
            
            % New Bee Position
            phi = unifrnd(-1, +1, [1 nVar]);
            if ~isempty(pop(k).Position) % Check if k's position is not empty
                newbee.Position = pop(i).Position + phi .* (pop(i).Position - pop(k).Position);
            else
                continue; % Skip this iteration if k's position is empty
            end
            
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

function [BestCost_ACO, BestTour_ACO] = ACOR(problem, params)

    CostFunction=problem.CostFunction;       % Cost Function
    nVar=problem.nVar;             % Number of Decision Variables
    VarSize=[1 nVar];   % Variables Matrix Size
    VarMin=problem.VarMin;         % Decision Variables Lower Bound
    VarMax= problem.VarMax;         % Decision Variables Upper Bound
    %% ACOR Parameters
    MaxIt=params.MaxIt;          % Maximum Number of Iterations
    nPop=params.nPop;            % Population Size (Archive Size)
    nSample=40;         % Sample Size
    q=0.5;              % Intensification Factor (Selection Pressure)
    zeta=1;             % Deviation-Distance Ratio
    %% Initialization
    % Create Empty Individual Structure
    empty_individual.Position=[];
    empty_individual.Cost=[];
    % Create Population Matrix
    pop=repmat(empty_individual,nPop,1);
    % Initialize Population Members
    for i=1:nPop
        
        % Create Random Solution
        pop(i).Position=unifrnd(VarMin,VarMax,VarSize);
        
        % Evaluation
        pop(i).Cost=CostFunction(pop(i).Position);
        
    end
    % Sort Population
    [~, SortOrder]=sort([pop.Cost]);
    pop=pop(SortOrder);
    % Update Best Solution Ever Found
    BestSol=pop(1);
    % Array to Hold Best Cost Values
    BestCost=zeros(MaxIt,1);
    % Solution Weights
    w=1/(sqrt(2*pi)*q*nPop)*exp(-0.5*(((1:nPop)-1)/(q*nPop)).^2);
    % Selection Probabilities
    p=w/sum(w);
    %% ACOR Main Loop
    for it=1:MaxIt
        
        % Means
        s=zeros(nPop,nVar);
        for l=1:nPop
            s(l,:)=pop(l).Position;
        end
        
        % Standard Deviations
        sigma=zeros(nPop,nVar);
        for l=1:nPop
            D=0;
            for r=1:nPop
                D=D+abs(s(l,:)-s(r,:));
            end
            sigma(l,:)=zeta*D/(nPop-1);
        end
        
        % Create New Population Array
        newpop=repmat(empty_individual,nSample,1);
        for t=1:nSample
            
            % Initialize Position Matrix
            newpop(t).Position=zeros(VarSize);
            
            % Solution Construction
            for i=1:nVar
                
                % Select Gaussian Kernel
                l=RouletteWheelSelection(p);
                
                % Generate Gaussian Random Variable
                newpop(t).Position(i)=s(l,i)+sigma(l,i)*randn;
                
            end
            
            % Evaluation
            newpop(t).Cost=CostFunction(newpop(t).Position);
            
        end
        
        % Merge Main Population (Archive) and New Population (Samples)
        pop=[pop
             newpop]; %#ok
         
        % Sort Population
        [~, SortOrder]=sort([pop.Cost]);
        pop=pop(SortOrder);
        
        % Delete Extra Members
        pop=pop(1:nPop);
        
        % Update Best Solution Ever Found
        BestSol=pop(1);
        
        % Store Best Cost
        BestCost(it)=BestSol.Cost;
        
        % Show Iteration Information
        disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
        
    end
    BestTour_ACO = BestSol.Position;
    BestCost_ACO = BestSol.Cost;
    
end

%% The Spider Wasp Optimizer
function [Best_score,Best_SW,Convergence_curve]=SWO(problem,params)
SearchAgents_no = params.nPop;
Tmax = params.MaxIt;
ub = problem.VarMax;
lb = problem.VarMin;
dim = problem.nVar;
fobj = problem.CostFunction;
fhd = problem.CostFunction;
if isequal(size(ub),[1,1])
    lb = lb .* ones(1,dim);
    ub = ub .* ones(1,dim);
end


Best_SW=zeros(1,dim); % A vector to include the best-so-far spider wasp(Solution) 
Best_score=inf; % A Scalar variable to include the best-so-far score
Convergence_curve=zeros(1,Tmax);
%%-------------------Controlling parameters--------------------------%%
%%
TR=0.3; %% Representing the trade-off probability between hunting and mating behaviours.
Cr=0.2; %% The Crossover probability
N_min=20; %% Representing the minimum population size.
%%---------------Initialization----------------------%%
%%
Positions=initialization(SearchAgents_no,dim,ub,lb); % Initialize the positions of spider wasps
t=0; %% Function evaluation counter 
%%---------------------Evaluation-----------------------%%
for i=1:SearchAgents_no
    %% Test suites of CEC-2014, CEC-2017, CEC-2020, and CEC-2022
    SW_Fit(i)=feval(fobj, Positions(i,:));    
    % Update the best-so-far solution
    if SW_Fit(i)<Best_score % Change this to > for maximization problem
       Best_score=SW_Fit(i); % Update the best-so-far score
       Best_SW=Positions(i,:); % Update te best-so-far solution
    end
end
% Main loop
while t<Tmax
    %%
    a=2-2*(t/Tmax); % a decreases linearly from 2 to 0
    a2=-1+-1*(t/Tmax); % a2 linearly dicreases from -1 to -2 to calculate l in Eq. (8)
    k=(1-t/Tmax); %% k decreases linearly from 1 to 0 (Eq. (13))
    JK=randperm(SearchAgents_no); %% A randomly-generated permutation of the search agent's indices 
    if rand<TR %% 3.2	Hunting and nesting behavior
       % Update the Position of search agents
       for i=1:SearchAgents_no
          r1=rand(); % r1 is a random number in [0,1]
          r2=rand(); % r2 is a random number in [0,1]
          r3=rand(); % r3 is a random number in [0,1]
          p = rand();  % p is a random number in [0,1]
          C=a*(2*r1-1);  % Eq. (11) in the paper
          l=(a2-1)*rand+1;   % The parameter in Eqs. (7) and (8)
          L=Levy(1); %% L is a Levy-based number 
          vc = unifrnd(-k,k,1,dim); %% The vector in Eq. (12)
          rn1=randn; %% rn1 is a normal distribution-based number 
          %%
          O_P=Positions(i,:); %% Storing the current position of the ith solution
          %%
          for j=1:size(Positions,2)
            if i<k*SearchAgents_no
               if p<(1-t/Tmax) %% 3.2.1	Searching stage (Exploration)
                   if r1<r2
                      m1=abs(rn1)*r1; %% Eq. (5)
                      Positions(i,j)=Positions(i,j)+m1*(Positions(JK(1),j)-Positions(JK(2),j)); %% Eq. (4)
                   else
                      B=1/(1+exp(l)); %% Eq. (8)
                      m2=B*cos(l*2*pi); %% Eq. (7) 
                      Positions(i,j)=Positions(JK(i),j)+m2*(lb(j)+rand*(ub(j)-lb(j))); %% Eq. (6)
                   end %% End If
               else %% 3.2.2	Following and escaping stage (exploration and exploitation)
                   if r1<r2
                      Positions(i,j)=Positions(i,j)+C*abs(2*rand*Positions(JK(3),j)-Positions(i,j)); %% Eq. (10)
                   else
                      Positions(i,j)=Positions((i),j).*vc(j); %% Eq. (12)
                   end %% End If
               end
             else
                 if r1<r2
                     Positions(i,j)=Best_SW(j)+cos(2*l*pi)*(Best_SW(j)-Positions(i,j));      % Eq. (16)
                 else
                     Positions(i,j)=Positions(JK(1),j)+r3*abs(L)*(Positions(JK(1),j)-Positions(i,j))+(1-r3)*(rand>rand)*(Positions(JK(3),j)-Positions(JK(2),j));      % Eq. (17)
                 end %% End if
            end %% End if
          end %% End Inner If
          %% Return the search agents that exceed the search space's bounds
          for j=1:size(Positions,2)
              if  Positions(i,j)>ub(j)
                   Positions(i,j)=lb(j)+rand*(ub(j)-lb(j));
              elseif  Positions(i,j)<lb(j)
                   Positions(i,j)=lb(j)+rand*(ub(j)-lb(j));
              end
          end   
          SW_Fit1=feval(fhd, Positions(i,:)); %% The fitness value of the newly generated spider
          % Memory Saving and Updating the best-so-far solution
          if SW_Fit1<SW_Fit(i) % Change this to > for maximization problem
               SW_Fit(i)=SW_Fit1; % Update the local best fitness
               % Update the best-so-far solution
               if SW_Fit(i)<Best_score % Change this to > for maximization problem
                 Best_score=SW_Fit(i); % Update best-so-far fitness
                 Best_SW=Positions(i,:); % Update best-so-far position
               end
          else
               Positions(i,:)=O_P; %% Return the last best solution obtained by the ith solution
          end
          t=t+1;
          if t>Tmax
              break;
          end
          Convergence_curve(t)=Best_score;
       end %% Enter Outer For
       %% Mating behavior
    else     
       % Update the Position of search agents
       for i=1:SearchAgents_no
           l=(a2-1)*rand+1;    %% The parameter in Eqs. (7) and (8)
           SW_m=zeros(1,dim);  %% including the spider wasp male
           O_P=Positions(i,:); %% Storing the current position of the ith solution
         %% The Step sizes used to generate the male spider with a high quality    
           if SW_Fit(JK(1))<SW_Fit(i)  %Eq. (23)
              v1=Positions(JK(1),:)-Positions(i,:);  
           else
              v1=Positions(i,:)-Positions(JK(1),:);
           end
           if SW_Fit(JK(2))<SW_Fit(JK(3)) %Eq. (24)
              v2=Positions(JK(2),:)-Positions(JK(3),:);
           else
              v2=Positions(JK(3),:)-Positions(JK(2),:);
           end
           %%
           rn1=randn; %% rn1 is a normal distribution-based number 
           rn2=randn; %% rn1 is a normal distribution-based number 
           for j=1:size(Positions,2)
               SW_m(j)= Positions(i,j)+(exp(l))*abs(rn1)*v1(j)+(1-exp(l))*abs(rn2)*v2(j);      % Eq. (22)
               if(rand<Cr) %% Eq. (21)
                  Positions(i,j)=SW_m(j);
               end
           end
           %% Return the search agents that exceed the search space's bounds
           for j=1:size(Positions,2)
              if  Positions(i,j)>ub(j)
                   Positions(i,j)=lb(j)+rand*(ub(j)-lb(j));
              elseif  Positions(i,j)<lb(j)
                   Positions(i,j)=lb(j)+rand*(ub(j)-lb(j));
              end
           end   
           SW_Fit1=feval(fhd, Positions(i,:)); %% The fitness value of the newly generated spider
           % Memory Saving and Updating the best-so-far solution
           if SW_Fit1<SW_Fit(i) % Change this to > for maximization problem
               SW_Fit(i)=SW_Fit1; % Update the local best fitness
               % Update the best-so-far solution
               if SW_Fit(i)<Best_score % Change this to > for maximization problem
                 Best_score=SW_Fit(i); % Update best-so-far fitness
                 Best_SW=Positions(i,:); % Update best-so-far position
               end
           else
               Positions(i,:)=O_P; %% Return the last best solution obtained by the ith solution
           end
           t=t+1;
           if t>Tmax
              break;
           end
           Convergence_curve(t)=Best_score;
       end %% End For
    end %% End If
    %% Population reduction %%
    SearchAgents_no=fix(N_min+(SearchAgents_no-N_min)*((Tmax-t)/Tmax)); %% Eq. (25)
end %% End While
Convergence_curve(t-1)=Best_score;

end
% Draw n Levy flight sample
function L=Levy(d)
beta=3/2;
sigma=(gamma(1+beta)*sin(pi*beta/2)/(gamma((1+beta)/2)*beta*2^((beta-1)/2)))^(1/beta);
u=randn(1,d)*sigma;
v=randn(1,d);
step=u./abs(v).^(1/beta);
L=0.05*step;
end


