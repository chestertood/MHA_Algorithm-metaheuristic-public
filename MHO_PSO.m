function [best_position, best_fitness] = MHO_PSO(bounds, max_iter, fitnessFunc)
    if nargin < 1 || isempty(bounds)
        bounds = [-10 10; -10 10];
    end
    if nargin < 2 || isempty(max_iter)
        max_iter = 30;
    end
    if nargin < 3 || isempty(fitnessFunc)
        fitnessFunc = @(x) sum(x.^2);
    end

    % Parameters
    num_parties = 5000;
    num_hunters = 4;
    alpha = 0.6; % Adjusted for better exploration
    beta = 1.2;  % Adjusted for better ranged positioning
    gamma = 0.4; % Adjusted for cohesion
    inertia = 0.7; % Reduced for less oscillation
    correction_factor = 1.5;

    % Initialize
    parties = initialize_parties(num_parties, num_hunters, bounds);
    velocities = zeros(size(parties));
    best_positions = parties;
    fitness = inf(num_parties, 1);
    best_fitness = inf;
    best_position = [];

    for iter = 1:max_iter
        for i = 1:num_parties
            % Evaluate fitness
            flat_party = reshape(parties(i,:,:), [1, num_hunters*2]);
            current_fitness = fitnessFunc(flat_party);

            % Update personal best
            if current_fitness < fitness(i)
                fitness(i) = current_fitness;
                best_positions(i,:,:) = parties(i,:,:);
            end

            % Update global best
            if current_fitness < best_fitness
                best_fitness = current_fitness;
                best_position = flat_party;
            end
        end

        % Update positions and velocities
        for i = 1:num_parties
            for j = 1:num_hunters
                hunter_pos = squeeze(parties(i,j,:))';

                if j <= 2 % Frontline hunters
                    velocities(i,j,:) = inertia * squeeze(velocities(i,j,:))' + ...
                                        alpha * rand * (best_position(1:2) - hunter_pos) + ...
                                        correction_factor * rand * (squeeze(best_positions(i,j,:))' - hunter_pos);
                elseif j == 3 % Ranged hunter
                    safe_dist = beta * norm(best_position(1:2) - hunter_pos);
                    current_dist = norm(best_position(1:2) - hunter_pos);
                    direction = normalize(hunter_pos - best_position(1:2));
                    velocities(i,j,:) = inertia * squeeze(velocities(i,j,:))' + ...
                                        (safe_dist - current_dist) * direction + 0.1 * rand(1, 2);
                else % Support hunter
                    party_center = mean(squeeze(parties(i,1:3,:)), 1);
                    velocities(i,j,:) = inertia * squeeze(velocities(i,j,:))' + ...
                                        gamma * (party_center - hunter_pos);
                end

                % Update position
                parties(i,j,:) = hunter_pos + reshape(squeeze(velocities(i,j,:)), [1, 2]);
            end
        end

        % Bound checking
        parties = bound_positions(parties, bounds);

        % Display progress
        fprintf('Iteration %d: Best Fitness = %.6f\n', iter, best_fitness);
    end

    disp('Best Fitness:');
    disp(best_fitness);
    disp('Best Position:');
    disp(best_position);
end

function parties = initialize_parties(num_parties, num_hunters, bounds)
    parties = zeros(num_parties, num_hunters, 2);
    for i = 1:num_parties
        parties(i,:,:) = bounds(:,1)' + rand(num_hunters,2) .* (bounds(:,2)'-bounds(:,1)');
    end
end

function pos = bound_positions(pos, bounds)
    pos(:,:,1) = max(min(pos(:,:,1), bounds(1,2)), bounds(1,1));
    pos(:,:,2) = max(min(pos(:,:,2), bounds(2,2)), bounds(2,1));
end

function n = normalize(v)
    if norm(v) == 0
        n = [0, 0];
    else
        n = v / norm(v);
    end
end
