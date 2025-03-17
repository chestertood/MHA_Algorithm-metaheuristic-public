fun = @algorithm;
N = 300;
D = 2;
lb = [0 0];
ub = [1 1];
itermax = 100;

for i=1:N
    for j=1:D          
        pos(i,j)=lb(j)+rand.*(ub(j)-lb(j));
    end
end
disp(pos)

fx = fun(pos);

[fminvalue, ind] = min(fx);
gbest = pos(ind,:);

iter = 1;
while iter<itermax
    Fgbest = fminvalue;
    a = 2-2*iter/itermax;
    for i=1:N
        X = pos(i,:);
        pos1 = pos;
        A1 = 2.*a.*rand(1,D)-a;
        C1 = 2.*rand(1,D);
        [alpha, alphaind] = min(fx);
        alphapos = pos1(alphaind,:);
        Dalpha = abs(C1.*alphapos-X);
        X1 = alphapos - A1.*Dalpha;

        pos1(alphaind,:)=[];
        fx1 = fun(pos1);
        [bet,betind]=min(fx1);
        betpos = pos1(betind,:);
        A2 = 2.*a.*rand(1,D)-a;
        C2 = 2.*rand(1,D);
        Dbet = abs(C2.*betpos-X);
        X2 = betpos - A2.*Dbet;

        pos1(betind,:)=[];
        fx1 = fun(pos1);
        [delta,deltaind]=min(fx1);
        deltapos = pos1(deltaind,:);
        A3 = 2.*a.*rand(1,D)-a;
        C3 = 2.*rand(1,D);
        Ddelta = abs(C3.*betpos-X);
        X3 = deltapos - A3.*Ddelta;

        Xnew = (X1+X2+X3)./3;
        Xnew = max(Xnew,lb);
        Xnew = min(Xnew,ub);
        fnew = fun(Xnew);
        if fnew<fx(i)
            pos(i,:) = Xnew;
            fx(i,:) = fnew;
        end
    end 
    
    [fmin,find] = min(fx);
    if fmin<Fgbest
        Fgbest = fmin;
        gbest = pos(find,:);
    end
    [optval, optind] = min(fx);
    BestFx(iter) = optval;
    BestX(iter,:) = pos(optind,:);

    disp(['Iteration ' num2str(iter) ': best cost = ' num2str(BestFx(iter))]);
    

    plot(BestFx, 'Linewidth',2);
    xlabel('iter')
    ylabel('fitness value')
    title('convergence Vs iteration')
    grid on 

    iter=iter+1;

end

% Define example values for A1 and A2
A1 = [1; 2; 3];  % Column vector with 3 rows
A2 = [4; 5; 6];  % Column vector with 3 rows
P = 2;           % Example value for P
l = 100;

fx = (2*sqrt(2).*A1+A2).*l;
% Calculate each column of g
g(:,1) = (P .* (sqrt(2) .* A1 + A2) ./ (sqrt(2) .* A1.^2 + 2 .* A1 .* A2)) - 2;
g(:,2) = (P .* A2 ./ (sqrt(2) .* A1.^2 + 2 .* A1 .* A2)) - 2;
g(:,3) = (P ./ (A1 + sqrt(2) .* A2)) - 2;

% Display the result
pp = 10^9;
    for i=1:size(g,1)
        for j=1:size(g,2)
           
            if g(i,j)>0
                penalty(i,j) = pp.*g(i,j);
            else
                penalty(i,j)=0;
            end
        end
    end




       
        




