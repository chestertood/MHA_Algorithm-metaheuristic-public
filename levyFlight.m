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
function [ o ]=levyFlight(d)
  
    beta=3/2;
    sigma=(gamma(1+beta)*sin(pi*beta/2)/(gamma((1+beta)/2)*beta*2^((beta-1)/2)))^(1/beta);
    u=randn(1,d)*sigma;
    v=randn(1,d);
    step=u./abs(v).^(1/beta);
    o=step;
end