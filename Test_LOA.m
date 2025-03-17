% Lion Optimization Algorithm (LOA) Implementation in MATLAB
% Objective: Minimize Sphere Function

clc;
clear;
close all;

% Problem Definition
nVar = 10;               % Number of Variables
VarMin = -10;            % Lower Bound
VarMax = 10;             % Upper Bound
MaxIt = 30;             % Maximum Number of Iterations
nLions = 1000;             % Number of Lions (Population Size)
nPride = floor(nLions / 2); % Lions in the Pride
nNomad = nLions - nPride;  % Nomad Lions

% Fitness Function (Sphere Function)
fitnessFunc = @(x) sum(x.^2);

% Initialization
lions.Position = [];
lions.Fitness = [];
for i = 1:nLions
    lions(i).Position = VarMin + (VarMax - VarMin) .* rand(1, nVar); % Replace unifrnd
    lions(i).Fitness = fitnessFunc(lions(i).Position);
end

% Divide Lions into Pride and Nomads
[~, sortIdx] = sort([lions.Fitness]);
lions = lions(sortIdx);
pride = lions(1:nPride);
nomad = lions(nPride+1:end);

% Sweep Factor and Exploration Rate
SF = 8;                  % Sweep Factor
alpha = 6;             % Movement control factor

% Main Loop of LOA
BestFitness = zeros(MaxIt, 1);
for it = 1:MaxIt
    % Update Pride
    for i = 1:nPride
        leader = pride(1); % Select best lion in pride
        randFactor = rand();
        pride(i).Position = pride(i).Position ...
                            + alpha * randFactor .* (leader.Position - pride(i).Position);
        pride(i).Position = min(max(pride(i).Position, VarMin), VarMax);
        pride(i).Fitness = fitnessFunc(pride(i).Position);
    end

    % Update Nomads
    for i = 1:nNomad
        randFactor = rand();
        nomad(i).Position = nomad(i).Position + SF * randFactor .* (2 * rand(1, nVar) - 1);
        nomad(i).Position = min(max(nomad(i).Position, VarMin), VarMax);
        nomad(i).Fitness = fitnessFunc(nomad(i).Position);
    end

    % Combine and Sort Lions
    lions = [pride, nomad];
    [~, sortIdx] = sort([lions.Fitness]);
    lions = lions(sortIdx);
    pride = lions(1:nPride);
    nomad = lions(nPride+1:end);

    % Store Best Fitness
    BestFitness(it) = lions(1).Fitness;

    % Display Progress
    fprintf('Iteration %d: Best Fitness = %.6f\n', it, BestFitness(it));
end

% Results
figure;
plot(1:MaxIt, BestFitness, 'LineWidth', 2);
xlabel('Iteration');
ylabel('Best Fitness');
title('Convergence of LOA');
grid on;
