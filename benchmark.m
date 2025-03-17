clc; clear; close all;

% เลือกฟังก์ชันที่ต้องการพล็อต
F= "F10";
[lb,ub,dim,fobj] = Functions(F);
benchmark_func = fobj; % เปลี่ยนเป็น F2, F3, ..., F23 ตามต้องการ


% กำหนดช่วงค่า x และ y
x = linspace(lb, ub, 100);
y = linspace(lb, ub, 100);
[X, Y] = meshgrid(x, y);

% คำนวณค่าของฟังก์ชันที่จุดแต่ละจุด
Z = arrayfun(@(x, y) benchmark_func([x, y]), X, Y);

% พล็อต 3D Surface
figure;
surf(X, Y, Z, 'EdgeColor', 'none');
colormap(jet);
colorbar;
title('Benchmark Function Landscape');
xlabel('X'); ylabel('Y'); zlabel('f(X, Y)');
grid on;