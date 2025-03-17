% Load the saved results
load('optimization_results.mat');

% Ensure the results variable is loaded and valid
if exist('results', 'var') && isstruct(results)
    % Initialize arrays to hold the table data
    Problems = {};
    Algorithms = {};
    BestCosts = [];
    MaxValues = [];
    MinValues = [];
    MeanValues = [];
    Times = [];
    CpuTimes = [];
    
    % Loop through all problems and collect data
    for p = 1:numel(results)
        problemName = results(p).Problem;
        [lb,ub,dim,fobj] = Functions(problemName);        
        algNames = {'GA', 'PSO', 'GWO', 'ABC', 'SA', 'MHO', 'WO', 'Puma', 'HBO', 'WOA'};
        
        for alg = algNames
            alg = alg{1};  % Extract algorithm name
            
            % Append data to arrays
            Problems = [Problems; {problemName,dim}]; %#ok<AGROW>
            Algorithms = [Algorithms; alg]; %#ok<AGROW>
            BestCosts = [BestCosts; results(p).(alg).BestCost]; %#ok<AGROW>
            MaxValues = [MaxValues; results(p).(alg).Max_value]; %#ok<AGROW>
            MinValues = [MinValues; results(p).(alg).Min_value]; %#ok<AGROW>
            MeanValues = [MeanValues; results(p).(alg).Mean_value]; %#ok<AGROW>
            
            % Append Times and Cpu_times (check if they exist for the algorithm)
            if isfield(results(p).(alg), 'Times')
                Times = [Times; results(p).(alg).Times]; %#ok<AGROW>
            else
                Times = [Times; NaN]; %#ok<AGROW>
            end
            
            if isfield(results(p).(alg), 'Cpu_times')
                CpuTimes = [CpuTimes; results(p).(alg).Cpu_times]; %#ok<AGROW>
            else
                CpuTimes = [CpuTimes; NaN]; %#ok<AGROW>
            end
        end
    end

    % Create a table from the collected data
    resultsTable = table(Problems, Algorithms, BestCosts, MaxValues, MinValues, MeanValues, Times, CpuTimes, ...
        'VariableNames', {'Problem,dimention', 'Algorithm', 'BestCost', 'MaxValue', 'MinValue', 'MeanValue', 'Time', 'CpuTime'});
    
    % Display the table
    disp(resultsTable);
else
    disp('Error: Results variable not found or invalid.');
end
