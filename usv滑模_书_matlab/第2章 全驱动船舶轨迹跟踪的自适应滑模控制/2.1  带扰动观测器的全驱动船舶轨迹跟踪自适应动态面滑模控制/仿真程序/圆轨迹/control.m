% ################################################################
% ##源自: 沈智鹏 著《船舶运动自适应滑模控制》 2019年科学出版社#######
% ##下载地址www.shenbert.cn/book/shipmotionASMC.html##############
% ###############################################################
function [sys,x0,str,ts] = control(t,x,u,flag)
switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 3,
    sys=mdlOutputs(t,x,u);
case {2,4,9},
    sys=[];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 24;
sizes.NumInputs      = 18;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [];

function sys=mdlOutputs(t,x,u)

xd=500*sin(0.02*t+pi/4);%u(1)
yd=500*(1-cos(0.02*t+pi/4));%u(2)
psid=0.01*t;%u(3)
Vd=[u(4);u(5);u(6)];
FAI1=[u(7);u(8);u(9)];
T=0.3;
dVd=1/T*(FAI1-Vd);
dxd=10*cos(0.02*t+pi/4);
dyd=10*sin(0.02*t+pi/4);
dpsid=0.01;
dETAD=[dxd;dyd;dpsid];
x=u(10);
y=u(11);
psi=u(12);
ut=u(13);
v=u(14);
r=u(15);
VV=[ut;v;r];

DATAG=[u(16);u(17);u(18)];
%RAOGU=[u(19);u(20);u(21)];
m11=5.3122*10^6;
m22=8.2831*10^6;
m23=0;
m33=3.7454*10^9;
M=[5.3122*10^6 0 0;0 8.2831*10^6 0;0 0 3.7454*10^9];
C=[0 0 -m22*v-m23*r;0 0 m11*ut;m22*v+m23*r -m11*ut 0];
D=[5.0242*10^4 0 0;0 2.7229*10^5 -4.3933*10^6;0 -4.3933*10^6 4.1894*10^8];

ETA=[x;y;psi];
ETAD=[xd;yd;psid];

S1=ETA-ETAD;
s11=[1 0 0]*S1;
s12=[0 1 0]*S1;
s13=[0 0 1]*S1;
S2=VV-Vd;
s21=[1 0 0]*S2;
s22=[0 1 0]*S2;
s23=[0 0 1]*S2;
epsilon1=0.0005;
epsilon2=0.0005;
epsilon3=0.00001;
XI=diag([tanh(s21/epsilon1),tanh(s22/epsilon2),tanh(s23/epsilon3)]);
% XI2=diag([tanh(s21/epsilon1)-0.75,tanh(s22/epsilon2)-0.75,tanh(s23/epsilon3)-0.75]);

% s1=[1 0 0]*S2;
% s2=[0 1 0]*S2;
% s3=[0 0 1]*S2;
% SIGN=diag([sign(s1),sign(s2),sign(s3)]);
JT=[cos(psi) sin(psi) 0;-sin(psi) cos(psi) 0;0 0 1];

K2=diag([10^6,10^6,10^9]);
% K2=diag([10,10,10]);
Lambda=diag([5*10^(-10),5*10^(-10),1*10^(-12)]);%1
D0=[0.1;0.1;0.1];
CONG=diag([5*10^6,8*10^6,1*10^9]);

% Lambda=diag([1*10^(-8),1*10^(-8),1*10^(-11)]);%0
% D0=[0.1;0.1;0.1];
% CONG=diag([1*10^6,1*10^6,1*10^9]);l

dDATAG=CONG*(XI*S2-Lambda*(DATAG-D0));
TAO=C*VV+D*VV+M*dVd-K2*S2-XI*DATAG-JT*S1;%为什么下式加上扰动后tao1会抖震，但不加不会抵消扰动吧？
%TAO=C*VV+D*VV+M*dVd-K2*S2-XI*DATAG-RAOGU-JT*S1;
% TAO=C*VV+D*VV+M*dVd-JT*S1-K2*S2-XI*DATAG;
% dDATAG=CONG*(SIGN*S2-Lambda*(DATAG-D0));
% TAO=C*VV+D*VV+M*dVd-K2*S2-SIGN*DATAG;

sys(1)=[1 0 0]*TAO;%控制力，力矩
sys(2)=[0 1 0]*TAO;
sys(3)=[0 0 1]*TAO;
sys(4)=[1 0 0]*dDATAG;
sys(5)=[0 1 0]*dDATAG;
sys(6)=[0 0 1]*dDATAG;
sys(7)=[1 0 0]*XI*DATAG;
sys(8)=[0 1 0]*XI*DATAG;
sys(9)=[0 0 1]*XI*DATAG;
% sys(7)=[1 0 0]*SIGN*DATAG;
% sys(8)=[0 1 0]*SIGN*DATAG;
% sys(9)=[0 0 1]*SIGN*DATAG;
% sys(10)=sign(s11);
% sys(11)=sign(s12);
% sys(12)=sign(s13);
% sys(10)=tanh(s21/epsilon1);
% sys(11)=tanh(s22/epsilon2);
% sys(12)=tanh(s23/epsilon3);
sys(10)=sign(s21);
sys(11)=sign(s22);
sys(12)=sign(s23);
sys(13)=[1 0 0]*C*VV;
sys(14)=[0 1 0]*C*VV;
sys(15)=[0 0 1]*C*VV;
sys(16)=[1 0 0]*D*VV;
sys(17)=[0 1 0]*D*VV;
sys(18)=[0 0 1]*D*VV;
sys(19)=[1 0 0]*M*dVd;
sys(20)=[0 1 0]*M*dVd;
sys(21)=[0 0 1]*M*dVd;
sys(22)=[1 0 0]*K2*S2;
sys(23)=[0 1 0]*K2*S2;
sys(24)=[0 0 1]*K2*S2;
