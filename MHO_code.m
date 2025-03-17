function [Gbest, best_fitness, max_iter, convergence] = MHO_code(lb, ub, dim, max_iter, fitnessFunc)
    % Monster Hunter Algorithm with custom objective function and explicit dimensions (dim)
    
    % Default parameters
    if nargin < 1 || isempty(lb)
        lb = -10; % Default lower bound
    end
    if nargin < 2 || isempty(ub)
        ub = 10; % Default upper bound
    end
    if nargin < 3 || isempty(dim)
        dim = 2; % Default number of dimensions
    end
    if nargin < 4 || isempty(max_iter)
        max_iter = 30; % Default number of iterations
    end
    if nargin < 5 || isempty(fitnessFunc)
        fitnessFunc = @(x) sum(abs(x))+prod(abs(x)); % Default objective function (sum of squares)
    end

    % Ensure bounds are vectors of length dim
    lb = lb(:)';
    ub = ub(:)';
    if length(lb) == 1
        lb = repmat(lb, 1, dim);
    end
    if length(ub) == 1
        ub = repmat(ub, 1, dim);
    end

    % Initialize population and group allocation
    population = 50;
    frontline_ratio = 2;
    support_ratio = 1;
    long_range_ratio = 1;

    total_ratio = frontline_ratio + support_ratio + long_range_ratio;
    frontline = round(population * (frontline_ratio / total_ratio));
    support = round(population * (support_ratio / total_ratio));
    long_range = round(population * (long_range_ratio / total_ratio));
    
    % Initialize positions and velocities
    positions = lb + rand(population, dim) .* (ub - lb);
    velocities = rand(population, dim) * 5;

    % Initialize Pbest and Gbest
    Pbest = positions;
    Pbest_fitness = inf(population, 1);
    fitness = fitnessFunc(positions);
    [best_fitness, best_idx] = min(fitness);
    Gbest = positions(best_idx, :);

    % Parameters for safety distances
    frontline_distance = 5; 
    support_distance = 15;
    long_range_distance = 25;

    % Convergence tracking
    convergence = zeros(max_iter, 1);

    % Optimization loop
    for iter = 1:max_iter
        % Evaluate fitness
        fitness = fitnessFunc(positions);
        
        % Update Pbest
        for i = 1:population
            if fitness(i) < Pbest_fitness(i)
                Pbest_fitness(i) = fitness(i);
                Pbest(i, :) = positions(i, :);
            end
        end

        % Update Gbest
        [current_best_fitness, best_idx] = min(fitness);
        if current_best_fitness < best_fitness
            best_fitness = current_best_fitness;
            Gbest = positions(best_idx, :);
        end

        % Update velocities and positions
        for i = 1:population
            if i <= frontline
                % Frontline hunters
                velocities(i, :) = 0.5 * velocities(i, :) + ...
                                 rand(1, dim) .* (Pbest(i, :) - positions(i, :)) + ...
                                 rand(1, dim) .* (Gbest - positions(i, :));
            elseif i <= frontline + support
                % Support hunters
                frontline_center = mean(positions(1:frontline, :), 1);
                direction = (frontline_center - positions(i, :)) / norm(frontline_center - positions(i, :));
                positions(i, :) = frontline_center + direction * support_distance;
                
            else
                % Long-range hunters
                frontline_center = mean(positions(1:frontline, :), 1);
                direction = (frontline_center - positions(i, :)) / norm(frontline_center - positions(i, :));
                positions(i, :) = frontline_center + direction * long_range_distance;
            end

            % Update positions
            positions(i, :) = positions(i, :) + velocities(i, :);

            % Apply bounds
            positions(i, :) = max(min(positions(i, :), ub), lb);
        end

        % Record convergence
        convergence(iter) = best_fitness;
        fprintf('Iteration %d: Best Fitness = %.6e\n', iter, best_fitness);
    end

    % Display results
    disp('Final Gbest Position:');
    disp(Gbest);
    disp('Final Objective Value:');
    disp(best_fitness);
end
