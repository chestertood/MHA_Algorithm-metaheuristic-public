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
function halton=hal(index,base)
result=0;
f=1/base;
i=index;
while(i>0)
    result=result+f*mod(i,base);
    i=floor(i/base);
    f=f/base;
end
halton=result;
end
