function out = algorithm(X)
    A1 = X(:,1);
    A2 = X(:,2);
    l = 100;
    P = 2;
    fx = (2*sqrt(2).*A1+A2).*l;
    g(:,1) = (P.*(sqrt(2).*A1+A2)./(sqrt(2).*A1.^2+2.*A1.*A2))-2;
    g(:,2) = (P.*A2./(sqrt(2).*A1.^2+2.*A1.*A2))-2;
    g(:,3) = (P./(A1+sqrt(2).*A2))-2;
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
    
    out = fx + sum(penalty,2);


        
       









