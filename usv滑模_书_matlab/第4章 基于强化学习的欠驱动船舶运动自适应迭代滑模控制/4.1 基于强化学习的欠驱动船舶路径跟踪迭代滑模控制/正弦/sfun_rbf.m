%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%源自: 沈智鹏 著《船舶运动自适应滑模控制》 2019年科学出版社
%%下载地址www.shenbert.cn/book/shipmotionASMC.html
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [sys,x0,str,ts] = sfun_rbf(t,x,u,flag)

switch flag,
  case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
     case 1,
    sys=mdlDerivatives(t,x,uss);
%   case 2,
%     sys=mdlUpdate(t,x,u);
  case 3,
    sys=mdlOutputs(t,x,u);
  case {2,4,9}
    sys=[];
  otherwise
    DAStudio.error('Simulink:blocks:unhandledFlag', num2str(flag));
end
 

 function [sys,x0,str,ts]=mdlInitializeSizes
 
 sizes = simsizes;
 sizes.NumContStates  = 0;
 sizes.NumDiscStates  = 1;
 sizes.NumOutputs     = 2;
 sizes.NumInputs      = 3;  % 抖振，实际位置的x，y。;
 sizes.DirFeedthrough = 1;
 sizes.NumSampleTimes = 1;   
 x0=[15];
 str = [];
 ts  = [0 0];
 sys = simsizes(sizes);

 
function sys=mdlDerivatives(t,x,uss)

sys=[];

function sys=mdlOutputs(t,x,u)
global xt yt ye ymax c h b dw
xt=u(2); yt=u(3);
ymax=400;
e=yt-200*sin(3.14*xt/2500);
ye=(e)/ymax;%为什么要除ymax？？？？
c=abs(ye);
h=[1 1 1 1 1 1 1 1 1 1];
w=[1 1 1 1 1 1 1 1 1 1];
cj=[-1 -0.75 -0.5  -0.3 0 0.2 0.3 0.5  0.75 1];
b=2;
for i=1:1:10
    h(i)=exp(-norm(c-cj(i))^2/2*b^2);%h为高斯基函数(激活函数)的输出
end
% 权重W的强化学习更新律,h为矩阵，因为式4.1.29的h前系数为实数，可直接用数乘矩阵(方便)。
% u(1)是抖振测量变量M，因为(n)delay time=50!!!
dw=0.1*h*(u(1)-2)/2;
%dw=0.1*(u(1)-2)/2*h;二者效果一样 ，但是不应该先算乘再算除吗？？？
% dw=0.5*h(i)*(M-1)/1为强化学习方法的权重W的更新律(式4.1.29)，而且神经网络参数c和b的强化学习更新律也没写
% 如果更新dc和db要挨个算，因为c和b向量中的元素不一样！！！
w=w+dw;
sys(1)=h*w';%即式4.1.17的滑模面反馈参数k5
sys(2)=ye*ymax;