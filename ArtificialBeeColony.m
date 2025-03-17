function [BestSol, BestCost] = ArtificialBeeColony(CostFunction, dim, VarMin, VarMax, MaxIt, nPop)
    % Artificial Bee Colony (ABC) Algorithm
    % Inputs:
    % - CostFunction: Objective function to minimize
    % - dim: Number of decision variables (dimensions)
    % - VarMin: Lower bound for variables
    % - VarMax: Upper bound for variables
    % - MaxIt: Maximum number of iterations
    % - nPop: Population size (number of bees)
    % Outputs:
    % - BestSol: Best solution found
    % - BestCost: Best cost at each iteration

    % ABC Parameters
    nOnlooker = nPop;           % Number of Onlooker Bees
    L = round(0.6 * dim * nPop); % Abandonment Limit Parameter (Trial Limit)
    a = 1;                      % Acceleration Coefficient Upper Bound

    % Problem Dimensions
    VarSize = [1 dim];          % Decision Variable Matrix Size

    % Initialize Population
    empty_bee.Position = [];
    empty_bee.Cost = [];
    pop = repmat(empty_bee, nPop, 1);

    % Initialize Best Solution Ever Found
    BestSol.Cost = inf;

    % Create Initial Population
    for i = 1:nPop
        pop(i).Position = unifrnd(VarMin, VarMax, VarSize);
        pop(i).Cost = CostFunction(pop(i).Position);
        if pop(i).Cost <= BestSol.Cost
            BestSol = pop(i);
        end
    end

    % Abandonment Counter
    C = zeros(nPop, 1);

    % Array to Hold Best Cost Values
    BestCost = zeros(MaxIt, 1);

    % Main Loop
    for it = 1:MaxIt

        % Recruited Bees
        for i = 1:nPop
            % Choose k randomly, not equal to i
            K = [1:i-1 i+1:nPop];
            k = K(randi([1 numel(K)]));

            % Define Acceleration Coefficient
            phi = a * unifrnd(-1, +1, VarSize);

            % New Bee Position
            newbee.Position = pop(i).Position + phi .* (pop(i).Position - pop(k).Position);

            % Apply Bounds
            newbee.Position = max(min(newbee.Position, VarMax), VarMin);

            % Evaluation
            newbee.Cost = CostFunction(newbee.Position);

            % Comparison
            if newbee.Cost <= pop(i).Cost
                pop(i) = newbee;
            else
                C(i) = C(i) + 1;
            end
        end

        % Calculate Fitness Values and Selection Probabilities
        F = exp(-[pop.Cost] / mean([pop.Cost])); % Convert Cost to Fitness
        P = F / sum(F);

        % Onlooker Bees
        for m = 1:nOnlooker
            % Select Source Site
            i = RouletteWheelSelection(P);

            % Choose k randomly, not equal to i
            K = [1:i-1 i+1:nPop];
            k = K(randi([1 numel(K)]));

            % Define Acceleration Coefficient
            phi = a * unifrnd(-1, +1, VarSize);

            % New Bee Position
            newbee.Position = pop(i).Position + phi .* (pop(i).Position - pop(k).Position);

            % Apply Bounds
            newbee.Position = max(min(newbee.Position, VarMax), VarMin);

            % Evaluation
            newbee.Cost = CostFunction(newbee.Position);

            % Comparison
            if newbee.Cost <= pop(i).Cost
                pop(i) = newbee;
            else
                C(i) = C(i) + 1;
            end
        end

        % Scout Bees
        for i = 1:nPop
            if C(i) >= L
                pop(i).Position = unifrnd(VarMin, VarMax, VarSize);
                pop(i).Cost = CostFunction(pop(i).Position);
                C(i) = 0;
            end
        end

        % Update Best Solution Ever Found
        for i = 1:nPop
            if pop(i).Cost <= BestSol.Cost
                BestSol = pop(i);
            end
        end

        % Store Best Cost Ever Found
        BestCost(it) = BestSol.Cost;

        % Display Iteration Information
        disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
    end

    
end

function idx = RouletteWheelSelection(P)
    % Roulette Wheel Selection
    r = rand;
    C = cumsum(P);
    idx = find(r <= C, 1, 'first');
end
