function [best_solution, best_fitness_GA, num_generations, best_fitness_history] = GA(obj_func, lb, ub, num_dimensions, num_chromosomes, num_generations, mutation_rate)
    % Ensure lb and ub are vectors of size num_dimensions
    if isscalar(lb)
        lb = lb * ones(1, num_dimensions);
    end
    if isscalar(ub)
        ub = ub * ones(1, num_dimensions);
    end

    % Initialize Population
    population = lb + (ub - lb) .* rand(num_chromosomes, num_dimensions);

    % Main Loop
    best_fitness_history = zeros(1, num_generations);
    for gen = 1:num_generations
        % Evaluate Fitness
        fitness = obj_func(population); % Directly evaluate population as matrix

        % Selection: Tournament Selection
        selected = TournamentSelection(population, fitness);

        % Crossover: Uniform Crossover
        offspring = UniformCrossover(selected);

        % Mutation
        offspring = MutatePopulation(offspring, lb, ub, mutation_rate);

        % Evaluate Offspring Fitness
        offspring_fitness = obj_func(offspring); % Directly evaluate offspring

        % Combine and Select the Best
        combined_population = [population; offspring];
        combined_fitness = [fitness; offspring_fitness];
        [sorted_fitness, indices] = sort(combined_fitness, 'ascend');
        population = combined_population(indices(1:num_chromosomes), :);

        % Track Best Fitness
        best_fitness_history(gen) = sorted_fitness(1);
    end

    % Results
    best_solution = population(1, :);
    best_fitness_GA = best_fitness_history(end);

  
end

function selected = TournamentSelection(population, fitness)
    % Tournament Selection
    num_chromosomes = size(population, 1);
    selected = zeros(size(population));
    for i = 1:num_chromosomes
        % Randomly pick two chromosomes
        idx1 = randi(num_chromosomes);
        idx2 = randi(num_chromosomes);
        if fitness(idx1) < fitness(idx2)
            selected(i, :) = population(idx1, :);
        else
            selected(i, :) = population(idx2, :);
        end
    end
end

function offspring = UniformCrossover(selected)
    % Uniform Crossover
    [num_chromosomes, num_dimensions] = size(selected);
    offspring = zeros(size(selected));
    for i = 1:2:num_chromosomes-1
        parent1 = selected(i, :);
        parent2 = selected(i+1, :);
        mask = rand(1, num_dimensions) < 0.5;
        offspring(i, :) = mask .* parent1 + ~mask .* parent2;
        offspring(i+1, :) = ~mask .* parent1 + mask .* parent2;
    end
    if mod(num_chromosomes, 2) == 1
        offspring(end, :) = selected(end, :);
    end
end

function mutated = MutatePopulation(population, lb, ub, mutation_rate)
    % Mutation
    [num_chromosomes, num_dimensions] = size(population);
    mutated = population;
    for i = 1:num_chromosomes
        for j = 1:num_dimensions
            if rand < mutation_rate
                mutated(i, j) = lb(j) + (ub(j) - lb(j)) * rand;
            end
        end
    end
end
