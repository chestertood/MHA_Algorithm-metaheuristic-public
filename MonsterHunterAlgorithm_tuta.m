function [Gbest, best_fitness] = MonsterHunterAlgorithm_tuta(bounds, max_iter, fitnessFunc)
    % Monster Hunter Algorithm with custom objective function

    % Default parameters
    if nargin < 1 || isempty(bounds)
        bounds = [-10 10; -10 10]; % Default 2D space bounds
    end
    if nargin < 2 || isempty(max_iter)
        max_iter = 30; % Default iterations
    end
    if nargin < 3 || isempty(fitnessFunc)
        fitnessFunc = @(x) sum(x.^2, 2); % Default objective function (sum of squares per individual)
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
    dimensions = size(bounds, 1);
    positions = bounds(:,1)' + rand(population, dimensions) .* (bounds(:,2)' - bounds(:,1)');
    velocities = rand(population, dimensions) * 5;

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
                Pbest(i, 🙂 = positions(i, :);
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
                velocities(i, 🙂 = 0.5 * velocities(i, 🙂 + ...
                                 rand(1, dimensions) .* (Pbest(i, 🙂 - positions(i, :)) + ...
                                 rand(1, dimensions) .* (Gbest - positions(i, :));
            elseif i <= frontline + support
                % Support hunters
                frontline_center = mean(positions(1:frontline, 🙂, 1);
                direction = (frontline_center - positions(i, :)) / norm(frontline_center - positions(i, :));
                positions(i, 🙂 = frontline_center + direction * support_distance;
            else
                % Long-range hunters
                frontline_center = mean(positions(1:frontline, 🙂, 1);
                direction = (frontline_center - positions(i, :)) / norm(frontline_center - positions(i, :));
                positions(i, 🙂 = frontline_center + direction * long_range_distance;
            end

            % Update positions
            positions(i, 🙂 = positions(i, 🙂 + velocities(i, :);

            % Apply bounds
            positions(i, 🙂 = max(min(positions(i, 🙂, bounds(:, 2)'), bounds(:, 1)');
        end

        % Record convergence
        convergence(iter) = best_fitness;
        fprintf('Iteration %d: Best Fitness = %.6e\n', iter, best_fitness);
    end

    % Plot convergence
    figure;
    plot(1:max_iter, convergence, 'b-', 'LineWidth', 2);
    xlabel('Iterations');
    ylabel('Objective Value');
    title('Convergence Rate of Monster Hunter Algorithm');

    disp('Final Gbest Position:');
    disp(Gbest);
    disp('Final Objective Value:');
    disp(best_fitness);
end