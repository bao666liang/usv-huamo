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
sizes.NumInputs      = 3;
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

xd=8*t;%u(1)
yd=8*t;%u(2)
psid=0.01*t;%u(3)
ETAD=[xd;yd;psid];
dxd=8;
dyd=8;
dpsid=0.01;
dETAD=[dxd;dyd;dpsid];

JT=[cos(psi) sin(psi) 0;-sin(psi) cos(psi) 0;0 0 1];

S1=JT*(ETA-ETAD);
K1=diag([0.08,0.08,0.08]);

FAI1=-K1*S1+JT*dETAD;

sys(1)=[1 0 0]*FAI1;
sys(2)=[0 1 0]*FAI1;
sys(3)=[0 0 1]*FAI1;