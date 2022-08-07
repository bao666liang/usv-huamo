%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%源自: 沈智鹏 著《船舶运动自适应滑模控制》 2019年科学出版社
%%下载地址www.shenbert.cn/book/shipmotionASMC.html
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [sys,x0,str,ts]=npd1(t,x,u,flag)
switch flag,
case 0,
[sys,x0,str,ts]=mdlInitializeSizes;
case 2,
sys=mdlUpdates(x,u);
case 3,
sys=mdlOutputs(t,x,u);
case {1,4,9}
sys=[];
otherwise
error(['Unhandled flag=',num2str(flag)]);
end;
%初始化子程序
function[sys,x0,str,ts]=mdlInitializeSizes
sizes=simsizes; %生成size数据结构
sizes.NumContStates=0; %连续状态数
sizes.NumDiscStates=3; %离散状态数
sizes.NumOutputs=4; %输出量个数
sizes.NumInputs=7; %输入量个数e(k)、△e(k)、 △2e(k) sgm4 dsgm4 sgm4d dsgm4d
sizes.DirFeedthrough=1; %是否存在代数循环(1一存在)
sizes.NumSampleTimes=1; %采样时间个数
sys=simsizes(sizes); %返回size数据结构所包含的信息
x0=[0;0;0]; %设置初值状态
str=[]; %保留变量并置空
ts=[-1 0]; %采样时间 
% when flag=2，updates the diserete states
function sys =mdlUpdates(x,u)
 T=1;
sys=[u(1);
(u(1)-u(2))/T;
   1];

% when flag=3，computates the output signals
function sys=mdlOutputs(t,x,u)
persistent wkpl_1 wkil_1 wkdl_1  ul_1 

 xite=0.5;
 D=10000;
  a=100;b=0.1;
% kl=0.001*(a+b*u(1));
 kl=0.1;
if t==0 %Initilizing kp,ki and kd
wkpl_1=0.1;
wkil_1=0.1;
wkdl_1=0.1;
ul_1=0;
end

wkpl=wkpl_1-xite*kl*(u(5)+D*u(4))*(u(7)+D*u(6))*x(1);%P
wkdl=wkdl_1-xite*kl*(u(5)+D*u(4))*(u(7)+D*u(6))*x(2);%D
wkil=wkil_1-xite*kl*(u(5)+D*u(4))*(u(7)+D*u(6))*x(3);%1

waddl=abs(wkpl)+abs(wkil)+abs(wkdl);
wlll=wkpl/waddl;
wl22=wkdl/waddl;
wl33=wkil/waddl;
wl=[wlll,wl22,wl33];

ul=kl*wl*x;

wkpl_1=wkpl;
wkdl_1=wkdl;
wkil_1=wkil;
ul_1=ul;
sys(1)=ul;
sys(2)=wlll;
sys(3)=wl22;
sys(4)=wl33;