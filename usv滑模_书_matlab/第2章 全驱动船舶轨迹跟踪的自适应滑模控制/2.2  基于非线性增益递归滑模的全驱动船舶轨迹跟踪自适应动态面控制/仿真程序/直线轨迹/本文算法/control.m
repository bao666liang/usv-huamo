% ################################################################
% ##源自: 沈智鹏 著《船舶运动自适应滑模控制》 2019年科学出版社#######
% ##下载地址www.shenbert.cn/book/shipmotionASMC.html##############
% ###############################################################
function [sys,x0,str,ts]=chap4_3ctrl(t,x,u,flag)
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
sizes.NumContStates  = 183;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 15;
sizes.NumInputs      = 18;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0  = 0*ones(1,183);
str = [];
ts  = [0 0];
global b1 b2 b3 m1 m2 m3 %高斯基函数的宽度b  隐含层每个神经元(61个)的中心点的值c  三个神经网络
m1=0.6*[-30 -29 -28 -27 -26 -25 -24 -23 -22 -21 -20 -19 -18 -17 -16 -15 -14 -13 -12 -11 -10 -9 -8 -7 -6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30];
m2=0.6*[-30 -29 -28 -27 -26 -25 -24 -23 -22 -21 -20 -19 -18 -17 -16 -15 -14 -13 -12 -11 -10 -9 -8 -7 -6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30];
m3=0.01*[-30 -29 -28 -27 -26 -25 -24 -23 -22 -21 -20 -19 -18 -17 -16 -15 -14 -13 -12 -11 -10 -9 -8 -7 -6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30];

b1=3;
b2=3;
b3=1;
% global b L
% L=0.6*[-30 -29 -28 -27 -26 -25 -24 -23 -22 -21 -20 -19 -18 -17 -16 -15 -14 -13 -12 -11 -10 -9 -8 -7 -6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30;
%     -30 -29 -28 -27 -26 -25 -24 -23 -22 -21 -20 -19 -18 -17 -16 -15 -14 -13 -12 -11 -10 -9 -8 -7 -6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30;
%     -30 -29 -28 -27 -26 -25 -24 -23 -22 -21 -20 -19 -18 -17 -16 -15 -14 -13 -12 -11 -10 -9 -8 -7 -6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30];
% b=3;

function sys=mdlDerivatives(t,x,u)
global b1 b2 b3 m1 m2 m3 
% global b L
xd=8*t;%u(1)
yd=8*t;%u(2)
psid=0.01*t;%u(3)
ETAD=[xd;yd;psid];
% xd=500*sin(0.02*t+pi/4);%u(1)
% yd=500*cos(0.02*t+pi/4);%u(2)
% psid=0.01*t;%u(3)
% ETAD=[xd;yd;psid];

xx=u(4);
y=u(5);
psi=u(6);
ETA=[xx;y;psi];
JT=[cos(psi) sin(psi) 0;-sin(psi) cos(psi) 0;0 0 1];
E1=JT*(ETA-ETAD);
ut=u(7);
v=u(8);
r=u(9);
VV=[ut;v;r];
Vd=[u(10);u(11);u(12)];
C1=diag([1,1,1]);

E2=VV-Vd;
S2=C1*E1+E2;
fzlh2=zeros(3,1);
dfzlh2=zeros(3,1);
L2=zeros(3,1);
a2=1;
for i=1:1:3
     fzlh2(i)=a2*(abs(S2(i))^(0.5))*sign(S2(i));   
if abs(S2(i))==0;
     dfzlh2(i)=1;
else
     dfzlh2(i)=0.5*a2*((abs(S2(i)))^(-0.5));
end
     L2(i)=(dfzlh2(i)*S2(i)+fzlh2(i))/2;    
end


h1=zeros(61,1);
for j=1:1:61
    h1(j)=exp(-norm(ut-m1(:,j))^2/(2*b1^2));
end
h2=zeros(61,1);
for j=1:1:61
    h2(j)=exp(-norm(v-m2(:,j))^2/(2*b2^2));
end
h3=zeros(61,1);
for j=1:1:61
    h3(j)=exp(-norm(r-m3(:,j))^2/(2*b3^2));
end
HH=[h1;h2;h3];% 61*3矩阵
% xi=[ut;v;r];
% h=zeros(61,1);
% for j=1:1:61
%     h(j)=exp(-norm(xi-L(:,j))^2/(2*b^2));
% end
% HH=[h;h;h];

% w权值作为状态变量是因为其自适应律为微分更新其状态，要在s函数中写上w状态变量，然后在
% 输出函数中使用w这个状态向量，而界估计虽然也有自适应律，并写在了输出函数中，
% 但其状态更新在simulink中用模块 1/s 代替了，因此不用在s函数中加上界的三个状态量
gama1=1*10^5;bb1=1*10^(-6); % HH(i)是竖着从列开始数的每一个元素 L2是3*1的列向量对应三个神经网络
for i=1:1:61
    W1=x(i);%循环后为行向量 1*61 这里只是一个自定义的中间变量W1
    % 因为for循环，按书的公式如h3为61*1,输入是r，L2(3)是数，相乘后再减去列向量W3为61*1才为估计权值的微分
    sys(i)=gama1*(-HH(i)*L2(1)-bb1*W1);%第一个神经网络的权值自适应律 这里是一个元素一个的计算的 估计w
end
gama2=2*10^5;bb2=5*10^(-7);
for i=62:1:122
    W2=x(i);
    sys(i)=gama2*(-HH(i)*L2(2)-bb2*W2);
end
gama3=1*10^1;bb3=1*10^(-2);
for i=123:1:183
    W3=x(i);
    sys(i)=gama3*(-HH(i)*L2(3)-bb3*W3);
end
function sys=mdlOutputs(t,x,u)
% global b L
global b1 b2 b3 m1 m2 m3 
xd=8*t;%u(1)
yd=8*t;%u(2)
psid=0.01*t;%u(3)
ETAD=[xd;yd;psid];
dxd=8;
dyd=8;
dpsid=0.01;
dETAD=[dxd;dyd;dpsid];
% xd=500*sin(0.02*t+pi/4);%u(1)
% yd=500*cos(0.02*t+pi/4);%u(2)
% psid=0.01*t;%u(3)
% ETAD=[xd;yd;psid];
% dxd=10*cos(0.02*t+pi/4);
% dyd=-10*sin(0.02*t+pi/4);
% dpsid=0.01;
% dETAD=[dxd;dyd;dpsid];

xx=u(4);
y=u(5);
psi=u(6);
ETA=[xx;y;psi];
ut=u(7);
v=u(8);
r=u(9);
VV=[ut;v;r];
Vd=[u(10);u(11);u(12)];
FAI1=[u(13);u(14);u(15)];
T=0.3;
dVd=1/T*(FAI1-Vd);
JT=[cos(psi) sin(psi) 0;-sin(psi) cos(psi) 0;0 0 1];
E1=JT*(ETA-ETAD);
C1=diag([1,1,1]);

E2=VV-Vd;
S2=C1*E1+E2;
RT=[0 r 0;-r 0 0;0 0 0];
dE1=RT*E1+VV-JT*dETAD;
fzlh2=zeros(3,1);
dfzlh2=zeros(3,1);
L2=zeros(3,1);
N2=zeros(3,1);
a2=1;
for i=1:1:3
     fzlh2(i)=a2*(abs(S2(i))^(0.5))*sign(S2(i));
if abs(S2(i))==0;
    dfzlh2(i)=1;    
else
    dfzlh2(i)=0.5*a2*((abs(S2(i)))^(-0.5));
end
     L2(i)=(dfzlh2(i)*S2(i)+fzlh2(i))/2;  
if abs(S2(i))==0;
     N2(i)=1;
else
     N2(i)=L2(i)/S2(i);
end    
end

W1=[x(1) x(2) x(3) x(4) x(5) x(6) x(7) x(8) x(9) x(10) x(11) x(12) x(13) x(14) x(15) x(16) x(17) x(18) x(19) x(20) x(21) x(22) x(23) x(24) x(25) x(26) x(27) x(28) x(29) x(30) x(31) x(32) x(33) x(34) x(35) x(36) x(37) x(38) x(39) x(40) x(41) x(42) x(43) x(44) x(45) x(46) x(47) x(48) x(49) x(50) x(51) x(52) x(53) x(54) x(55) x(56) x(57) x(58) x(59) x(60) x(61)];
W2=[x(62) x(63) x(64) x(65) x(66) x(67) x(68) x(69) x(70) x(71) x(72) x(73) x(74) x(75) x(76) x(77) x(78) x(79) x(80) x(81) x(82) x(83) x(84) x(85) x(86) x(87) x(88) x(89) x(90) x(91) x(92) x(93) x(94) x(95) x(96) x(97) x(98) x(99) x(100) x(101) x(102) x(103) x(104) x(105) x(106) x(107) x(108) x(109) x(110) x(111) x(112) x(113) x(114) x(115) x(116) x(117) x(118) x(119) x(120) x(121) x(122)];
W3=[x(123) x(124) x(125) x(126) x(127) x(128) x(129) x(130) x(131) x(132) x(133) x(134) x(135) x(136) x(137) x(138) x(139) x(140) x(141) x(142) x(143) x(144) x(145) x(146) x(147) x(148) x(149) x(150) x(151) x(152) x(153) x(154) x(155) x(156) x(157) x(158) x(159) x(160) x(161) x(162) x(163) x(164) x(165) x(166) x(167) x(168) x(169) x(170) x(171) x(172) x(173) x(174) x(175) x(176) x(177) x(178) x(179) x(180) x(181) x(182) x(183)];

h1=zeros(61,1);
for j=1:1:61
    h1(j)=exp(-norm(ut-m1(:,j))^2/(2*b1^2));
end
h2=zeros(61,1);
for j=1:1:61
    h2(j)=exp(-norm(v-m2(:,j))^2/(2*b2^2));
end
h3=zeros(61,1);
for j=1:1:61
    h3(j)=exp(-norm(r-m3(:,j))^2/(2*b3^2));
end
HH=[h1;h2;h3];
% xi=[ut;v;r];
% h=zeros(61,1);
% for j=1:1:61
%     h(j)=exp(-norm(xi-L(:,j))^2/(2*b^2));
% end
% HH=[h;h;h];
fzlh1=zeros(3,1);
dfzlh1=zeros(3,1);
L1=zeros(3,1);

a1=1;
for i=1:1:3
    fzlh1(i)=a1*(abs(E1(i))^(0.5))*sign(E1(i));
if abs(E1(i))==0;
    dfzlh1(i)=1;
else
    dfzlh1(i)=0.5*a1*(abs(E1(i)))^(-0.5);
end
    L1(i)=(dfzlh1(i)*E1(i)+fzlh1(i))/2;
end

N=diag([1/N2(1),1/N2(2),1/N2(3)]);
epsilon1=1;
epsilon2=1;
epsilon3=0.01;
XI=diag([tanh(L2(1)/epsilon1),tanh(L2(2)/epsilon2),tanh(L2(3)/epsilon3)]);

DGJ=[u(16);u(17);u(18)];%界向量估计值，仿真中扰动是直接写入plant_s函数中的，没有另写扰动s函数模块
% Lambda=diag([1*10^(-7),1*10^(-7),2*10^(-8)]);
% D0=[0.1;0.1;0.1];
% CONG=diag([5*10^4,5*10^4,1*10^5]);
% Lambda=diag([8*10^(-8),1*10^(-7),2*10^(-8)]);
% D0=[0.1;0.1;0.1];
% CONG=diag([1*10^6,1*10^6,1*10^6]);
Lambda=diag([1*10^(-7),1*10^(-7),1*10^(-9)]);
D0=[0.1;0.1;0.1];
CONG=diag([5*10^4,5*10^4,1*10^5]);
dDGJ=CONG*(XI*L2-Lambda*(DGJ-D0));


f1=W1*h1;%W1位1*61的行向量，h1为61*1的列向量
f2=W2*h2;
f3=W3*h3;
% f1=W1*h;
% f2=W2*h;
% f3=W3*h;
FF=[f1;f2;f3];
C2=diag([1*10^5,1*10^5,2*10^8]);
% C2=diag([1*10^4,1*10^4,5*10^7]);
K2=diag([100,100,100]);
% K2=diag([1*10^6,2*10^6,1*10^9]);
m11=5.3122*10^6;
m22=8.2831*10^6;
m23=0;
m33=3.7454*10^9;
M=[5.3122*10^6 0 0;0 8.2831*10^6 0;0 0 3.7454*10^9];
C=[0 0 -m22*v-m23*r;0 0 m11*ut;m22*v+m23*r -m11*ut 0];
D=[5.0242*10^4 0 0;0 2.7229*10^5 -4.3933*10^6;0 -4.3933*10^6 4.1894*10^8];
du=5.0242*10^4;
dv=2.7229*10^5;
dr=4.1894*10^8;
% F=[0.2*du*ut^2+0.1*du*ut^3;0.2*dv*v^2+0.1*dv*v^3;0.2*dr*r^2+0.1*dr*r^3];
% DDD=[1*10^5*(sin(0.2*t)+cos(0.5*t));1*10^5*(sin(0.1*t)+cos(0.4*t));1*10^6*(sin(0.5*t)+cos(0.3*t))];

TAO=C*VV+D*VV+M*dVd-M*C1*dE1+FF-K2*L2-C2*S2-N*L1-XI*DGJ;%状态反馈控制律
sys(1)=[1 0 0]*TAO;%推力 但是再经过低通滤波输入给plant？
sys(2)=[0 1 0]*TAO;
sys(3)=[0 0 1]*TAO;
sys(4)=[1 0 0]*FF;%不确定项估计值
sys(5)=[0 1 0]*FF;
sys(6)=[0 0 1]*FF;
sys(7)=[1 0 0]*S2;%递归滑模面s2
sys(8)=[0 1 0]*S2;
sys(9)=[0 0 1]*S2;
sys(10)=[1 0 0]*dDGJ;%界向量微分
sys(11)=[0 1 0]*dDGJ;
sys(12)=[0 0 1]*dDGJ;
sys(13)=[1 0 0]*L2;%L2
sys(14)=[0 1 0]*L2;
sys(15)=[0 0 1]*L2;

