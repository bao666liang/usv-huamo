function dy=MMG3(~,y)
u=y(1);v=y(2);r=y(3);xg=y(4);yg=y(5);course=y(6);xB=0;% xB 是漂心
% Cr=(0.0067*u^4-0.166*u^3+1.553*u^2-6.3699*u+10.02)*10^(-3);
dy(8)=r;
 
%假设
% u=1;v=0.01;r=0.0001;
xC=0;% xC 是浮心
%r为转首角速度
u0=13.5*1852/3600;%=0.6945 船舶进速
p=1.025;
M=6859.07*p;
Lw=119.7;
B=20.5;
dm=4.4;
Cb=0.653;
Cp=0.692;
panbi=0.71;%盘面比，Lw船长、B船宽、dm平均吃水、Cb方形系数、Cp棱形系数
Vpai=6859.07;%排水体积
Dp=4.5;
P=3.99; %螺旋桨螺距
L=119.7;
n=126/60;%L为实船水线长，Dp为螺旋桨直径 n为转速
zhanbi=1.68;%展舷比
Ar=17.57;
Hr=5.49;%Hr舵高 Ar螺旋桨高度
V=(u^2+v^2)^0.5;
mper=M/(0.5*p*L^2*dm);%mxper=0.0133;myper=0.2022;Jzzper=0.046;Izzper=0.0113;应用的是船舶切片法
%   =0.2248
Izzper=(1+Cb^4.5)*p*M/24*(L^2+B^2)/(0.5*p*L^4*dm);  % Izz 惯性矩 Jzz 附加惯性矩
%     =0.0116
% mxper=mper/100*(0.398+11.97*Cb*(1+3.73*dm/B)-2.89*Cb*L/B*(1+1.113*dm/B)+0.175*Cb*(L/B)^2*(1+0.541*dm/B)-1.107*L/B*dm/B);
%    =0.0133
mxper=0.0112;
 
myper=1.129*mper*(0.882-0.54*Cb*(1-1.6*dm/B)-0.156*(1-0.673*Cb)*L/B+0.826*dm/B*L/B*(1-0.678*dm/B)-0.638*Cb*dm/B*L/B*(1-0.669*dm/B));
%    =0.2283
Jzzper=0.01*(33-76.85*Cb*(1-0.784*Cb)+3.43*L/B*(1-0.63*Cb))*mper/2.6;%0.0177
% Jzzper=mper*(Jzz/L)^2;%     =0.0094
 
%计算Xuu
%计算Ct
%计算水湿面积
k=2.77;
 
S=k*(Vpai*Lw)^0.5;
vv=1.18831*10^(-6);%水的运动粘性系数
Rn=V*L/vv;%=7*10^8
Cf1=0.066/(log10(Rn)-2.03)^2;% Rn雷诺数
Cf2=0.455/(log10(Rn))^2.58;
Cf3=0.075/(log10(Rn)-2.03)^2;%=0.0016
Cf4=0.455/(log10(Rn))^2.58-1700/Rn;
Car=0.000362;
Cr=(0.0067*V^4-0.166*V^3+1.553*V^2-6.3699*V+10.02)*10^(-3)*0.85/0.95;%=6*10^(-4)
%    Cr=(0.0067*V^4-0.166*u^3+1.553*u^2-6.3699*u+10.02)*10^(-3)
Ct4=Cf3+Cr+Car;%=0.0032
Ct=Ct4*1.001;
Xuu=-S/(L*dm)*Ct;%=-0.0089
Xvv=0.4*B/L-0.006*L/dm;%=-0.0285
Xrr=0.0003*L/dm;%=0.0079
Xvr=(1.11*Cb-0.07)*myper;%=0.1387
%以上为井上模型，car为粗糙度补粘系数。为水动力导数,Xuu,Xvv,Xrr,Xvr可由船型参数来计算。
%p为水密度,s为船体湿面积,Cf为摩擦阻力系数由桑海公式计算,Cr为剩余阻力系数。
 
 %    Yv=-pi*dm/L*(1.0+0.4*Cb*B/dm);        =-0.3407
Yv=-0.3569;
%    Yr=-pi*dm/L*(-0.5+2.2*B/L+0.08*B/dm);%=-0.0142
Yr=0.0997;
%    Nv=-pi*dm/L*(0.5+0.24*dm/L);%=-0.1028
Nv=-0.127;
%    Nr=-pi*dm/L*(0.25-0.56*B/L+0.039*B/dm);%=-0.0517
Nr=-0.0525;
%以上为井上模型线性水动力导数计算公式
%下面为采用井上图谱求出的非线性水动力导数
Yvv=0.048265-6.293*(1-Cb)*dm/B;       % p161 杨 =-0.7238
Yrr=0.0045-0.445*(1-Cb)*dm/B;  %=-0.0501
Yvr=-0.3791+1.28*(1-Cb)*dm/B;%=-0.2221
Nrr=-0.0805+8.6092*(Cb*B/L)^2-36.9816*(Cb*B/L)^3;%=-0.0242
Nvvr=-6.0856+137.4735*(Cb*B/L)-1029.514*(Cb*B/L)^2+2480.6082*(Cb*B/L)^3;%=-0.1177
Nvrr=-0.0635+0.04414*(Cb*dm/B);%=-0.0519


XH=Xuu*(u/u0)^2+Xvv*(v/u0)^2+Xvr*(v/u0)*(r*L/u0)+Xrr*(r*L/u0)^2;% 0--0.0123

YH=Yv*v/V+Yr*r*L/V+Yvv*v/V*abs(v/V)+Yvr*abs(v/V)*r*L/V+Yrr*r*L/V*abs(r*L/V);
NH=Nv*v/V+Nr*r*L/V+Nvvr*(v/V)^2*r*L/V+Nvrr*v/V*(r*L/V)^2+Nrr*r*L/V*abs(r*L/V);

 
 
 %利用模型计算螺旋桨纵向推力
%利用汉克歇尔公式（单桨标准型商船）估算参数tp
%利用泰勒公式（单螺旋桨船）估算参数wp0

tp0=0.5*Cp-0.12;
tp0per=tp0;
 
lR=-0.95; 
pjiao=atan(-v/u);
pjiaoR=pjiao-lR*r*L/V;
lcb=xC/L*100;
rA=(B/dm)*(1.3*(1-Cb)-3.1*lcb);
kt=0.00023*(rA*L/Dp)-0.028;%=-0.0212
f=kt*pjiaoR;
lp=-0.5*L;
pjiaoP=pjiao+0.5*L/u0*r;%p104 
wp0=0.5*Cb-0.05 ; % =0.2905 伴流系数wp0
wp=wp0*exp(-4*(pjiaoP)^2);%      
tp=tp0per*exp(-4*pjiaoP^2);%tp为推力减额系数
J=(1-wp)*u/(n*Dp);%= 0.3818      
Kt=0.0821*J^3-0.2308*J^2-0.2768*J+0.3499;%=0.2918   
Kq=0.0085*J^3-0.027*J^2-0.0252*J+0.0416;%=0.0361    KQ转矩系数
XP=(1-tp)*p*n^2*Dp^4*Kt/(0.5*p*L*dm*V^2);%=0.0376--0.016  螺旋桨产生的流体动力和力矩
%计算 Xr=(1-tR)*Fn*sin(rudder)   舵力计算
%计算 Fn=-0.5*p*Ar*fa*Ur^2*sin(aR); Fn为舵正压力 Ur为流入舵的有效流速
yxbi=Dp/Hr;% yxi p149 杨 论文
up0=u*(1-wp0); %有效螺旋桨进速， wR0为船舶直航时舵处船体伴流系数 一般由实验确定
s0=1-up0/(n*P);%有效螺旋桨的滑失比
s=1-(1-wp)*u/(n*P);%改正后的螺旋桨滑失比
CP=1/(1+0.6*yxbi*(2-1.4*s)*s/(1-s)^2)^0.5;%由桨引起的整流系数
if pjiaoR<=0.5/0.45
    CS=0.45*pjiaoR;
else
    CS=0.5;
end
zx=CP*CS;%汤室将整流系数分解为由船体作用引起的整流系数Cs和由桨引起的整流系数Cp
%Cp=up0/ur0=1/(1+0.6*yxbi*(2-1.4*s)*s/(1-s)^2)^0.5
rudder0=-2*s0*pi/180;
%        rudder=-2*s0*pi/180;
rudder=35*pi/180;
rudder=y(7);
rudderE=35*pi/180;
% rudderE=-2*s0*pi/180;
if abs(rudderE-rudder)/2.5>3*pi/180
    rudder=3*pi/180;
else
    rudder=(rudderE-rudder)/2.5;
end
 
 
aR=rudder-rudder0-zx*pjiaoR;% 0.34--0.06  舵处来流的有效冲角
%计算Ur 舵处来流的有效速度
if  rudder-rudder0>=0
    C=1.065 ;% 向右转时
else
    C=0.935;% 向左转时
end
wR0=0.25;% 舵处的伴流系数
wR=wR0*exp(-4*pjiaoR);
k=0.6*(1-wp)/(1-wR);
Gs=yxbi*k*(2-(2-k)*s)*s/(1-s)^2;
Ur=V*(1-wR)*(1+C*Gs)^0.5;
fa=6.13*zhanbi/(2.25+zhanbi);
Fn=-0.5*p*Ar*fa*Ur^2*sin(aR)/(0.5*p*L*dm*V^2);
tR=0.29;


aH0=0.6784-1.3374*Cb+1.8891*Cb^2 ;% 计入操舵诱导船体横向力后关于舵力的修正因子
if J<=0.3
    aH=aH0*J/0.3;
else
    aH=aH0;
end
xH=-(0.4+0.1*Cb);% 操舵诱导船体横向力作用中心到船舶重心的无量纲距离



XR=(1-tR)*Fn*sin(rudder);   %  XR= -0.0037; 作用于舵的纵向力矩
YR=(1+aH)*Fn*cos(rudder);  % YR作用于舵的横向力矩 NR作用于船舶艏摇方向的力矩
NR=(-0.5+aH*xH)*Fn*cos(rudder);
%XH为作用于船体的纵向力矩 YH为作用于船体的横向力矩 NH为作用于船体的艏摇方向的力矩

xG=0;
% 未加风,浪,流的扰动且是三自由度 u v r
y11=((mper+myper)*v/u0*r*L/u0+XH+XP+XR)/(mper+mxper) ;% u
y22=(-(mper+mxper)*u/V*r*L/V+YH+YR)/(mper+myper);% v
y33=(NH+NR-xG*YH)/(Izzper+Jzzper);% r
y44=(u*cos(course)-v*sin(course))/L;% x
y55=(u*sin(course)+v*cos(course))/L;% y
dy=[y11;y22;y33;y44/V;y55/V;y(3);(rudderE-rudder)/2.5;r];%r定常回转角速度
% dy=[YR;NR];