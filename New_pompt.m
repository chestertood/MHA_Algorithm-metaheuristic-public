function [best_position, best_fitness] = MonsterHunterOptimization_No_parties(bounds, max_iter, fitnessFunc)
    % ตรวจสอบและตั้งค่าขอบเขตเริ่มต้น
    if nargin < 1 || isempty(bounds)
        bounds = [-10 10; -10 10]; % ค่าเริ่มต้นของ bounds
    end
    if nargin < 2 || isempty(max_iter)
        max_iter = 50; % ค่าเริ่มต้นของ max_iter
    end
    if nargin < 3 || isempty(fitnessFunc)
        fitnessFunc = @(x) sum(x.^2); % ค่าเริ่มต้นของฟังก์ชันเป้าหมาย
    end

    % Parameters
    w1 = 1; w2 = 0; w3 = 0;  % Weights for fitness components (using only w1 for simplicity)
    alpha = 0.8;             % Frontline aggression factor
    beta = 1.5;              % Ranged safe distance factor
    gamma = 0.6;             % Support cohesion factor

    % Initialize hunters
    hunters = initialize_hunters(4, bounds);
    velocities = zeros(size(hunters));

    best_fitness = Inf;
    best_position = [];

    % Main loop
    for iter = 1:max_iter
        % Calculate fitness for the current set of hunters
        flat_hunters = reshape(hunters, [1, numel(hunters)]);
        current_fitness = fitnessFunc(flat_hunters);

        % Update best solution
        if current_fitness < best_fitness
            best_fitness = current_fitness;
            best_position = flat_hunters;
        end

        % Display current iteration and best fitness
        fprintf('Iteration %d: Best Fitness = %.6f\n', iter, best_fitness);

        % Update positions and velocities for each hunter
        for j = 1:4 % Each hunter
            hunter_pos = squeeze(hunters(j,:))';

            if j <= 2 % Frontline hunters
                velocities(j,:) = alpha * squeeze(velocities(j,:))' + rand * (best_position(1:2) - hunter_pos);
            elseif j == 3 % Ranged hunter
                safe_dist = beta * norm(best_position(1:2) - hunter_pos);
                current_dist = norm(best_position(1:2) - hunter_pos);
                direction = normalize(hunter_pos - best_position(1:2));
                velocities(j,:) = squeeze(velocities(j,:))' + rand * (safe_dist - current_dist) * direction;
            else % Support hunter
                team_center = mean(hunters(1:3,:), 1);
                velocities(j,:) = gamma * (team_center - hunter_pos);
            end

            hunters(j,:) = hunter_pos + reshape(squeeze(velocities(j,:)), [1, 2]);
        end

        % Bound checking
        hunters = bound_positions(hunters, bounds);
    end

    % Display best fitness after optimization
    disp(best_fitness);
end

function hunters = initialize_hunters(num_hunters, bounds)
    hunters = zeros(num_hunters, 2);
    hunters(:,:) = bounds(:,1)' + rand(num_hunters,2) .* (bounds(:,2)'-bounds(:,1)');
end

function pos = bound_positions(pos, bounds)
    pos(:,1) = max(min(pos(:,1), bounds(1,2)), bounds(1,1));
    pos(:,2) = max(min(pos(:,2), bounds(2,2)), bounds(2,1));
end

function n = normalize(v)
    if norm(v) == 0
        n = [0, 0];
    else
        n = v / norm(v);
    end
end
