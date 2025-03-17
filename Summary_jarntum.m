% Load the saved results
format long g

load('optimization_results.mat');

% Ensure the results variable is loaded and valid
if exist('results', 'var') && isstruct(results)
    % Initialize arrays to hold the table data
    Problems = {};
    BestCost = {};
    Median = {};
    Mean = {};
    Std = {};
    CPUtimes = {};
    
    % Loop through all problems
    for p = 1:numel(results)
        problemName = results(p).Problem;
        [lb, ub, dim, fobj] = Functions(problemName);
        
        % Initialize temporary arrays for ranking
        tempAlgorithms = {'GA', 'PSO', 'GWO', 'ABC', 'SA', 'MHO', 'WO', 'Puma', 'HBO', 'WOA'};
        tempBestCosts = [];
        tempMedians = [];
        tempMeans = [];
        tempStds = [];
        tempCpuTimes = [];
        
        % Extract data for each algorithm
        for alg = tempAlgorithms
            alg = alg{1};  % Extract algorithm name
            tempBestCosts = [tempBestCosts; results(p).(alg).BestCost]; %#ok<AGROW>
            tempMedians = [tempMedians; results(p).(alg).Median_value]; %#ok<AGROW>
            tempMeans = [tempMeans; results(p).(alg).Mean_value]; %#ok<AGROW>
            tempStds = [tempStds; results(p).(alg).Std_value]; %#ok<AGROW>
            tempCpuTimes = [tempCpuTimes; results(p).(alg).Cpu_times]; %#ok<AGROW>  % Using Cpu_times for time
        end
        
        % Best algorithm (lowest BestCost)
        [bestCost, bestIndex] = min(tempBestCosts);
        bestAlgorithm = tempAlgorithms{bestIndex};  % Algorithm with the best cost
        
        % Worst algorithm (highest BestCost)
        [worstCost, worstIndex] = max(tempBestCosts);
        worstAlgorithm = tempAlgorithms{worstIndex};  % Algorithm with the worst cost
        
        % Get best algorithm for other metrics
        [bestMedian, bestMedianIndex] = min(tempMedians);
        [bestMean, bestMeanIndex] = min(tempMeans);
        [bestStd, bestStdIndex] = min(tempStds);
        [bestCpuTime, bestCpuTimeIndex] = min(tempCpuTimes);
        
        % Get worst algorithm for other metrics
        [worstMedian, worstMedianIndex] = max(tempMedians);
        [worstMean, worstMeanIndex] = max(tempMeans);
        [worstStd, worstStdIndex] = max(tempStds);
        [worstCpuTime, worstCpuTimeIndex] = max(tempCpuTimes);
        
        % Store results for the "best" row
        Problems = [Problems; {sprintf('%s, {%d} "best"', problemName, dim)}]; %#ok<AGROW>
        BestCost = [BestCost; {bestAlgorithm}]; %#ok<AGROW>
        Median = [Median; {tempAlgorithms{bestMedianIndex}}]; %#ok<AGROW>
        Mean = [Mean; {tempAlgorithms{bestMeanIndex}}]; %#ok<AGROW>
        Std = [Std; {tempAlgorithms{bestStdIndex}}]; %#ok<AGROW>
        CPUtimes = [CPUtimes; {tempAlgorithms{bestCpuTimeIndex}}]; %#ok<AGROW>
        
        % Store results for the "worst" row
        Problems = [Problems; {sprintf('%s, {%d} "worst"', problemName, dim)}]; %#ok<AGROW>
        BestCost = [BestCost; {worstAlgorithm}]; %#ok<AGROW>
        Median = [Median; {tempAlgorithms{worstMedianIndex}}]; %#ok<AGROW>
        Mean = [Mean; {tempAlgorithms{worstMeanIndex}}]; %#ok<AGROW>
        Std = [Std; {tempAlgorithms{worstStdIndex}}]; %#ok<AGROW>
        CPUtimes = [CPUtimes; {tempAlgorithms{worstCpuTimeIndex}}]; %#ok<AGROW>
    end

    % Create the summary table
    SummaryTable = table(Problems, BestCost, Median, Mean, Std, CPUtimes, ...
        'VariableNames', {'Problem, Dimension', 'BestCost', 'Median', 'Mean', 'Std', 'CPUtimes'});
    
    % Display the summary table
    disp(SummaryTable);

    % Optionally, save the table to a CSV file
    writetable(SummaryTable, 'optimization_summary_best_worst.csv');
else
    disp('Error: Results variable not found or invalid.');
end
