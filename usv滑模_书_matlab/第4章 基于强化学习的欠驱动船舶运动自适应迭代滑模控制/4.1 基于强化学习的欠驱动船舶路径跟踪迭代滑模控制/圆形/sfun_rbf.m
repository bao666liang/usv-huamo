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
 sizes.NumOutputs     = 12;
 sizes.NumInputs      = 6;  % 抖振，圆的x0，y0，R，实际位置的x，y。;
 sizes.DirFeedthrough = 1;
 sizes.NumSampleTimes = 1;   
 x0=[3];
 str = [];
 ts  = [0 0];
 sys = simsizes(sizes);

 
function sys=mdlDerivatives(t,x,uss)

sys=[];

function sys=mdlOutputs(t,x,u)
global  xo yo R xt yt ye ymax c h b dw
xo=u(2); yo=u(3); R=u(4); xt=u(5); yt=u(6);
ymax=(sqrt((xo)^2+(yo)^2)-R);
ye=(sqrt((xo-xt)^2+(yo-yt)^2)-R)/ymax;
c=abs(ye);
h=[0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1];
w=[1 1 1 1 1 1 1 1 1 1];

%cj=[-1 -0.75 -0.5  -0.3 0 0.2 0.3 0.5  0.75 1];
cj=[-1 -0.75 -0.5  -0.3 0 0.2 0.3 0.5  0.75 1];
b=2;
for i=1:1:10;
    h(i)=exp(-norm(c-cj(i))^2/2*b^2);
end

%dw=0.5*(u(1)-0.8)/2*h;标准可用！！
%dw=0.5*(u(1)-2)/0.2*h;%会反向控制住
dw=0.5*(u(1)-0.3)/0.3*h;
%dw=5*(u(1)-2)/10*h;
w=w+dw;
sys(1)=h*w';
sys(2)=ye*ymax;
 sys(3)=[1 0 0 0 0 0 0 0 0 0]*w';
 sys(4)=[0 1 0 0 0 0 0 0 0 0]*w';
 sys(5)=[0 0 1 0 0 0 0 0 0 0]*w';
 sys(6)=[0 0 0 1 0 0 0 0 0 0]*w';
 sys(7)=[0 0 0 0 1 0 0 0 0 0]*w';
 sys(8)=[0 0 0 0 0 1 0 0 0 0]*w';
 sys(9)=[0 0 0 0 0 0 1 0 0 0]*w';
sys(10)=[0 0 0 0 0 0 0 1 0 0]*w';
sys(11)=[0 0 0 0 0 0 0 0 1 0]*w';
sys(12)=[0 0 0 0 0 0 0 0 0 1]*w';











