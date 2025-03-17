% Load the saved results
format long g

% Load results file
load('optimization_results_13poblem_30runs_50dim.mat');

filename = 'Optimization_Comparison_50dim.xlsx';

% Ensure the results variable is loaded and valid
if exist('results', 'var') && isstruct(results)
    % Initialize arrays to hold the table data
algorithms = {'GA', 'PSO', 'GWO', 'SA', 'MHO', 'WO', 'Puma', 'HBO', 'WOA','ACOR','SWO'};

% ลูปแต่ละอัลกอริธึม
for algIdx = 1:numel(algorithms)
    algName = algorithms{algIdx};  % ชื่ออัลกอในรอบนั้น
    Problems = {};
    MaxValues = [];
    MinValues = [];
    MeanValues = [];
    StdValues = [];
    Times = [];
    CostRanks = [];
    TimeRanks = [];
    Medians = [];
    BestcostsRanks = [];
    WorstcostsRanks = [];
    StdRank = [];
    
    % Loop through all problems and focus on MHO
    for p = 1:numel(results)
        problemName = results(p).Problem; % Problem identifier
        [lb, ub, dim, fobj] = Functions_50(problemName); % Extract problem details

        
        % Initialize arrays for algorithm metrics
        tempAlgorithms = {'GA', 'PSO', 'GWO', 'SA', 'MHO', 'WO', 'Puma', 'HBO', 'WOA','ACOR','SWO'};
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
                BestCosts(a) = mean(results(p).(alg).Convergence); % Mean cost                
                tempTimes(a) = results(p).(alg).MeanCpuTime; % Mean CPU time             
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
        Bestcosts = tiedrank(tempMins);
        Worstcost = tiedrank(-tempMaxs);
        Std = tiedrank(tempStds);
       
        
        
        % Find the MHO index and add its data to the summary
        mhoIndex = find(strcmp(tempAlgorithms, algName));
        if ~isempty(mhoIndex)
            
            Problems = [Problems; {sprintf('%s, %dD', problemName, dim)}]; %#ok<AGROW>
            MaxValues = [MaxValues; tempMaxs(mhoIndex)]; %#ok<AGROW>
            MinValues = [MinValues; tempMins(mhoIndex)]; %#ok<AGROW>
            MeanValues = [MeanValues; BestCosts(mhoIndex)]; %#ok<AGROW>
            StdValues = [StdValues; tempStds(mhoIndex)]; %#ok<AGROW>
            Times = [Times; tempTimes(mhoIndex)]; %#ok<AGROW>
            CostRanks = [CostRanks; costRanks(mhoIndex)]; %#ok<AGROW>
            TimeRanks = [TimeRanks; timeRanks(mhoIndex)]; %#ok<AGROW>
            BestcostsRanks = [BestcostsRanks; Bestcosts(mhoIndex)];
            WorstcostsRanks = [WorstcostsRanks; Worstcost(mhoIndex)];
            StdRank = [StdRank; Std(mhoIndex)];
           
        end
    end
    % Create the summary table focused on MHO
    Algorithm = repmat({algName}, numel(Problems), 1);
    SummaryTable = table(Algorithm,Problems, MinValues,BestcostsRanks,MaxValues,WorstcostsRanks, StdValues, ...
        StdRank,MeanValues, CostRanks, Times, TimeRanks, ...
        'VariableNames', {'Algorithm','Problem_Dimension', 'Bestcost','BestcostsRanks', 'Worstcost','WorstcostsRanks', 'Std', ...
                          'StdRank','Mean', 'MeanRank', 'CPUTime', 'CPUTimeRank'});
    
    % Display the summary table
    disp(SummaryTable);
    
    writetable(SummaryTable, filename, 'Sheet', algName);
end
    

else
    disp('Error: Results variable not found or invalid.');
end
