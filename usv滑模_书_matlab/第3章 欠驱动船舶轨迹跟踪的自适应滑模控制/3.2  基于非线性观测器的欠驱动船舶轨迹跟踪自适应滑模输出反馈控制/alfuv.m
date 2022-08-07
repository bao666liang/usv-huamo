function [sys,x0,str,ts] = alfuv(t,x,u,flag)

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

sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 7;
sizes.NumInputs      = 8;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;   % at least one sample time is needed

sys = simsizes(sizes);


str = [];


ts  = [0 0];
x0=[];%u v r x y psi_d

function sys=mdlDerivatives(t,x,u)

sys=[];
function sys=mdlUpdate(t,x,u)

sys = [];

function sys=mdlOutputs(t,x,u)

k=1.5;

C=5;
xd=u(1);%matlab函数给出
dxd=300*cos(0.03*t)*0.03;
ddxd=-300*sin(0.03*t)*0.03*0.03;

yd=u(2);
dyd=-300*sin(0.03*t)*0.03;
ddyd=-300*cos(0.03*t)*0.03*0.03;

xx=u(3);%plant模型输出实际位置
y=u(4);
fai=u(5);
ut=u(6);
v=u(7);
r=u(8);
xe=xx-xd;%位置跟踪误差
ye=y-yd;
A=[cos(fai) sin(fai);-sin(fai) cos(fai)];
W=-((xe)^2+(ye)^2+C)^(1/2);
B=[k*xe/W;k*ye/W];
bb1=[1 0]*B;
bb2=[0 1]*B;
D=[dxd+bb1;dyd+bb2];
ALF=A*D;%虚拟控制律alpha
alfu=[1 0]*ALF;
alfv=[0 1]*ALF;

XEYE=B;
dxe=[1 0]*XEYE;
dye=[0 1]*XEYE;
F=[ddxd+k*(1/W-((1/W^3)*xe^2))*dxe-k*xe*ye*dye/(W^3);ddyd+k*(1/W-((1/W^3)*ye^2))*dye-k*xe*ye*dxe/(W^3)];
DALF=[r*alfv;-r*alfu]+A*F;%虚拟控制律的微分 式3.1.12  没有用低通滤波器代替
dalfu=[1 0]*DALF;
dalfv=[0 1]*DALF;
ue=ut-alfu;%纵向速度误差 注意这里是输入的观测速度
ve=v-alfv;%横向速度误差
ff=(ddyd+k*(1/W-((1/W^3)*ye^2))*dye-k*xe*ye*dxe/W^3)*cos(fai)-(ddxd+k*(1/W-((1/W^3)*xe^2))*dxe-k/W^3*xe*ye*dye)*sin(fai);
sys(1)=alfu;
sys(2)=alfv;
sys(3)=dalfu;
sys(4)=dalfv;
sys(5)=ue;
sys(6)=ve;
sys(7)=ff;%这是式3.1.28 即前一节的公式，因为观测器模型用的3.2.7而不是3.2.13 
%虽然输出X但是simulink里V=Q_1*X，相当于3.2.13 就不用加detla了，因为detla是根据3.2.13模型推出来的
function sys=mdlGetTimeOfNextVarHit(t,x,u)
sampleTime = 1;    %  Example, set the next hit to be one second later.
sys = t + sampleTime;


function sys=mdlTerminate(t,x,u)

sys = [];

% end mdlTerminate
