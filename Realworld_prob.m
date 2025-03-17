clc;
clear;
close all;

% สร้างปัญหา TSP
nVar = 10;  % จำนวนเมือง
cities = rand(nVar, 2) * 100;

% คำนวณระยะทางระหว่างเมือง
dist = zeros(nVar, nVar);
for i = 1:nVar
    for j = 1:nVar
        dist(i, j) = norm(cities(i,:) - cities(j,:));
    end
end

problem.CostFunction = @(route) tsp_cost(route, dist);
problem.nVar = nVar;

% กำหนดพารามิเตอร์ MHO
params.MaxIt = 100;
params.nPop = 20;

% เรียกใช้ MHO
[BestSol, BestCost] = MHO_Adaptive(problem, params);

% แสดงผลลัพธ์
disp(['Best Route: ', num2str(BestSol)]);
disp(['Minimum Distance: ', num2str(BestCost)]);

% ===================== ฟังก์ชันคำนวณระยะทางรวม =====================
function cost = tsp_cost(route, dist)
    cost = 0;
    n = length(route);
    for i = 1:n-1
        cost = cost + dist(route(i), route(i+1));
    end
    cost = cost + dist(route(n), route(1)); % กลับไปเมืองแรก
end

% ===================== ฟังก์ชันสุ่มเปลี่ยนเส้นทาง =====================
function new_route = mutate_route(route)
    i = randi(length(route));
    j = randi(length(route));
    new_route = route;
    new_route([i, j]) = new_route([j, i]); % Swap เมืองที่ i และ j
end

function [BestSol, BestCost, Convergence] = MHO_Adaptive(problem, params)
    % Extract Problem Information
    CostFunction = problem.CostFunction;
    nVar = problem.nVar;            % Number of Decision Variables
    VarMin = problem.VarMin;        % Lower Bound of Variables
    VarMax = problem.VarMax;        % Upper Bound of Variables  

    % Algorithm Parameters
    MaxIt = params.MaxIt;           % Maximum Number of Iterations
    nPop = round(params.nPop);             % Population Size params.nPop   
   
    % Initialize Best Solution Ever Found
    Hunter1st_rank.Best_DMG = inf;
   
    Convergence = zeros(MaxIt, 1);  % Array to store best cost at each iteration
    
    positions = VarMin + (VarMax - VarMin) .* rand(nPop, nVar);    
    if isequal(size(VarMax),[1,1])
        VarMin = VarMin .* ones(1,nVar);
        VarMax = VarMax .* ones(1,nVar);
    end
    mid_bound = (VarMax + VarMin)/2;
        
    IS_max = 0.2;
    IS_min = 0;
    safety_sum = 0;
    stun_gauge = 5 ;
    Rwp = 0.5;  %ค่า ระยะอาวุธไกล ปรับได้ ระหว่าง 0 ถึง 0.5 กำลังดี 
    itd = 0;



    Hunter = struct('role', [], 'Best_Position', [], 'Best_DMG', [], 'Try_move',[],'DMG',[]);
    
    role = {'BladeMaster' , 'frontline' , 'Supporter' , 'Ranger'};

    N = round(nPop/4);  
       
    for i = 1:nPop        
        Hunter(i).Try_move = positions(i, :);  % นำตำแหน่งที่เรียงแล้วใส่ใน Hunter
        Hunter(i).DMG = CostFunction(Hunter(i).Try_move);  % เก็บค่า cost ที่เรียงแล้ว  
        Hunter(i).Best_Position = Hunter(i).Try_move;
        Hunter(i).Best_DMG = Hunter(i).DMG;
        Hunter(i).role = role{ceil(i / N)};
        if Hunter(i).Best_DMG < Hunter1st_rank.Best_DMG
            Hunter1st_rank = Hunter(i);
        end

    end
   
    
    matches_BladeMaster = find(cellfun(@(b) isequal(b, 'BladeMaster'), {Hunter.role}));          
    matches_frontline = find(cellfun(@(b) isequal(b, 'frontline'), {Hunter.role}));          
    matches_Ranger = find(cellfun(@(b) isequal(b, 'Ranger'), {Hunter.role}));          
    matches_Supporter = find(cellfun(@(b) isequal(b, 'Supporter'), {Hunter.role}));

    
    %ค้นหา และ ตีจุดอ่อน
    for u = 1:MaxIt

        %เคลื่อนที่ด้วยตัวเอง BladeMaster  
     
        range_run = IS_max - IS_min; 

        IS1 =  IS_max - range_run*((u-1)/(MaxIt));
        IS2 =  IS_min + range_run*((u-1)/(MaxIt));
        
        for i = 1:N            
                
           pos = Hunter(matches_BladeMaster(i)).Try_move;             
           
           Test_Delta1 = pos;
           for j = 1:nVar
            
                dim = Test_Delta1(j);              
                
                new_dim_plus = dim + (2+(-0.5*(u/MaxIt)*rand()))*(Hunter1st_rank.Best_Position(j)-dim) ;  
                if new_dim_plus < VarMin(j)
                    new_dim_plus = 2 * VarMin(j) - new_dim_plus; 
                elseif new_dim_plus > VarMax(j)
                    new_dim_plus = 2 * VarMax(j) - new_dim_plus;
                end
                new_dim_plus = max(VarMin(j), min(VarMax(j), new_dim_plus));                
                                
                Test_Delta1(j) = new_dim_plus;    
            
           end
           
              
                
            Hunter(matches_BladeMaster(i)).Try_move = Test_Delta1;                
            Hunter(matches_BladeMaster(i)).DMG = CostFunction(Hunter(matches_BladeMaster(i)).Try_move);
                
        
            
            if Hunter(matches_BladeMaster(i)).DMG < Hunter(matches_BladeMaster(i)).Best_DMG
                Hunter(matches_BladeMaster(i)).Best_DMG = Hunter(matches_BladeMaster(i)).DMG;
                Hunter(matches_BladeMaster(i)).Best_Position = Hunter(matches_BladeMaster(i)).Try_move;                                
            end
            
            if Hunter(matches_BladeMaster(i)).Best_DMG < Hunter1st_rank.Best_DMG
                Hunter1st_rank = Hunter(matches_BladeMaster(i));
                                          
            end
            
         
            
           
            
           %เคลื่อนที่ด้วย frontline            
    
                       
            pos = Hunter(matches_frontline(i)).Try_move;                    
            
            %ตีเช็ค           
                    

           Test_Delta1 = pos;
           for j = 1:nVar
                dim = Test_Delta1(j);
                
               phi = -1 + 2*rand();  % สุ่มค่าในช่วง [-1,1]
               new_dim_plus = dim + phi * ((2 - 0.5*(u/MaxIt)) * abs(Hunter1st_rank.Best_Position(j)-dim));

                if new_dim_plus < VarMin(j)
                    new_dim_plus = 2 * VarMin(j) - new_dim_plus; 
                elseif new_dim_plus > VarMax(j)
                    new_dim_plus = 2 * VarMax(j) - new_dim_plus;
                end
                new_dim_plus = max(VarMin(j), min(VarMax(j), new_dim_plus));


             
                Test_Delta1(j) = new_dim_plus;                       
             
           end 
          
     
            Hunter(matches_frontline(i)).Try_move = Test_Delta1;                
            Hunter(matches_frontline(i)).DMG = CostFunction(Hunter(matches_frontline(i)).Try_move);
   
        
            if Hunter(matches_frontline(i)).DMG < Hunter(matches_frontline(i)).Best_DMG
                Hunter(matches_frontline(i)).Best_DMG = Hunter(matches_frontline(i)).DMG;
                Hunter(matches_frontline(i)).Best_Position = Hunter(matches_frontline(i)).Try_move;                                
            end        

            if Hunter(matches_frontline(i)).Best_DMG < Hunter1st_rank.Best_DMG
                Hunter1st_rank = Hunter(matches_frontline(i));                
                
            end     
            
           
    
             %วงล้อมรอบจุดอ่อนที่ดีที่สุด เดี๋ยวมาหาใหม่ เอาวงกลมหุบกาง Ranger       
             
             if i <= length(matches_Ranger)
                 Hbest = Hunter1st_rank.Best_Position;    
                 range_weapon = max(0.05 * (VarMax - VarMin), Rwp * exp(-3 * u / MaxIt) * (VarMax - VarMin));
        
                 safety_factor = rand()*2;
                 pos = Hunter(matches_Ranger(i)).Try_move;
                 r = rand();
        
                 if safety_sum > stun_gauge %บอสติดสตั้น เลยเข้ามาตีใกล้ๆ
                     
                     new_pos_plus = pos + (0.7+0.6*rand()) * (Hbest - pos);                  
                     new_pos_plus = max(VarMin, min(VarMax, new_pos_plus));       
                     
                     Hunter(matches_Ranger(i)).Try_move = new_pos_plus;                     
                 
                                          
                     
    
                 elseif safety_sum < stun_gauge %บอสโจมตีไปมา ต้องทิ้งระยะเพื่อความปลอดภัย
                     
                     new_pos_plus = Hbest + r * (range_weapon) ;                 
                     new_pos_plus = max(VarMin, min(VarMax, new_pos_plus));
                     
                     Hunter(matches_Ranger(i)).Try_move = max(VarMin, min(VarMax, pos + (-1+2*rand())*(new_pos_plus-pos)));                 
                     
                         
                 end          
                 if CostFunction(Hunter(matches_Ranger(i)).Try_move)<Hunter(matches_Ranger(i)).Best_DMG 
                    Hunter(matches_Ranger(i)).Best_Position = Hunter(matches_Ranger(i)).Try_move;
                    Hunter(matches_Ranger(i)).Best_DMG = CostFunction(Hunter(matches_Ranger(i)).Best_Position);
                 end
                 
                 if Hunter(matches_Ranger(i)).Best_DMG < Hunter1st_rank.Best_DMG
                    Hunter1st_rank = Hunter(matches_Ranger(i));
                 end
                 
                 
                 if safety_sum>stun_gauge
                     safety_sum = 0;
                 end
                 safety_sum = safety_sum + safety_factor;
             
             end
    
             
           %เคลื่อนที่ด้วย Supporter      
           
           V = exp(1- 10*(u/MaxIt)*rand()); 
           
           
           dim_choose = randi(nVar);
           dim_gbest =  Hunter1st_rank.Best_Position(dim_choose);
           
           
           Try_move = Hunter(matches_Supporter(i)).Try_move;            
           
           
           if rand()<0.5                   
               new_pos = Hunter(matches_Supporter(i)).Try_move;

               for j = 1:nVar              
                   
                       dim = Hunter1st_rank.Best_Position(j)*V;
                       new_pos(j) = Try_move(j) + rand() * (dim - Try_move(j));
                                  
               end
        
               
               new_pos = max(VarMin, min(VarMax, new_pos));
               if CostFunction(new_pos) < Hunter(matches_Supporter(i)).Best_DMG
                   Hunter(matches_Supporter(i)).Best_Position = new_pos;
                   Hunter(matches_Supporter(i)).Best_DMG = CostFunction(new_pos);
               end
               use_pos = Try_move + rand()*(new_pos-Try_move);
               Hunter(matches_Supporter(i)).Try_move = use_pos;
               Hunter(matches_Supporter(i)).DMG = CostFunction(use_pos);
               if Hunter(matches_Supporter(i)).DMG<Hunter(matches_Supporter(i)).Best_DMG
                   Hunter(matches_Supporter(i)).Best_Position = Hunter(matches_Supporter(i)).Try_move;
                   Hunter(matches_Supporter(i)).Best_DMG =  Hunter(matches_Supporter(i)).DMG ;
               end               
           else
               new_pos = dim_gbest.*ones(1,nVar);
               new_pos = max(VarMin, min(VarMax, new_pos));
               if CostFunction(new_pos) < Hunter(matches_Supporter(i)).Best_DMG
                   Hunter(matches_Supporter(i)).Best_Position = new_pos;
                   Hunter(matches_Supporter(i)).Best_DMG = CostFunction(new_pos);
               end
               use_pos = Try_move + rand()*(new_pos-Try_move);
               Hunter(matches_Supporter(i)).Try_move = use_pos;
               Hunter(matches_Supporter(i)).DMG = CostFunction(use_pos);
               if Hunter(matches_Supporter(i)).DMG<Hunter(matches_Supporter(i)).Best_DMG 
                    Hunter(matches_Supporter(i)).Best_Position = Hunter(matches_Supporter(i)).Try_move;
                    Hunter(matches_Supporter(i)).Best_DMG =  Hunter(matches_Supporter(i)).DMG ;
               end            
           end          
           
           
           if Hunter(matches_Supporter(i)).Best_DMG < Hunter1st_rank.Best_DMG
                Hunter1st_rank = Hunter(matches_Supporter(i));                
           end             
           
         

        end
      
      
       itd = itd + 1;
       
       if itd == round(0.5*(MaxIt)) && (u~=MaxIt)
           [~,indexcost_blade] = sort([Hunter(matches_BladeMaster).Best_DMG],'ascend');
           [~,indexcost_front] = sort([Hunter(matches_frontline).Best_DMG],'ascend');
           [~,indexcost_Ranger] = sort([Hunter(matches_Ranger).Best_DMG],'ascend');
           [~,indexcost_Sup] = sort([Hunter(matches_Supporter).Best_DMG],'ascend');
           matches_role = struct( ...
                'matches', {matches_BladeMaster, matches_frontline, matches_Ranger, matches_Supporter}, ...
                'indexcost', {indexcost_blade, indexcost_front, indexcost_Ranger, indexcost_Sup} ...
            );
            itd = 0;
            
            for k = 1:round(N*0.5)
                if rand()<0.5             
                    for i =1:nVar
                        Hunter(matches_BladeMaster(indexcost_blade(end-(k-1)))).Try_move(i) = VarMin(i)+rand()*(VarMax(i)-VarMin(i));  
                         Hunter(matches_frontline(indexcost_front(end-(k-1)))).Try_move(i) = VarMin(i)+rand()*(VarMax(i)-VarMin(i));  
                         Hunter(matches_Ranger(indexcost_Ranger(end-(k-1)))).Try_move(i) = VarMin(i)+rand()*(VarMax(i)-VarMin(i));   
                         Hunter(matches_Supporter(indexcost_Sup(end-(k-1)))).Try_move(i) = VarMin(i)+rand()*(VarMax(i)-VarMin(i)); 
    
                    end   
                else
                    for i = 1:4
                        if rand()<0.5
                            
                            Hunter(matches_role(i).matches(matches_role(i).indexcost(end-(k-1)))).Try_move = VarMax; 

                        else
                            Hunter(matches_role(i).matches(matches_role(i).indexcost(end-(k-1)))).Try_move = VarMin; 

                        end
                    
                    end
                end
                Hunter(matches_BladeMaster(indexcost_blade(end-(k-1)))).DMG = CostFunction(Hunter(matches_BladeMaster(indexcost_blade(end-(k-1)))).Try_move) ;   
                 Hunter(matches_frontline(indexcost_front(end-(k-1)))).DMG = CostFunction(Hunter(matches_frontline(indexcost_front(end-(k-1)))).Try_move) ;  
                  Hunter(matches_frontline(indexcost_front(end-(k-1)))).DMG = CostFunction(Hunter(matches_frontline(indexcost_front(end-(k-1)))).Try_move) ;     
                  Hunter(matches_Supporter(indexcost_Sup(end-(k-1)))).DMG = CostFunction(Hunter(matches_Supporter(indexcost_Sup(end-(k-1)))).Try_move) ;
                  

            end 

           
       end    
       
        Convergence(u) = Hunter1st_rank.Best_DMG;     
        disp(['MHO_Iteration ' num2str(u) ': Best Cost = ' num2str(Convergence(u))]);
        
    end   
    
 % Store the best cost of this iteration in Convergence

BestSol = Hunter1st_rank.Best_Position;


BestCost = Hunter1st_rank.Best_DMG;

                 
end
  
