function [sys,x0,str,ts]=chap4_3plant(t,x,u,flag)
switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 1,
    sys=mdlDerivatives(t,x,u);
case 3,
    sys=mdlOutputs(t,x,u);
case {2, 4, 9 }
    sys = [];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 6;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 6;
sizes.NumInputs      = 3;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys=simsizes(sizes);
x0=[-100 200 pi/4 0 0 0];
str=[];
ts=[];
function sys=mdlDerivatives(t,x,u)
TAO=[u(1);u(2);u(3)];
ut=x(4);v=x(5);r=x(6);
psi=x(3);
m11=5.3122*10^6;
m22=8.2831*10^6;
m23=0;
m33=3.7454*10^9;
M=[5.3122*10^6 0 0;0 8.2831*10^6 0;0 0 3.7454*10^9];
C=[0 0 -m22*v-m23*r;0 0 m11*ut;m22*v+m23*r -m11*ut 0];
du=5.0242*10^4;
dv=2.7229*10^5;
dr=4.1894*10^8;
D=[5.0242*10^4 0 0;0 2.7229*10^5 -4.3933*10^6;0 -4.3933*10^6 4.1894*10^8];
DDD=[1*10^5*(sin(0.2*t)+cos(0.5*t));1*10^5*(sin(0.1*t)+cos(0.4*t));1*10^6*(sin(0.5*t)+cos(0.3*t))];
VV=[ut;v;r];
J=[cos(psi) -sin(psi) 0;sin(psi) cos(psi) 0;0 0 1];

sys(1)=[1 0 0]*J*VV;
sys(2)=[0 1 0]*J*VV;
sys(3)=[0 0 1]*J*VV;
sys(4)=[1 0 0]*inv(M)*(-C*VV-D*VV+TAO+DDD);
sys(5)=[0 1 0]*inv(M)*(-C*VV-D*VV+TAO+DDD);
sys(6)=[0 0 1]*inv(M)*(-C*VV-D*VV+TAO+DDD);


function sys=mdlOutputs(t,x,u)

sys(1)=x(1);
sys(2)=x(2);
sys(3)=x(3);
sys(4)=x(4);
sys(5)=x(5);
sys(6)=x(6);
