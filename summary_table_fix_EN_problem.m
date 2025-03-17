% Load the saved results
format long g

load('optimization_results_EN_poblem.mat');

% Ensure the results variable is loaded and valid
if exist('results', 'var') && isstruct(results)
    % Initialize arrays to hold the table data
    Problems = {};
    BestCosts = [];
    Times = [];
    MaxValues = []; %add
    MinValues = []; %add
    MeanValues = []; %add
    StdValues = [];
    CostRanks = [];
    TimeRanks = [];
    RankingMean = []; %add
    RankingCpuTime = []; %add
    Medians = [];
    Stds = [];

    % Loop through all problems and focus on MHO
    for p = 1:numel(results)
        problemName = results(p).Problem;
        [lb, ub, dim, fobj] = Func_eng(problemName);
        
        % Initialize temporary arrays for ranking
        tempAlgorithms = {'GA', 'PSO', 'GWO', 'ABC', 'SA', 'MHO', 'WO', 'Puma', 'HBO', 'WOA'};
        tempMeans = [];
        tempTimes = [];
        tempMedians = [];
        tempStds = [];
        tempMaxs = []; %add
        tempMins = []; %add
        
        % Extract data for each algorithm
        for alg = tempAlgorithms
            alg = alg{1};  % Extract algorithm name
            tempMeans = [tempMeans; results(p).(alg).Mean_value]; %#ok<AGROW> %add
            tempTimes = [tempTimes; results(p).(alg).Cpu_times]; %#ok<AGROW>  % Using Cpu_times for time
            tempMedians = [tempMedians; results(p).(alg).Median_value]; %#ok<AGROW>
            tempStds = [tempStds; results(p).(alg).Std_value]; %#ok<AGROW>
            tempMaxs = [tempMaxs; results(p).(alg).Max_value]; %#ok<AGROW>    %add
            tempMins = [tempMins; results(p).(alg).Min_value]; %#ok<AGROW>    %add
        end
        
        % Manually rank the BestCosts
        ranks = zeros(size(tempMeans));
        for i = 1:length(tempMeans)
            rank = 1;  % Start with rank 1 for each BestCost
            for j = 1:length(tempMeans)
                if tempMeans(i) > tempMeans(j)
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
            MeanValues = [MeanValues; tempMeans(mhoIndex)]; %#ok<AGROW>
            Times = [Times; tempTimes(mhoIndex)]; %#ok<AGROW>
            MaxValues = [MaxValues; tempMaxs(mhoIndex)]; %#ok<AGROW> %add
            MinValues = [MinValues; tempMins(mhoIndex)]; %#ok<AGROW> %add
            StdValues = [StdValues; tempStds(mhoIndex)]; %#ok<AGROW> %add
            CostRanks = [CostRanks; ranks(mhoIndex)]; %#ok<AGROW>
            TimeRanks = [TimeRanks; timeRanks(mhoIndex)]; %#ok<AGROW>
            Medians = [Medians; tempMedians(mhoIndex)]; %#ok<AGROW>

        end
    end

    % Create the summary table focused on MHO
    MHO_SummaryTable = table(Problems, MaxValues, MinValues, Medians, StdValues, ...
        MeanValues, CostRanks, Times, TimeRanks, ... %fix
        'VariableNames', {'Problem,Dimension', 'Max', 'Min', 'Median', 'Std', ...
                          'Mean', 'MeanRank', 'CPUTime', 'CPUTimeRank'}); %fix
    
    % Display the summary table
    disp(MHO_SummaryTable);
else
    disp('Error: Results variable not found or invalid.');
end
