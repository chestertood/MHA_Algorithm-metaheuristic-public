% Load the saved results
format long g

load('optimization_results.mat');

% Ensure the results variable is loaded and valid
if exist('results', 'var') && isstruct(results)
    % Initialize arrays to hold the table data
    Problems = {};
    BestCosts = [];
    Times = [];
    CostRanks = [];
    TimeRanks = [];
    Medians = [];
    Stds = [];
    
    % Loop through all problems and focus on MHO
    for p = 1:numel(results)
        problemName = results(p).Problem;
        [lb, ub, dim, fobj] = Functions(problemName);
        
        % Initialize temporary arrays for ranking
        tempAlgorithms = {'GA', 'PSO', 'GWO', 'ABC', 'SA', 'MHO', 'WO', 'Puma', 'HBO', 'WOA'};
        tempBestCosts = [];
        tempTimes = [];
        tempMedians = [];
        tempStds = [];
        
        % Extract data for each algorithm
        for alg = tempAlgorithms
            alg = alg{1};  % Extract algorithm name
            tempBestCosts = [tempBestCosts; results(p).(alg).BestCost]; %#ok<AGROW>
            tempTimes = [tempTimes; results(p).(alg).Cpu_times]; %#ok<AGROW>  % Using Cpu_times for time
            tempMedians = [tempMedians; results(p).(alg).Median_value]; %#ok<AGROW>
            tempStds = [tempStds; results(p).(alg).Std_value]; %#ok<AGROW>
        end
        
        % Manually rank the BestCosts
        ranks = zeros(size(tempBestCosts));
        for i = 1:length(tempBestCosts)
            rank = 1;  % Start with rank 1 for each BestCost
            for j = 1:length(tempBestCosts)
                if tempBestCosts(i) > tempBestCosts(j)
                    rank = rank + 1;  % If the current BestCost is greater than another, increase its rank
                end
            end
            ranks(i) = rank;  % Assign the rank to the current BestCost
        end
        
        % Manually rank the Times
        timeRanks = zeros(size(tempTimes));
        for i = 1:length(tempTimes)
            rank = 1;  % Start with rank 1 for each Time
            for j = 1:length(tempTimes)
                if tempTimes(i) > tempTimes(j)
                    rank = rank + 1;  % If the current Time is greater than another, increase its rank
                end
            end
            timeRanks(i) = rank;  % Assign the rank to the current Time
        end
        
        % Find the MHO index and its ranks
        mhoIndex = find(strcmp(tempAlgorithms, 'MHO'));
        if ~isempty(mhoIndex)
            Problems = [Problems; {problemName, dim}]; %#ok<AGROW>
            BestCosts = [BestCosts; tempBestCosts(mhoIndex)]; %#ok<AGROW>
            Times = [Times; tempTimes(mhoIndex)]; %#ok<AGROW>
            CostRanks = [CostRanks; ranks(mhoIndex)]; %#ok<AGROW>
            TimeRanks = [TimeRanks; timeRanks(mhoIndex)]; %#ok<AGROW>
            Medians = [Medians; tempMedians(mhoIndex)]; %#ok<AGROW>
            Stds = [Stds; tempStds(mhoIndex)]; %#ok<AGROW>
        end
    end

    % Create the summary table focused on MHO
    MHO_SummaryTable = table(Problems, BestCosts, Times, Medians, Stds, CostRanks, TimeRanks, ...
        'VariableNames', {'Problem,Dimension', 'BestCost', 'Time', 'Median', 'Std', 'CostRank', 'TimeRank'});
    
    % Display the summary table
    disp(MHO_SummaryTable);
else
    disp('Error: Results variable not found or invalid.');
end
