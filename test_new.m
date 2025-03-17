% จำนวนประชากรและตัวแปร
nPop = 40;    % จำนวนประชากร
nVar = 10;    % จำนวนตัวแปร

% ขอบเขต (bound)
VarMin = -100; % Minimum bound
VarMax = 100;  % Maximum bound

% สร้าง Sobol Sequence

sobolSeq = sobolset(nVar, 'Skip', 1e3, 'Leap', 1e2); % ข้ามจุดเริ่มต้นเพื่อความเป็นสุ่ม
sobolPoints = net(sobolSeq, nPop); % สร้าง nPop จุด

% ปรับแต่งให้เข้ากับช่วง [VarMin, VarMax]
popPositions = VarMin + sobolPoints * (VarMax - VarMin);

% สร้างประชากรในรูปแบบโครงสร้าง
pop = struct('Position', num2cell(popPositions, 2), 'Cost', [], 'Velocity', []);
disp(pop(1));

plot(popPositions(:, 1), popPositions(:, 2), 'ro');
xlabel('X Position');
ylabel('Y Position');
title('Sobol Sequence Population');
grid on;

