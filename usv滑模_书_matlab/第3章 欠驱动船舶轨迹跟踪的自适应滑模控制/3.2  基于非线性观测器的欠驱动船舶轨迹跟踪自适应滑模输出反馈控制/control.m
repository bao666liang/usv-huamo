function [sys,x0,str,ts] = control(t,x,u,flag)

switch flag,

  case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;

  case 1,
    sys=mdlDerivatives(t,x,u);

  case 2,
    sys=mdlUpdate(t,x,u);

  case 3,
    sys=mdlOutputs(t,x,u);

  case 4,
    sys=mdlGetTimeOfNextVarHit(t,x,u);

  case 9,
    sys=mdlTerminate(t,x,u);

  otherwise
    error(['Unhandled flag = ',num2str(flag)]);

end

function [sys,x0,str,ts]=mdlInitializeSizes


sizes = simsizes;

sizes.NumContStates  = 2;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 4;
sizes.NumInputs      = 13;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;   % at least one sample time is needed

sys = simsizes(sizes);
str = [];
ts  = [0 0];%sizes.NumSampleTimes = 1; 时若想连续必须写0 0
x0=[0 0];%状态量为干扰上界的估计，用于设计其自适应律

function sys=mdlDerivatives(t,x,u)
twu0=0.1;
twr0=0.1;
s1=u(6);%设计的滑模面，在simulink用模块搭的
s2=u(7);

gama1=1.3*10^4;
gama2=1.7*10^4;

rou1=1.1*10^(-6);%已用1
rou2=0.9*10^(-8);

deta1=1;
deta2=0.02;
%干扰界的自适应律，没有用模块1/s搭，直接写入s函数的微分函数中
sys(1)=gama1*(s1*tanh(s1/deta1)-rou1*(x(1)-twu0));
sys(2)=gama2*(s2*tanh(s2/deta2)-rou2*(x(2)-twr0));
function sys=mdlUpdate(t,x,u)

sys = [];

function sys=mdlOutputs(t,x,u)

eta1=1*10^4;
eta2=1*10^5;

lamda1=1;lamda2=1;

m11=1.2*10^5;m22=1.779*10^5;m33=6.36*10^7;
d11=2.15*10^4;d22=1.47*10^5;d33=8.02*10^6;

alfu=u(1);
alfv=u(2);
dalfu=u(3);
dalfv=u(4);
ue=u(5);
s1=u(6);%滑模面用的alfuv输出ue后再simulink积分模块搭建的，输出到control
s2=u(7);
f_dot=u(8);
dut=u(9);
ut=u(10);
dv=u(11);
v=u(12);
r=u(13);

Twu=x(1);
Twr=x(2);

delta1=1;
delta2=0.02;

%少了个-m11*detla_u 非线性函数g的那一块 因为观测器模型用的3.2.7而不是3.2.13 
%虽然输出X但是simulink里的观测器加了V=Q_1*X，相当于3.2.13 ，detla是根据3.2.13模型推出来的
% 为什么求V_guji_dot用的船舶理想方程，而不是观测方程3.2.13！！！！！！！！
% 因为观测器用的3.2.7求出V_guji，龙伯格观测器会根据观测误差反馈逐渐收敛到0，这时船舶观测模型和理想模型相同
% 控制律就不用加detla了， 但也可以用船舶观测模型求控制律 ，这时要加detla了会麻烦些 。二者一开始跟踪都会不准确
taou=-lamda1*m11*ue-m22*v*r+d11*ut+m11*dalfu-Twu*tanh(s1/delta1)-eta1*s1;
%式3.1.32 但为什么少了m33*tao_wv_dot(横移扰动项)？？？   相比于式3.2.43少了带detla的那三项 
hh=-(m22*alfu*((m11-m22)*ut*v-d33*r)+m22*m33*(r*dalfu-f_dot+lamda2*(dv-dalfv))-d22*m33*dv-m11*m33*dut*r+m11*d33*ut*r+m11*(m22-m11)*ut^2*v);
b=m22*alfu-m11*ut;%式3.2.44


taor=hh/b-Twr*tanh(s2/delta2)-eta2*s2;
sys(1)=Twu;%输出的用自适应估计的扰动的上界（用于画图），而plant用的真实扰动
sys(2)=Twr;
sys(3)=taou;
sys(4)=taor;

function sys=mdlGetTimeOfNextVarHit(t,x,u)

sampleTime = 1;    %  Example, set the next hit to be one second later.
sys = t + sampleTime;


function sys=mdlTerminate(t,x,u)

sys = [];

% end mdlTerminate
