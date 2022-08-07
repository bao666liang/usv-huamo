function [sys,x0,str,ts]=chap4_3VG(t,x,u,flag)
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
sizes.NumInputs      = 7;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0=[];
str = [];
ts  = [0 0];


function sys=mdlOutputs(t,x,u)
psi=u(1);
X2=[u(2);u(3);u(4)];
ETAE=[u(5);u(6);u(7)];
JT=[cos(psi) sin(psi) 0;-sin(psi) cos(psi) 0;0 0 1];

K3o=diag([1,1,1]);
VG=X2-K3o*JT*ETAE;

sys(1)=[1 0 0]*VG;
sys(2)=[0 1 0]*VG;
sys(3)=[0 0 1]*VG;




