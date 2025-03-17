clc; clear; close all;

% ตั้งค่า GA Options
opts = optimoptions('ga', 'Display', 'off');

% Lower bound ของตัวแปร (ต้องเป็นแถวเดียวกัน)
lb = [1 1 1 1];

% Upper bound ของตัวแปร
ub = [20 10 10 10];

% Integer constraints (บอกว่า 4 ตัวนี้เป็นค่าจำนวนเต็ม)
IntCon = 1:4;

% เรียกใช้ Genetic Algorithm
[finalResult, ~, ~] = ga(@productionCost, 4, [], [], [], [], lb, ub, [], IntCon, opts);

% แสดงผลลัพธ์
disp('Optimal Resource Allocation:');
disp(finalResult);

% -------------------
% ฟังก์ชัน Objective
function obj = productionCost(ResourceCapacity)

    % ค่าต้นทุนของอุปกรณ์ [batch reactors, water tanks, heaters, drains]
    cost = [1000, 300, 200, 100] * ResourceCapacity(:); 

    % ส่งค่าตัวแปรไปยัง workspace ของ MATLAB
    assignin('base', 'ResourceCapacity', ResourceCapacity);

    % ตรวจสอบว่ามี Simulink Model อยู่หรือไม่
    if isempty(find_system('type', 'block_diagram', 'Name', 'seExampleBatchProduction'))
        load_system('seExampleBatchProduction');
    end

    % ตั้งค่าพารามิเตอร์ให้กับ Simulink Model
    set_param('seExampleBatchProduction/ConfigResource', 'NumBatchReactor', num2str(ResourceCapacity(1)), ...
              'NumWater', num2str(ResourceCapacity(2)), ...
              'NumHeat', num2str(ResourceCapacity(3)), ...
              'NumDrain', num2str(ResourceCapacity(4)));

    % รัน Simulink และเก็บค่าผลลัพธ์
    try
        simOut = sim('seExampleBatchProduction', 'ReturnWorkspaceOutputs', 'on');
        backlog = simOut.get('z');
        backlog = backlog(end); % ใช้ค่าล่าสุดของ backlog
    catch
        warning('Simulink simulation failed, setting backlog to a high penalty.');
        backlog = 1e6; % ตั้งค่า penalty ถ้า Simulink รันไม่สำเร็จ
    end

    % คำนวณ objective function
    obj = backlog * 10000 + cost;

end
