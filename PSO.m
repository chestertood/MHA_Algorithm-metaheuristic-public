function [gbest_value, fitness_history_PSO] = PSO(lb, ub, max_iter, fitnessFunc, num_dimensions)
    if nargin < 1 || isempty(lb)
        lb = -10; % Default lower bound
    end
    if nargin < 2 || isempty(ub)
        ub = 10; % Default upper bound
    end
    if nargin < 3 || isempty(max_iter)
        max_iter = 30; % Default number of iterations
    end
    if nargin < 4 || isempty(fitnessFunc)
        fitnessFunc = @(x) sum(x.^2); % Default fitness function
    end
    if nargin < 5 || isempty(num_dimensions)
        num_dimensions = 2; % Default number of dimensions
    end

    % Ensure lb and ub are vectors of the correct length
    if isscalar(lb)
        lb = lb * ones(1, num_dimensions);
    end
    if isscalar(ub)
        ub = ub * ones(1, num_dimensions);
    end

    % Parameters
    iterations = max_iter;  % Number of iterations
    inertia = 1.0;          % Inertia weight
    correction_factor = 2.0;% Acceleration coefficient
    swarms = 50;            % Number of particles

    % Initialize swarm
    swarm = zeros(swarms, num_dimensions * 3 + 1); % [positions, personal best positions, velocities, fitness]
    swarm(:, 1:num_dimensions) = lb + rand(swarms, num_dimensions) .* (ub - lb); % Random positions within bounds
    swarm(:, num_dimensions + 1:num_dimensions * 2) = swarm(:, 1:num_dimensions); % Personal best positions
    swarm(:, num_dimensions * 2 + 1:num_dimensions * 3) = 0; % Initial velocities
    swarm(:, end) = inf; % Initialize fitness to infinity

    % Initialize fitness history for convergence tracking
    fitness_history_PSO = zeros(iterations, 1);

    % Main loop
    for iter = 1:iterations
        % Update positions and evaluate fitness
        for i = 1:swarms
            % Get current position
            current_position = swarm(i, 1:num_dimensions);

            % Calculate fitness
            value = fitnessFunc(current_position);

            % Update personal best if the new fitness is better
            if value < swarm(i, end)
                swarm(i, num_dimensions + 1:num_dimensions * 2) = current_position; % Update personal best position
                swarm(i, end) = value;  % Update personal best fitness
            end
        end

        % Find global best position
        [gbest_value, gbest_idx] = min(swarm(:, end)); % Global best fitness and index

        % Save current global best fitness to history
        fitness_history_PSO(iter) = gbest_value;

        % Update velocities and positions
        for i = 1:swarms
            for d = 1:num_dimensions
                % Update velocity
                swarm(i, num_dimensions * 2 + d) = rand * inertia * swarm(i, num_dimensions * 2 + d) + ...
                                                   correction_factor * rand * (swarm(i, num_dimensions + d) - swarm(i, d)) + ...
                                                   correction_factor * rand * (swarm(gbest_idx, d) - swarm(i, d));

                % Update position
                swarm(i, d) = swarm(i, d) + swarm(i, num_dimensions * 2 + d);

                % Apply bounds
                swarm(i, d) = max(min(swarm(i, d), ub(d)), lb(d));
            end
        end

        % Display progress
        fprintf('Iteration %d: Best Fitness = %.6f\n', iter, gbest_value);
    end

    % Display final global best fitness and position
    disp('Best Fitness:');
    disp(gbest_value);
    disp('Best Position:');
    disp(swarm(gbest_idx, 1:num_dimensions));

    % Plot convergence rate
    
end
