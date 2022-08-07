function [sys,x0,str,ts]=chap4_3fai(t,x,u,flag)
switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 3,
    sys=mdlOutputs(t,x,u);
case {1,2, 4, 9 }
    sys = [];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 3;
sizes.NumInputs      = 4;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys=simsizes(sizes);
x0=[];
str=[];
ts=[-1 0];
function sys=mdlOutputs(t,x,u)

x=u(1);
y=u(2);
psi=u(3);
ETA=[x;y;psi];

xd=500*sin(0.02*t+pi/4);%u(1)
yd=500*(1-cos(0.02*t+pi/4));%u(2)
psid=0.01*t;%u(3)
ETAD=[xd;yd;psid];
dxd=10*cos(0.02*t+pi/4);
dyd=10*sin(0.02*t+pi/4);
dpsid=0.01;
dETAD=[dxd;dyd;dpsid];

% xd=500*sin(0.02*t+pi/4);%u(1)
% yd=500*cos(0.02*t+pi/4);%u(2)
% psid=0.01*t;%u(3)
% ETAD=[xd;yd;psid];
% dxd=10*cos(0.02*t+pi/4);
% dyd=-10*sin(0.02*t+pi/4);
% dpsid=0.01;
% dETAD=[dxd;dyd;dpsid];

JT=[cos(psi) sin(psi) 0;-sin(psi) cos(psi) 0;0 0 1];
E1=JT*(ETA-ETAD);
K1=diag([0.08,0.08,0.08]);
fzlh1=zeros(3,1);
dfzlh1=zeros(3,1);
L1=zeros(3,1);

a1=0.3;
for i=1:1:3
    fzlh1(i)=a1*(abs(E1(i))^(0.5))*sign(E1(i));
if abs(E1(i))==0;
    dfzlh1(i)=1;
else
    dfzlh1(i)=0.5*a1*(abs(E1(i)))^(-0.5);
end
    L1(i)=(dfzlh1(i)*E1(i)+fzlh1(i))/2;
end
% a1=0.5;B1=1;deata=10^(-5);cc1=(a1/B1)^(1/(1-a1))-deata;d1=B1*deata-(deata+cc1)^a1;
% for i=1:1:3
% if abs(E1(i))>deata;
%     fzlh1(i)=(((abs(E1(i))+cc1)^a1+d1)/B1)*sign(E1(i));
% else
%     fzlh1(i)=E1(i);
% end
%  
% if abs(E1(i))>deata;
%     dfzlh1(i)=(a1/B1)*((abs(E1(i))+cc1)^(a1-1));
% else
%     dfzlh1(i)=1;
% end
%     L1(i)=(dfzlh1(i)*E1(i)+fzlh1(i))/2;
% end

r=u(4);
RT=[0 r 0;-r 0 0;0 0 0];
FAI1=-K1*L1+JT*dETAD-RT*E1;

sys(1)=[1 0 0]*FAI1;
sys(2)=[0 1 0]*FAI1;
sys(3)=[0 0 1]*FAI1;