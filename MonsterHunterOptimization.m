function [best_position, best_fitness] = MonsterHunterOptimization(objective_func, bounds, max_iter)
    % Parameters
    num_parties = 2;         % Number of hunting parties
    w1 = 0.4; w2 = 0.3; w3 = 0.3;  % Weights for fitness components
    alpha = 0.8;             % Frontline aggression factor
    beta = 1.5;              % Ranged safe distance factor
    gamma = 0.6;             % Support cohesion factor
    bounds = [0, 100; 0, 100]
    max_iter = 30
    
    % Initialize parties
    parties = initialize_parties(num_parties, bounds);
    velocities = zeros(num_parties, 4, 2);  % 4 hunters, 2D position
    velocities(1,:,:)
    
    % Target position (Fatalis)
    target = [bounds(1,2)*0.8, bounds(2,2)*0.8];
    
    % Local optima (other monsters)
    local_optima = [
        bounds(1,2)*0.3, bounds(2,2)*0.3;
        bounds(1,2)*0.6, bounds(2,2)*0.5;
        bounds(1,2)*0.4, bounds(2,2)*0.7
    ];
    
    % Main loop
    for iter = 1:max_iter
        % Evaluate each party
        fitness = zeros(num_parties, 1);
        for i = 1:num_parties
            % Calculate distance to target
            target 
            parties(i,:,:)
            
            Dt = sqrt(sum((parties(i,:,:) - reshape(target, [1, 1, 2])).^2, 3));
            Dt
            party = squeeze(parties(i,:,:))
            party
            % Formation fitness
            Ff = formation_fitness(party);
            
            % Local avoidance
            La = local_avoidance(party, local_optima);
            
            % Total fitness
            fitness(i) = w1*mean(Dt) + w2*Ff + w3*La;
        end
        
        % Update positions
        for i = 1:num_parties
            % Frontline hunters (1-2)
            for j = 1:2
                velocities(i, j, :) = alpha * reshape(velocities(i, j, :), [1, 2]) + rand * (target - reshape(parties(i, j, :), [1, 2]));
                parties(i,j,:) = parties(i,j,:) + velocities(i,j,:);
            end
            
            % Ranged hunter (3)
            safe_dist = beta * norm(target - reshape(parties(i,3,:), [1,2]));
            current_dist = norm(target - reshape(parties(i,3,:), [1,2]));
            
           % คำนวณ delta
            direction = normalize(target - reshape(parties(i,3,:), [1,2])); % ทิศทางเป็น [1x2]
            delta_magnitude = rand * (safe_dist - current_dist); % ขนาดของ delta เป็น scalar
            delta = delta_magnitude * direction; % delta เป็น [1x2]
            
            % ปรับ delta ให้มีขนาด [1x1x2]
            delta = reshape(delta, [1,1,2]);
            
            % อัปเดต velocities และ parties
            velocities(i,3,:) = reshape(velocities(i,3,:), [1,1,2]) + delta; % velocities เป็น [1x1x2]
            parties(i,3,:) = parties(i,3,:) + velocities(i,3,:); % อัปเดตตำแหน่ง

            % Support hunter (4)
            % คำนวณ beta
            party_center = squeeze(mean(parties(i,1:3,:), 2)); % squeeze ให้ได้ขนาด 1x2
            disp(size(party_center)); % ตรวจสอบขนาด party_center
            
            beta = gamma * (party_center - squeeze(parties(i,4,:))); % squeeze เพื่อให้ได้ขนาด 1x2
            disp(size(beta)); % ตรวจสอบขนาด beta
            disp(reshape(parties(i,4,:), [1,2]));
            disp(beta)
            
            % ปรับขนาด parties(i,4,:) และอัปเดตค่า
            parties(i,4,:) = reshape(parties(i,4,:), [1,2]) + reshape(beta, [1,2]);

            
            parties(i,4,:) = reshape(parties(i,4,:), [1,1,2]); % คืนขนาดเป็น 1x1x2

        end
        
        % Bound checking
        parties = bound_positions(parties, bounds);
    end
    
    % Return best solution
    [best_fitness, best_idx] = min(fitness);
    best_position = parties(best_idx,:,:);
end

function parties = initialize_parties(num_parties, bounds)
    parties = zeros(num_parties, 4, 2);  % 4 hunters, 2D position
    for i = 1:num_parties
        for j = 1:4
            parties(i,j,:) = bounds(:,1)' + rand(1,2).*(bounds(:,2)'-bounds(:,1)');
        end
    end
end

function ff = formation_fitness(party)
    % Calculate formation score based on roles
    frontline_pos = party(1:2,:);
    ranged_pos = party(3,:);
    support_pos = party(4,:);
    
    % Ideal distances between roles
    ff = -sum(pdist2(frontline_pos, ranged_pos)) - ...
         sum(pdist2(frontline_pos, support_pos)) - ...
         norm(ranged_pos - support_pos);
end

function la = local_avoidance(party, local_optima)
    la = 0;
    for i = 1:size(party, 1)
        for j = 1:size(local_optima, 1)
            dist = norm(reshape(party(i,:), [1,2]) - local_optima(j,:));
            if dist < 2.0  % threshold
                la = la + 1/dist^2;
            end
        end
    end
end


function pos = bound_positions(pos, bounds)
    pos(:,:,1) = min(max(pos(:,:,1), bounds(1,1)), bounds(1,2));
    pos(:,:,2) = min(max(pos(:,:,2), bounds(2,1)), bounds(2,2));
end

function n = normalize(v)
    n = v / norm(v);
end













