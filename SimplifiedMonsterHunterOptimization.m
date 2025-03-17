function [best_position, best_fitness] = SimplifiedMonsterHunterOptimization(bounds, max_iter)
    % Parameters
    num_parties = 10;         % Number of hunting parties
    alpha = 0.8;             % Frontline aggression factor
    beta = 1.5;              % Ranged safe distance factor
    gamma = 0.6;             % Support cohesion factor
    bounds = [0, 100; 0, 100];

    % Maximum number of iterations
    max_iter = 50;
    % Initialize parties
    parties = initialize_parties(num_parties, bounds);
    velocities = zeros(num_parties, 4, 2);  % 4 hunters, 2D position

    % Target position (Fatalis)
    target = [bounds(1,2)*0.8, bounds(2,2)*0.8];

    % Main loop
    best_fitness = inf;
    best_position = [];
    for iter = 1:max_iter
        % Evaluate each party's fitness
        for i = 1:num_parties
            fitness = mean(sqrt(sum((parties(i,:,:) - target).^2, 3)));

            % Update best solution if better fitness is found
            if fitness < best_fitness
                best_fitness = fitness;
                best_position = parties(i,:,:);
            end
        end

        % Update positions
        for i = 1:num_parties
            % Frontline hunters (1-2)
            for j = 1:2
                velocities(i,j,:) = alpha * velocities(i,j,:) + ...
                    rand * (target - reshape(parties(i,j,:), [1,2]));
                parties(i,j,:) = parties(i,j,:) + velocities(i,j,:);
            end

            % Ranged hunter (3)
            safe_dist = beta * norm(target - reshape(parties(i,3,:), [1,2]));
            current_dist = norm(target - reshape(parties(i,3,:), [1,2]));
            adjustment = (safe_dist - current_dist) * normalize(reshape(parties(i,3,:), [1,2]) - target);
            velocities(i,3,:) = velocities(i,3,:) + rand * adjustment;
            parties(i,3,:) = parties(i,3,:) + velocities(i,3,:);

            % Support hunter (4)
            party_center = mean(parties(i,1:3,:), 2);
            velocities(i,4,:) = gamma * (party_center - reshape(parties(i,4,:), [1,2]));
            parties(i,4,:) = parties(i,4,:) + velocities(i,4,:);
        end

        % Bound checking
        parties = bound_positions(parties, bounds);
    end
end

function parties = initialize_parties(num_parties, bounds)
    parties = zeros(num_parties, 4, 2);  % 4 hunters, 2D position
    for i = 1:num_parties
        for j = 1:4
            parties(i,j,:) = bounds(:,1)' + rand(1,2).*(bounds(:,2)'-bounds(:,1)');
        end
    end
end

function pos = bound_positions(pos, bounds)
    pos(:,:,1) = min(max(pos(:,:,1), bounds(1,1)), bounds(1,2));
    pos(:,:,2) = min(max(pos(:,:,2), bounds(2,1)), bounds(2,2));
end

function n = normalize(v)
    if norm(v) == 0
        n = zeros(size(v));
    else
        n = v / norm(v);
    end
end
