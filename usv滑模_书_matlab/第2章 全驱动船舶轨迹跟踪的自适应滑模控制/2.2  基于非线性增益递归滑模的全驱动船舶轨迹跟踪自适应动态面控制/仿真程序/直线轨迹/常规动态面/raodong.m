function [sys,x0,str,ts] = raodong(t,x,u,flag)
switch flag,
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
sizes.NumInputs      = 2;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = [0 0 0];
str = [];
ts  = [];

function sys=mdlDerivatives(t,x,u);

nn=u(2);
N=[nn;nn;nn];
TC=diag([1000,1000,1000]);
R=diag([5*10^4,5*10^4,5*10^5]);
B=[x(1);x(2);x(3)];
sys(1)=[1 0 0]*(R*N-inv(TC)*B);
sys(2)=[0 1 0]*(R*N-inv(TC)*B);
sys(3)=[0 0 1]*(R*N-inv(TC)*B);

function sys=mdlOutputs(t,x,u)

psi=u(1);
JT=[cos(psi) sin(psi) 0;-sin(psi) cos(psi) 0;0 0 1];
B=[x(1);x(2);x(3)];
sys(1)=[1 0 0]*JT*B;
sys(2)=[0 1 0]*JT*B;
sys(3)=[0 0 1]*JT*B;
