%_________________________________________________________________________
%  Walrus Optimizer (WO) source code (Developed in MATLAB R2023a)
%  Source codes demo version 1.0
%  programming: Muxuan Han & Qiuyu Yuan
%
%  Please refer to the main paper:
%  Muxuan Han, Zunfeng Du, Kumfai Yuen, Haitao Zhu, Yancang Li, Qiuyu Yuan. 
%  Walrus Optimizer: A novel nature-inspired metaheuristic algorithm, 
%  Expert Systems with Applications, November 2023, 122413. 
%  https://doi.org/10.1016/j.eswa.2023.122413
%  
%  E-mails: hanmuxuan@tju.edu.cn         (Muxuan Han)
%           dzf@tju.edu.cn               (Zunfeng Du)
%           kumfai.yuen@ntu.edu.sg       (Kumfai Yuen)
%           htzhu@tju.edu.cn             (Haitao Zhu) 
%           liyancang@hebeu.edu.cn       (Yancang Li)
%           yuanqiuyu@tju.edu.cn         (Qiuyu Yuan)
%_________________________________________________________________________
function [Best_Score,Best_Pos,Convergence_curve_WO]=WO(SearchAgents_no,Max_iter,lb,ub,dim,fobj)
% Initialize Best_pos and Second_pos
Best_Pos=zeros(1,dim); Second_Pos=zeros(1,dim);
Best_Score=inf; Second_Score=inf;%change this to -inf for maximization problems
GBestX=repmat(Best_Pos,SearchAgents_no,1);
%Initialize the positions of search agents
X=initialization(SearchAgents_no,dim,ub,lb);
Convergence_curve_WO=zeros(1,Max_iter);
% fitness=inf(SearchAgents_no,1);
P=0.4; % Proportion of females
F_number=round(SearchAgents_no*P); % Number of females
M_number=F_number; % The males are equal in number to the females
C_number=SearchAgents_no-F_number-M_number; % Number of children
    
t=0;% Loop counter
% fobj = @(x) funtest(x);
while t<Max_iter
    for i=1:size(X,1)
        Flag4ub=X(i,:)>ub;
        Flag4lb=X(i,:)<lb;
        X(i,:)=(X(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb; % Check boundries
        fitness=fobj(X(i,:)); % Calculate objective function
        if fitness<Best_Score
            Best_Score=fitness;
            Best_Pos=X(i,:); % Update Best_pos
        end
        
        if fitness>Best_Score && fitness<Second_Score
            Second_Score=fitness;
            Second_Pos=X(i,:); % Update Second_pos
        end
    end
    
    Alpha=1-t/Max_iter;
    Beta=1-1/(1+exp((1/2*Max_iter-t)/Max_iter*10));
    A=2*Alpha; % A decreases linearly fron 2 to 0
    r1=rand();
    R=2*r1-1;
    Danger_signal=A*R;
    r2=rand();
    Satey_signal=r2;
    
    if abs(Danger_signal)>=1
        r3=rand();
        Rs=size(X,1);
        Migration_step=(Beta*r3^2)*(X(randperm(Rs),:)-X(randperm(Rs),:));
        X=X+Migration_step;
    elseif abs(Danger_signal)<1
        if Satey_signal>=0.5
            for i = 1:M_number
                xy=zeros(M_number,0);
                base=7;
                xy(i,1)=hal(i,base);
                M=[];
                m1=xy(i,:);
                m1=lb+m1.*(ub-lb);
                M=[M; m1];
                X(i,:)=M;
            end
            for j = M_number+1:M_number+F_number
                X(j,:) = X(j,:)+Alpha*(X(i,:)-X(j,:))+(1-Alpha)*(GBestX(j,:)-X(j,:));
            end
            for i = SearchAgents_no-C_number+1:SearchAgents_no
                P=rand;
                o=GBestX(i,:)+X(i,:).*levyFlight(dim);
                X(i,:)=P*(o-X(i,:));
            end
        end
                
        if Satey_signal<0.5 && abs(Danger_signal)>=0.5
            for i = 1:SearchAgents_no
                r4=rand;
                X(i,:)=X(i,:)*R-abs(GBestX(i,:)-X(i,:))*r4^2;
            end
        end
        
        if Satey_signal<0.5 && abs(Danger_signal)<0.5
            for i=1:size(X,1)
                for j=1:size(X,2)
                    
                    theta1=rand();
                    a1=Beta*rand()-Beta;
                    b1=tan(theta1.*pi);
                    X1=Best_Pos(j)-a1*b1*abs(Best_Pos(j)-X(i,j));
                    
                    theta2=rand();
                    a2=Beta*rand()-Beta;
                    b2=tan(theta2.*pi);
                    X2=Second_Pos(j)-a2*b2*abs(Second_Pos(j)-X(i,j));
                    
                    X(i,j)=(X1+X2)/2;
                end
            end
        end
    end
    t=t+1;
    Convergence_curve_WO(t)=Best_Score;
end