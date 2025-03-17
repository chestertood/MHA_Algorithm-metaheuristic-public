function [best_position, best_fitness,fitness_history_MHO] = MonsterHunterOptimization_OFF(bounds, max_iter, fitnessFunc)
    % ตรวจสอบและตั้งค่าขอบเขตเริ่มต้น
    
    if nargin < 1 || isempty(bounds)
        bounds = [-10 10; -10 10]; % ค่าเริ่มต้นของ bounds
    end
    if nargin < 2 || isempty(max_iter)
        max_iter = 30; % ค่าเริ่มต้นของ max_iter
    end
    if nargin < 3 || isempty(fitnessFunc)
        fitnessFunc = @(x) sum(x.^2); % ค่าเริ่มต้นของฟังก์ชันเป้าหมาย
    end

    % Parameters
    num_parties = 1000;         % Number of hunting parties
    
    alpha = 0.3;             % Frontline aggression factor
    beta = 0.1;              % Ranged safe distance factor
    gamma = 0.6;             % Support cohesion factor

    % Initialize parties
    parties = initialize_parties(num_parties, bounds);
    velocities = zeros(size(parties));

    best_fitness = Inf;
    best_position = [];

    % Main loop
    for iter = 1:max_iter
        fitness = zeros(num_parties, 1);

        for i = 1:num_parties
            % Flatten party positions for fitness evaluation
            flat_party = parties(i,:,:);
            flat_party = reshape(flat_party, [1, numel(flat_party)]);

            % Calculate fitness using the provided fitness function
            fitness(i) = fitnessFunc(flat_party);

            % Update best solution
            if fitness(i) < best_fitness
                best_fitness = fitness(i);
                best_position = flat_party;
            end
        end
        fitness_history_MHO(iter) = best_fitness;
        % Display current iteration and best fitness
        fprintf('Iteration %d: Best Fitness = %.6f\n', iter, best_fitness);

        % Update positions and velocities
        for i = 1:num_parties
            for j = 1:4 % Each hunter in the party
                hunter_pos = squeeze(parties(i,j,:))';

                if j <= 2 % Frontline hunters
                    velocities(i,j,:) = alpha * squeeze(velocities(i,j,:))' + rand * (best_position(1:2) - hunter_pos);
                elseif j == 3 % Ranged hunter
                    safe_dist = beta * norm(best_position(1:2) - hunter_pos);
                    current_dist = norm(best_position(1:2) - hunter_pos);
                    direction = normalize(hunter_pos - best_position(1:2));
                    velocities(i,j,:) = squeeze(velocities(i,j,:))' + rand * (safe_dist - current_dist) * direction;
                else % Support hunter
                    party_center = mean(squeeze(parties(i,1:3,:)), 1);
                    velocities(i,j,:) = gamma * (party_center - hunter_pos);
                end

                parties(i,j,:) = hunter_pos + reshape(squeeze(velocities(i,j,:)), [1, 2]);
            end
        end

        % Bound checking
        parties = bound_positions(parties, bounds);
    end

    % Display best fitness after optimization
    disp(best_fitness);

    

    

end

function parties = initialize_parties(num_parties, bounds)
    parties = zeros(num_parties, 4, 2);
    for i = 1:num_parties
        parties(i,:,:) = bounds(:,1)' + rand(4,2) .* (bounds(:,2)'-bounds(:,1)');
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
