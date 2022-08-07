function [sys,x0,str,ts] = plant(t,x,u,flag)%t当前时间；x状态向量；u输入向量；
switch flag
case 0
    [sys,x0,str,ts]=mdlInitializeSizes;
case 1
    sys=mdlDerivatives(t,x,u);
case 3
    sys=mdlOutputs(t,x,u);
case {2,4,9} % 仅考虑连续和输出函数，不需要离散和终止函数
    sys=[];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end


function [sys,x0,str,ts]=mdlInitializeSizes %初始化子函数
sizes = simsizes;
sizes.NumContStates  = 6;% 连续状态变量个数 x y psi u v r
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 6;% 输出个数 x y psi u v r
sizes.NumInputs      = 6;% 输入个数 真实扰动和推进器力[d1 d2 d3 tao1 tao2 tao3]
sizes.DirFeedthrough = 0;% 无直馈 如果输入u在mdlOutputs中被访问，即输入是输出的函数则存在直接馈通
sizes.NumSampleTimes = 0;%NumSampleTimes表示采样时间的个数
sys = simsizes(sizes);
x0  = [-100 200 pi/4 0 0 0];%初始状态
str = [];
ts  = [];%采样时刻[采样时间 偏移量]

function sys=mdlDerivatives(t,x,u);
% 计算连续状态变量的导数x_dot y_dot psi_dot u_dot v_dot r_dot
% 即状态方程
% if t>50;
% DDD=[u(1);u(2);u(3)];
% else
% DDD=[0;0;0];
% end

DDD=[u(1);u(2);u(3)];%扰动 raodong = [d1 d2 d3]
% DDD=[1*10^8;1*10^8;1*10^9];
TAO=[u(4);u(5);u(6)];% 推进力 tao = [tao1 tao2 tao3]
ut=x(4);v=x(5);r=x(6);
psi=x(3);

m11=5.3122*10^6;
m22=8.2831*10^6;
m23=0;
m33=3.7454*10^9;
 
M=[5.3122*10^6 0 0;0 8.2831*10^6 0;0 0 3.7454*10^9];
C=[0 0 -m22*v-m23*r;0 0 m11*ut;m22*v+m23*r -m11*ut 0];
D=[5.0242*10^4 0 0;0 2.7229*10^5 -4.3933*10^6;0 -4.3933*10^6 4.1894*10^8];

VV=[ut;v;r];
J=[cos(psi) -sin(psi) 0;sin(psi) cos(psi) 0;0 0 1];
% 将船舶动力学与运动学方程展开
sys(1)=[1 0 0]*J*VV;
sys(2)=[0 1 0]*J*VV;
sys(3)=[0 0 1]*J*VV;
sys(4)=[1 0 0]*inv(M)*(-C*VV-D*VV+TAO+DDD);
sys(5)=[0 1 0]*inv(M)*(-C*VV-D*VV+TAO+DDD);
sys(6)=[0 0 1]*inv(M)*(-C*VV-D*VV+TAO+DDD);


function sys=mdlOutputs(t,x,u)%系统输出 同状态变量x

sys=x;


