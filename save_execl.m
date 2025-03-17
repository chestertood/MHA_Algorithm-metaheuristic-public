% ตั้งชื่อไฟล์ Excel
filename = 'Optimization_Comparison.xlsx';

% รายชื่ออัลกอที่ต้องการเปรียบเทียบ
algorithms = {'GA', 'PSO', 'GWO', 'SA', 'MHO', 'WO', 'Puma', 'HBO', 'WOA'};

% ลูปแต่ละอัลกอริธึม
for algIdx = 1:numel(algorithms)
    algName = algorithms{algIdx};  % ชื่ออัลกอในรอบนั้น
    
    % Initialize arrays for table data
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
    
    % Loop through problems
    for p = 1:numel(results)
        problemName = results(p).Problem;  % ชื่อปัญหา
        [lb, ub, dim, fobj] = Functions(problemName);  % ดึงข้อมูลปัญหา
        
        % ตรวจสอบว่ามีข้อมูลของอัลกอในผลลัพธ์หรือไม่
        if isfield(results(p), algName)
            BestCost = mean(results(p).(algName).Convergence);
            StdCost = results(p).(algName).StdCost;
            MaxCost = max(results(p).(algName).Convergence);
            MinCost = min(results(p).(algName).Convergence);
            MeanCpuTime = results(p).(algName).MeanCpuTime;
        else
            BestCost = inf;
            StdCost = inf;
            MaxCost = inf;
            MinCost = inf;
            MeanCpuTime = inf;
        end
        
        % เก็บค่าต่าง ๆ
        Problems = [Problems; {sprintf('%s, %dD', problemName, dim)}]; %#ok<AGROW>
        MaxValues = [MaxValues; MaxCost]; %#ok<AGROW>
        MinValues = [MinValues; MinCost]; %#ok<AGROW>
        MeanValues = [MeanValues; BestCost]; %#ok<AGROW>
        StdValues = [StdValues; StdCost]; %#ok<AGROW>
        Times = [Times; MeanCpuTime]; %#ok<AGROW>
    end
    
    % สร้างตารางสำหรับอัลกอปัจจุบัน
    SummaryTable = table(Problems, MinValues, MaxValues, StdValues, MeanValues, Times, ...
        'VariableNames', {'Problem_Dimension', 'Bestcost', 'Worstcost', 'Std', 'Mean', 'CPUTime'});
    
    % เขียนลงไฟล์ Excel
    writetable(SummaryTable, filename, 'Sheet', algName);
end

disp('บันทึกผลลัพธ์ลง Excel สำเร็จ!');
