%% Copyright (c) 2020, Mehdi Ghasri
%% To cooperate in articles, send an email to the following address
% (with Subject=CO Article):
% Email: Eng.mehdighasri@gmail.com
%% Copyright (c) 2019, Mehdi Ghasri
% All rights reserved. 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
% 
% * Redistributions of source code must retain the above copyright notice, this
%   list of conditions and the following disclaimer.
% 
% * Redistributions in binary form must reproduce the above copyright notice,
%   this list of conditions and the following disclaimer in the documentation
%   and/or other materials provided with the distribution
% * Neither the name of IUPUI nor the names of its
%   contributors may be used to endorse or promote products derived from this
%   software without specific prior written permission.
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
% DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
% FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
% DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
% SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
% CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
% OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
function [lb,ub,dim,fobj] = Functions_50(F)
switch F
    case 'F1'
        fobj = @F1;
        lb=-100;
        ub=100;
        dim=50;
        
    case 'F2'
        fobj = @F2;
        lb=-10;
        ub=10;
        dim=50;
        
    case 'F3'
        fobj = @F3;
        lb=-100;
        ub=100;
        dim=50;
        
    case 'F4'
        fobj = @F4;
        lb=-100;
        ub=100;
        dim=50;
        
    case 'F5'
        fobj = @F5;
        lb=-30;
        ub=30;
        dim=50;
        
    case 'F6'
        fobj = @F6;
        lb=-100;
        ub=100;
        dim=50;
        
    case 'F7'
        fobj = @F7;
        lb=-1.28;
        ub=1.28;
        dim=50;
        
    case 'F8'
        fobj = @F8;
        lb=-500;
        ub=500;
        dim=50;
        
    case 'F9'
        fobj = @F9;
        lb=-5.12;
        ub=5.12;
        dim=50;
        
    case 'F10'
        fobj = @F10;
        lb=-32;
        ub=32;
        dim=50;
        
    case 'F11'
        fobj = @F11;
        lb=-600;
        ub=600;
        dim=50;
        
    case 'F12'
        fobj = @F12;
        lb=-50;
        ub=50;
        dim=50;
        
    case 'F13'
        fobj = @F13;
        lb=-50;
        ub=50;
        dim=50;
        
      
end
end
% F1
function o = F1(x)
o=sum(x.^2);
end
% F2
function o = F2(x)
o=sum(abs(x))+prod(abs(x));
end
% F3
function o = F3(x)
dim=size(x,2);
o=0;
for i=1:dim
    o=o+sum(x(1:i))^2;
end
end
% F4
function o = F4(x)
o=max(abs(x));
end
% F5
function o = F5(x)
dim=size(x,2);
o=sum(100*(x(2:dim)-(x(1:dim-1).^2)).^2+(x(1:dim-1)-1).^2);
end
% F6
function o = F6(x)
o=sum(abs((x+.5)).^2);
end
% F7
function o = F7(x)
dim=size(x,2);
o=sum([1:dim].*(x.^4))+rand;
end
% F8
function o = F8(x)
o=sum(-x.*sin(sqrt(abs(x))));
end
% F9
function o = F9(x)
dim=size(x,2);
o=sum(x.^2-10*cos(2*pi.*x))+10*dim;
end
% F10
function o = F10(x)
dim=size(x,2);
o=-20*exp(-.2*sqrt(sum(x.^2)/dim))-exp(sum(cos(2*pi.*x))/dim)+20+exp(1);
end
% F11
function o = F11(x)
dim=size(x,2);
o=sum(x.^2)/4000-prod(cos(x./sqrt([1:dim])))+1;
end
% F12
function o = F12(x)
dim=size(x,2);
o=(pi/dim)*(10*((sin(pi*(1+(x(1)+1)/4)))^2)+sum((((x(1:dim-1)+1)./4).^2).*...
(1+10.*((sin(pi.*(1+(x(2:dim)+1)./4)))).^2))+((x(dim)+1)/4)^2)+sum(Ufun(x,10,100,4));
end
% F13
function o = F13(x)
dim=size(x,2);
o=.1*((sin(3*pi*x(1)))^2+sum((x(1:dim-1)-1).^2.*(1+(sin(3.*pi.*x(2:dim))).^2))+...
((x(dim)-1)^2)*(1+(sin(2*pi*x(dim)))^2))+sum(Ufun(x,5,100,4));
end

function o=Ufun(x,a,k,m)
o=k.*((x-a).^m).*(x>a)+k.*((-x-a).^m).*(x<(-a));
end