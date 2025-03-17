% Example data (BestCosts)
format long g

% Example data (BestCosts)
tempBestCosts = [998.534943966666, 1136.15930739707, 0.00635476077323557, ...
    22515.7244859557, 66553.270055238, 461.510307684958, ...
    5.30886023405584e-08, 2.35092986795546e-13, 9971.4507822356, ...
    0.103563468200581];

% Initialize the ranks array
ranks = zeros(size(tempBestCosts));

% Loop through each BestCost value and assign ranks
for i = 1:length(tempBestCosts)
    rank = 1;  % Start with rank 1 for each BestCost
    for j = 1:length(tempBestCosts)
        if tempBestCosts(i) > tempBestCosts(j)
            rank = rank + 1;  % If the current BestCost is greater than another, increase its rank
        end
    end
    ranks(i) = rank;  % Assign the rank to the current BestCost
end

% Display the results
disp('Algorithm Ranks Based on BestCost:');
for i = 1:length(tempBestCosts)
    fprintf('Algorithm %d: BestCost = %.20f, Rank = %d\n', i, tempBestCosts(i), ranks(i));
end
