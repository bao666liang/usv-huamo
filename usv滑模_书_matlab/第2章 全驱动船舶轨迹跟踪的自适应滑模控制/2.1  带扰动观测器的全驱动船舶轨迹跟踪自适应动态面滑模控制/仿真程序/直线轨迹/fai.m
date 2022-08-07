function [sys,x0,str,ts]=fai(t,x,u,flag)
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
sizes.NumOutputs     = 3;% 虚拟控制向量alpha1
sizes.NumInputs      =3;% x y psi
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys=simsizes(sizes);
x0=[];
str=[];
ts=[-1 0];%表示根据连接模块的采样频率进行采样
function sys=mdlOutputs(t,x,u)

x=u(1);
y=u(2);
psi=u(3);
ETA=[x;y;psi];
% xd=500*sin(0.02*t);%u(1)
% yd=500*(1-cos(0.02*t));%u(2)
%直线
xd=8*t;
yd=8*t;
psid=0.01*t;
ETAD=[xd;yd;psid];
% dxd=10*cos(0.02*t);
% dyd=10*sin(0.02*t);
dxd=8;
dyd=8;
dpsid=0.01;
dETAD=[dxd;dyd;dpsid];

% 不同于control的xd=8t yt=8t psid=0.01t作为输入，这里人为给定值不需要外部输入了
S1=ETA-ETAD;% 实际位姿减(输入)去期望位姿(人为给定直线)即位姿误差向量
K1=diag([0.08,0.08,0.08]);
JT=[cos(psi) sin(psi) 0;-sin(psi) cos(psi) 0;0 0 1];
FAI1=-JT*K1*S1+JT*dETAD;
sys(1)=[1 0 0]*FAI1;
sys(2)=[0 1 0]*FAI1;
sys(3)=[0 0 1]*FAI1;