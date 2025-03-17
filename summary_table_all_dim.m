% โหลดไฟล์ผลลัพธ์
format long g
load('optimization_results_13poblem_30runs_alldim.mat');

filename = 'optimization_results_13poblem_30runs_alldim.xlsx';

if exist('results', 'var') && isstruct(results)
    algorithms = {'GA', 'PSO', 'GWO', 'SA', 'MHO', 'WO', 'Puma', 'HBO', 'WOA', 'ACOR', 'SWO'};
    Dims = [30, 50, 100];

    [numDims, numProblems] = size(results);  % ตรวจสอบขนาดของ results

    for algIdx = 1:numel(algorithms)
        algName = algorithms{algIdx};  % Algorithm ปัจจุบัน

        for d = 1:min(numDims, numel(Dims))  % แยกตามไดเมนชัน
            Problems = {};
            MaxValues = [];
            MinValues = [];
            MeanValues = [];
            StdValues = [];
            Times = [];
            CostRanks = [];
            TimeRanks = [];
            BestcostsRanks = [];
            WorstcostsRanks = [];
            StdRank = [];

            for p = 1:min(numProblems, numel(results))
                if isempty(results(d, p).Problem)
                    continue;  % ข้ามถ้าไม่มีข้อมูล
                end
                
                problemName = results(d, p).Problem;
                [lb, ub, ~, fobj] = Functions_dim(problemName);
                dim = Dims(d);

                tempAlgorithms = algorithms;
                BestCosts = nan(numel(tempAlgorithms), 1);
                tempTimes = nan(numel(tempAlgorithms), 1);
                tempStds = nan(numel(tempAlgorithms), 1);
                tempMaxs = nan(numel(tempAlgorithms), 1);
                tempMins = nan(numel(tempAlgorithms), 1);

                for a = 1:numel(tempAlgorithms)
                    alg = tempAlgorithms{a};
                    if isfield(results(d, p), alg)
                        BestCosts(a) = mean(results(d, p).(alg).Convergence);
                        tempTimes(a) = results(d, p).(alg).MeanCpuTime;
                        tempStds(a) = results(d, p).(alg).StdCost;
                        tempMaxs(a) = max(results(d, p).(alg).Convergence);
                        tempMins(a) = min(results(d, p).(alg).Convergence);
                    end
                end

                costRanks = tiedrank(BestCosts);
                timeRanks = tiedrank(tempTimes);
                Bestcosts = tiedrank(tempMins);
                Worstcost = tiedrank(-tempMaxs);
                Std = tiedrank(tempStds);

                mhoIndex = find(strcmp(tempAlgorithms, algName));
                if ~isempty(mhoIndex)
                    Problems = [Problems; {sprintf('%s, %dD', problemName, dim)}];
                    MaxValues = [MaxValues; tempMaxs(mhoIndex)];
                    MinValues = [MinValues; tempMins(mhoIndex)];
                    MeanValues = [MeanValues; BestCosts(mhoIndex)];
                    StdValues = [StdValues; tempStds(mhoIndex)];
                    Times = [Times; tempTimes(mhoIndex)];
                    CostRanks = [CostRanks; costRanks(mhoIndex)];
                    TimeRanks = [TimeRanks; timeRanks(mhoIndex)];
                    BestcostsRanks = [BestcostsRanks; Bestcosts(mhoIndex)];
                    WorstcostsRanks = [WorstcostsRanks; Worstcost(mhoIndex)];
                    StdRank = [StdRank; Std(mhoIndex)];
                end
            end

            Algorithm = repmat({algName}, numel(Problems), 1);
            SummaryTable = table(Algorithm, Problems, MinValues, BestcostsRanks, MaxValues, WorstcostsRanks, StdValues, ...
                StdRank, MeanValues, CostRanks, Times, TimeRanks, ...
                'VariableNames', {'Algorithm', 'Problem_Dimension', 'Bestcost', 'BestcostsRanks', 'Worstcost', 'WorstcostsRanks', 'Std', ...
                                  'StdRank', 'Mean', 'MeanRank', 'CPUTime', 'CPUTimeRank'});

            disp(SummaryTable);
            
            % **แยก Sheet ตาม Algorithm และ Dimension**
            sheetName = sprintf('%s_%dD', algName, dim);  % เช่น MHO_30D, MHO_50D
            writetable(SummaryTable, filename, 'Sheet', sheetName);
        end
    end
else
    disp('Error: Results variable not found or invalid.');
end
