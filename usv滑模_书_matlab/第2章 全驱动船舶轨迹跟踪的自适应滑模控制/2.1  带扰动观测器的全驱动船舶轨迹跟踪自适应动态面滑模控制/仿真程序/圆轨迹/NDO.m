function [sys,x0,str,ts] = NDO(t,x,u,flag)
switch flag
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 1,
    sys=mdlDerivatives(t,x,u);
case 3,
    sys=mdlOutputs(t,x,u);
case {2,4,9},
    sys=[];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end


function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 3;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 3;
sizes.NumInputs      = 6;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = [0 0 0];
str = [];
ts  = [0 0];

function sys=mdlDerivatives(t,x,u);


ut=u(4);
v=u(5);
r=u(6);
TAO=[u(1);u(2);u(3)];

VV=[ut;v;r];
m11=5.3122*10^6;
m22=8.2831*10^6;
m23=0;
m33=3.7454*10^9;
M=[5.3122*10^6 0 0;0 8.2831*10^6 0;0 0 3.7454*10^9];
C=[0 0 -m22*v-m23*r;0 0 m11*ut;m22*v+m23*r -m11*ut 0];
D=[5.0242*10^4 0 0;0 2.7229*10^5 -4.3933*10^6;0 -4.3933*10^6 4.1894*10^8];

% K0=diag([30,30,30]);
K0=diag([2,2,2]);
XX=[x(1);x(2);x(3)];

sys(1)=[1 0 0]*(-K0*XX-K0*(-C*VV-D*VV+TAO+K0*M*VV));
sys(2)=[0 1 0]*(-K0*XX-K0*(-C*VV-D*VV+TAO+K0*M*VV));
sys(3)=[0 0 1]*(-K0*XX-K0*(-C*VV-D*VV+TAO+K0*M*VV));

function sys=mdlOutputs(t,x,u)

ut=u(4);
v=u(5);
r=u(6);
VV=[ut;v;r];
M=[5.3122*10^6 0 0;0 8.2831*10^6 0;0 0 3.7454*10^9];

% K0=diag([30,30,30]);
K0=diag([2,2,2]);
XX=[x(1);x(2);x(3)];

sys(1)=[1 0 0]*(XX+K0*M*VV);
sys(2)=[0 1 0]*(XX+K0*M*VV);
sys(3)=[0 0 1]*(XX+K0*M*VV);

