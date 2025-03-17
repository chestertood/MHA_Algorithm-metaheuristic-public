% Load the saved results
format long g

% Load results file
load('optimization_results_23poblem_30ENruns.mat');

% Ensure the results variable is loaded and valid
if exist('results', 'var') && isstruct(results)
    % Initialize arrays to hold the table data
    Problems = {};
    MaxValues = [];
    MinValues = [];
    MeanValues = [];
    StdValues = [];
    Times = [];
    CostRanks = [];
    TimeRanks = [];
    Medians = [];
    
    % Loop through all problems and focus on MHO
    for p = 1:numel(results)
        problemName = results(p).Problem; % Problem identifier
        [lb, ub, dim, fobj] = Func_eng(problemName); % Extract problem details
        
        % Initialize arrays for algorithm metrics
        tempAlgorithms = {'GA', 'PSO', 'GWO', 'ABC', 'SA', 'MHO', 'WO', 'Puma', 'HBO', 'WOA'};
        BestCosts = zeros(numel(tempAlgorithms), 1);
        tempTimes = zeros(numel(tempAlgorithms), 1);
        tempMedians = zeros(numel(tempAlgorithms), 1);
        tempStds = zeros(numel(tempAlgorithms), 1);
        tempMaxs = zeros(numel(tempAlgorithms), 1);
        tempMins = zeros(numel(tempAlgorithms), 1);
        
        % Extract data for each algorithm
        for a = 1:numel(tempAlgorithms)
            alg = tempAlgorithms{a};  % Algorithm name
            
            % Check if the algorithm field exists in results
            if isfield(results(p), alg)
                BestCosts(a) = results(p).(alg).MeanCost; % Mean cost
                tempTimes(a) = results(p).(alg).MeanCpuTime; % Mean CPU time
                tempMedians(a) = median(results(p).(alg).Convergence); % Median of convergence
                tempStds(a) = results(p).(alg).StdCost; % Standard deviation
                tempMaxs(a) = max(results(p).(alg).Convergence); % Max value
                tempMins(a) = min(results(p).(alg).Convergence); % Min value
            else
                BestCosts(a) = inf; % Assign a high value if no data
                tempTimes(a) = inf;
            end
        end
        
        % Rank the BestCosts and Times
        costRanks = tiedrank(BestCosts); % Rank costs
        timeRanks = tiedrank(tempTimes); % Rank times
       
        
        
        % Find the MHO index and add its data to the summary
        mhoIndex = find(strcmp(tempAlgorithms, 'MHO'));
        if ~isempty(mhoIndex)
            Problems = [Problems; {sprintf('%s, %dD', problemName, dim)}]; %#ok<AGROW>
            MaxValues = [MaxValues; tempMaxs(mhoIndex)]; %#ok<AGROW>
            MinValues = [MinValues; tempMins(mhoIndex)]; %#ok<AGROW>
            MeanValues = [MeanValues; BestCosts(mhoIndex)]; %#ok<AGROW>
            StdValues = [StdValues; tempStds(mhoIndex)]; %#ok<AGROW>
            Times = [Times; tempTimes(mhoIndex)]; %#ok<AGROW>
            CostRanks = [CostRanks; costRanks(mhoIndex)]; %#ok<AGROW>
            TimeRanks = [TimeRanks; timeRanks(mhoIndex)]; %#ok<AGROW>
            Medians = [Medians; tempMedians(mhoIndex)]; %#ok<AGROW>
        end
    end
    
    % Create the summary table focused on MHO
    MHO_SummaryTable = table(Problems, MaxValues, MinValues, Medians, StdValues, ...
        MeanValues, CostRanks, Times, TimeRanks, ...
        'VariableNames', {'Problem_Dimension', 'Max', 'Min', 'Median', 'Std', ...
                          'Mean', 'MeanRank', 'CPUTime', 'CPUTimeRank'});
    
    % Display the summary table
    disp(MHO_SummaryTable);
else
    disp('Error: Results variable not found or invalid.');
end
