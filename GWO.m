function [Alpha_score,Alpha_pos,Convergence_curve]=GWO(SearchAgents_no,Max_iter,lb,ub,dim,fobj)

% Default fitness function
if nargin < 6 || isempty(fobj)
    fobj = @(x) sum(x.^2); % Default: Sphere function
end

% Initialize alpha, beta, and delta_pos
Alpha_pos=zeros(1,dim);
Alpha_score=inf; % Change this to -inf for maximization problems

Beta_pos=zeros(1,dim);
Beta_score=inf; 

Delta_pos=zeros(1,dim);
Delta_score=inf; 

% Initialize the positions of search agents
Positions=initialization(SearchAgents_no,dim,ub,lb);

Convergence_curve=zeros(1,Max_iter);
l=0; % Loop counter

% Main loop
while l<Max_iter
    for i=1:size(Positions,1)  
        
        % Return back search agents that go beyond the boundaries
        Flag4ub=Positions(i,:)>ub;
        Flag4lb=Positions(i,:)<lb;
        Positions(i,:)=(Positions(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;               
        
        % Calculate objective function
        fitness=fobj(Positions(i,:));
        
        % Update Alpha, Beta, and Delta
        if fitness<Alpha_score 
            Alpha_score=fitness;
            Alpha_pos=Positions(i,:);
        elseif fitness>Alpha_score && fitness<Beta_score 
            Beta_score=fitness;
            Beta_pos=Positions(i,:);
        elseif fitness>Alpha_score && fitness>Beta_score && fitness<Delta_score 
            Delta_score=fitness;
            Delta_pos=Positions(i,:);
        end
    end
    
    % Parameter 'a' decreases linearly
    a=2-l*((2)/Max_iter);
    
    % Update positions
    for i=1:size(Positions,1)
        for j=1:size(Positions,2)     
            r1=rand(); r2=rand();
            A1=2*a*r1-a; C1=2*r2;
            D_alpha=abs(C1*Alpha_pos(j)-Positions(i,j));
            X1=Alpha_pos(j)-A1*D_alpha;

            r1=rand(); r2=rand();
            A2=2*a*r1-a; C2=2*r2;
            D_beta=abs(C2*Beta_pos(j)-Positions(i,j));
            X2=Beta_pos(j)-A2*D_beta;       

            r1=rand(); r2=rand();
            A3=2*a*r1-a; C3=2*r2;
            D_delta=abs(C3*Delta_pos(j)-Positions(i,j));
            X3=Delta_pos(j)-A3*D_delta;             

            Positions(i,j)=(X1+X2+X3)/3;
        end
    end
    
    l=l+1;
    Convergence_curve(l)=Alpha_score; % Store best fitness
end
end
