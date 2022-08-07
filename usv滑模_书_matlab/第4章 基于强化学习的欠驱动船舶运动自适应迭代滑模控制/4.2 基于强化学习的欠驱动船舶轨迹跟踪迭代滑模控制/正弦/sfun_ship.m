function [sys,x0,str,ts] = sfun_ship(t,x,uss,flag)
switch flag,
  case 0,
  %Initialization
    [sys,x0,str,ts]=mdlInitializeSizes;
  case 1,
  %Derivatives
    sys=mdlDerivatives(t,x,uss);
  case 3,
  %Outputs
    sys=mdlOutputs(t,x,uss);
  case {2,4,9},
    sys=[];
  otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end

%u=x(1); v=x(2); r=x(3); psi=x(4); n=x(5); Delta=x(6); p=x(7); phi=x(8);
%uabs=x(9); vabs=x(10); xg=x(11); yg=x(12);

function [sys,x0,str,ts]=mdlInitializeSizes
global u0 v0 r0 psi0 n0 Delta0 p0 phi0 uabs0 vabs0 xg0 yg0;
sizes = simsizes;
sizes.NumContStates  =12;%x=[u; v; r; psi; n; Delta; p; phi; uabs; vabs; vx; vy; xg; yg]
sizes.NumDiscStates  = 0;
sizes.NumOutputs     =12;
sizes.NumInputs      = 8;%u=[delta,Qe,f_wind,a_wind,flow_Vc,flow_a,F,F_a]
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
OnShuru;
OnCbcszt;
%Initial;
x0  = [u0; v0; r0; psi0; n0; Delta0; p0; phi0; uabs0; vabs0; xg0; yg0];
str = [];
ts  = [0 0];
%end

function sys=mdlDerivatives(t,x,uss)
yy = shipdef(t,x,uss);
sys=yy;
%end


function xdot=shipdef(t,x,uss)%状态变量
windforce(t,x,uss);
waveforce(t,x,uss);
xdot(1)=fdu(t,x,uss);
xdot(2)=fdv(t,x,uss);
xdot(3)=fdr(t,x,uss);
xdot(4)=fdpsi(t,x,uss);
xdot(5)=fdn(t,x,uss);
xdot(6)=fdDelta(t,x,uss);
xdot(7)=fdp(t,x,uss);
xdot(8)=fdphi(t,x,uss);
xdot(9)=fduabs(xdot(1),x,uss);
xdot(10)=fdvabs(xdot(2),x,uss);
xdot(11)=fdxg(t,x,uss);
xdot(12)=fdyg(t,x,uss);
%end

function sys=mdlOutputs(t,x,uss)
%while(x(4)>(2*pi))
 %   x(4)=x(4)-2*pi;
%end
sys=x;
%end

function yy=OnCbcszt() %船舶初始状态-----------------
global  u00 u0 v0 r0 psi0 n0 Delta0 p0 phi0 uabs0 vabs0 xg0 yg0
u00=16*1000*1.852/3600;%27.4 11.8 27.4
u0=u00;
v0=0*1852/3600.0;
r0=0;
psi0=0/57.3;%初始航向
n0=60/60.0;%154为全速,122   38.0  开始86
Delta0=-0.0/57.3;%初始舵角
p0=0;%横倾角速度
phi0=0;%横倾角
uabs0=u0;
vabs0=v0;
xg0=0;
yg0=0;
% end

function yy=OnShuru() 
global  m Cb 
global  Lpp Loa B D_mould df da luow xb LWL d  wh hd vv 
global    hs Dp Dh Db P Cp  z e 
global  Ds wp0 tp0 Lcb ya fa tR jg
global  mx my
global  xvr xvv xrr Kt Yv Yr Nv Nr Yvv Yrr Yvrr Yvvr Nvv Nrr Nvrr Nvvr
global Jzz Izz IJxx ifaH GM zH xH  gmaR Cs S xR gma pa
%mainengine
%风的干扰模型
global Af As Zg Ck zc M Ass A Bt C AR;
%global Hu CylNum Diameter Stroke  cyl_V  Vcmp p0 oil_position Pe;;
         GM=9.42;
		da=10.5;%9.34+0.25;%尾吃水13.8;%12.5;%
		df=7.5;%4.97+0.25;%首吃水14.3;%13.8;%
		Dh=9.0;%舵高s   ;%11.411.4;;%+7.00+0.25
       % m=39893.2*1000;%回转试验时的排水量69500*1000;%65000*1000;%
       %AR=43.14;%  73.715;%舵面积 试航面积为43.14, 满载面积为73.715或81.44 81.44;%
       % Cb=0.512 ;%0.68 试验时0.626 
        
		%da=13.0;%尾吃水13.8;%12.5;%
		%df=12.0;%首吃水14.3;%13.8;%
		%Dh=11.40;%舵高s   ;%11.411.4;%
        %m=93888.2*1000;%回转试验时的排水量69500*1000;%65000*1000;%
         %%AR=81.44;%  73.715;%舵面积 试航面积为43.14, 满载面积为73.715或81.44 81.44;%
       % Cb=0.69 ;%0.68 试验时0.626        
        pa=1.205;%%%**空气密度
        Lpp=267.0;%船长
        Loa=280.0;
		B=39.8;%船宽
		D_mould=23.6;%型深Ds
		%wh=15;%37;%水深
		hd=7.5;%2*wh/abs(da+df);
        wh=hd*abs(da+df)/2;
		Db=6.466;%舵宽
		%Cb=0.65;%方形系数
       
		z=5;%桨叶数
		P=9.657;%da螺距
		luow=1026;%小luow是密度 水密度
		Dp=9.2;%螺旋桨直径
        
		e=0.668;%盘面比
		LWL=274;%设计水线长(Lpp+Loa)/2?????
		Ds=23.6;%型深
		xb=1.87;%浮心距离????
		jg=4.73;%桨轴中心距底高
        hs=da-jg;
	    d=(da+df)/2;%吃水
        m=(165.89*d*d + 4383.9*d)*1000;%排水量
        Cb=m/(Lpp*B*d*1.025*1000);
        AR=(d-7.41)/(12.5-7.41)*(81.44-43.14)+43.14;%舵叶面积
        
		Cp=Cb/0.97;%0.691;%菱形系数0.693        
	    vv=1.76915*10^(-6.0);%水的粘性阻力系数
		Ck=Lpp/2;%侧面面积到中心到船首柱距离
	    Zg=(D_mould-d)/2;%侧面面积到中心到水线的距离?????
	    Af=B*(D_mould-d)+D_mould*0.9*B;%船舶水线上的正投影面积
		As=Lpp*Zg*2.0+0.1*Lpp*D_mould;%船舶水线上的侧投影面积
	    zc=(D_mould-d)*2+Lpp*2.0+18;%水线以上的周长
	    M=2;%水线上桅杆的数量
		Ass=0.1*Lpp*D_mould;%船舶上层建筑的侧投影面积
	%船体力系数
	%fu
	d_B=d/B;L_B=Lpp/B;
	 mx=m/100*(0.398+11.97*Cb*(1+3.73*d_B)-2.89*Cb*L_B*(1+1.13*d_B)+0.175*Cb*L_B*L_B*(1+0.541*d_B)-1.107*L_B*d_B); 
     %p146 4-1-9
	 my=m*(0.882-0.54*Cb*(1-1.6*d_B)-0.156*L_B*(1-0.673*Cb)+0.826*d_B*L_B*(1-0.678*d_B)-0.638*Cb*d_B*L_B*(1-0.669*d_B)); 
     zH=0.4*d;%p173,4-1-82  船体动力YH对x轴的力矩YH*zH，zH为YH作用点的z坐标
		 %p155, 4-1-36(m/luow)^(1/3.0)
		  S=(m/luow)^(2/3.0)*(3.432+0.305*LWL/B+0.443*B/d-0.643*Cb);%p150, 4-1-24, 单桨船  浸湿面积
          Cs=S/(m/luow)^(2/3.0);%p155, 在 4-1-38 的注释中 水湿面积系数
		  %fxp
		  wp0=0.5*Cb-0.05;%p105 3-4-22   伴流系数
		  tp0=0.50*Cp-0.12;%p110, 3-4-51 不参入循环以后处理( 包括以下行） 推力减额系数
	      Lcb=100*xb/Lpp;    %p111, 3-4-63 
	      ya=B/d*(1.3*(1-Cb)-3.1*Lcb);%p111, 3-4-63 
	      Kt=0.00023*(ya*Lpp/Dp)-0.028;%以上不参入循环；p111, 3-4-63 
	      %nihe( e,D, P, z);%此函数有问题
	      %fxr%舵的一些系数的计算	      %ei=(2.1*Dh/D-1.45)*(2.1*Dh/D-1.45);%不参入跌代，ei表示舵减额？
          %g=Dh/D;%不参入跌代,没用上%fa=2*3.14159*Dh/Db/(Dh/Db+2);
   		  fa=6.13*Dh/Db/(2.25+Dh/Db);%p118, 3-5-11, 藤井公式，舵的展弦比Dh/Db，0.5~3之间 舵升力系数在a等于0时的斜率
		  gma=-22.2*(Cb*B/Lpp)*(Cb*B/Lpp)+0.02*(Cb*B/Lpp)+0.68; % p135, 3-5-114%整流系数
          gmaR=1.1633-1.98828*Cb+1.3902*Cb*Cb;% p135, 3-5-109  %整流系数
		  tR=0.7382-0.0539*Cb+0.1755*Cb*Cb; %舵阻减额系数1－tR用tR表示,%推力减额系数(1-tR), p138, 3-5-121
		  ifaH=0.6784-1.3374*Cb+1.8891*Cb*Cb; %p136, 3-5-117, 此式因在 3-5-119 前。%%计入操舵诱导船体横向力后关于舵力的修正因子。
     %p146 4-1-9
	 %x方向有量纲水动力导数
	  cm0=1.11*Cb-0.07;%%p160, 4-1-55 	 原为:: cm0=1.11*Cb-0.07;%%p160, 4-1-55 错误 2006.11.15
	  cm=cm0*(1+0.208*(da-df)/d);%p160, 4-1-56 吃水差

	 xvr=(cm*my-my);%有量纲%p160, 4-1-53, 以书上须变为有量纲时，严重出错。
	 xvv=0.5*luow*Lpp*d*(0.4*B/Lpp-0.006*Lpp/d);%p160, 4-1-57与速度无关，有量纲
     xrr=-0.5*luow*Lpp*Lpp*Lpp*d*0.0010*Lpp/d;%p160, 4-1-57 2006.11.02修改与速度无关，有量纲
     %xrr=0.5*luow*Lpp*Lpp*Lpp*d*0.0003*Lpp/d;%p160, 4-1-57,old
	 %以下是水动力无量纲导数
      lg_mass=1/2.0*luow*Lpp*Lpp*d;%质量的量纲
      lmd=2.0*d/Lpp; 
      tao=(da-df)/d;%吃水差无量纲
	  CbBL=Cb*B/Lpp; %p162 4-1-60中的系数
      CbdB=(1-Cb)*d_B;%p162 4-1-60中的系数
 
      Yv=-(pi/2.0*lmd+1.4*CbBL)*(1+(25.0*CbBL-2.25)*tao);	  %p149, 4-1-20 与速度有关不带量纲
      Yr=((m+mx)/lg_mass-1.5*CbBL)*(1+(571*CbdB*CbdB-81*d*(1-Cb)/B+2.1)*tao);   %p149, 4-1-20与速度有关不带量纲
	  Yvv=0.5*luow*Lpp*d*((-2.5*(1-Cb)*B/(d-0.5))*(1-(35.7*CbBL-2.5)*tao));%p162 4-1-60与速度无关，有量纲
	  Yrr=0.5*luow*Lpp*Lpp*Lpp*d*((0.343*Cb*d_B-0.07)*(1+(45*CbBL-8.1)*tao));	%p162 4-1-60与速度无关，有量纲
      Yvrr=(-5.95*CbdB)*(1+(40*CbdB-2)*tao);
      %p162 4-1-60, 与速度有关不带量纲
      Yvvr=(1.5*Cb*d_B-0.65)*(1+(110*CbdB-9.7)*tao);
      %p162 4-1-60, 与速度有关不带量纲
      Nv=-lmd*(1.0-tao); %p149 4-1-20速度有关不带量纲
      Nr=-(0.54*lmd-lmd*lmd)*(1+(34*CbBL-3.4)*tao);%p149 4-1-20速度有关不带量纲
      Nvv=0.5*luow*Lpp*Lpp*d*(0.96*CbdB-0.066)*(1+(58*CbdB-5)*tao); %p162 4-1-60 与速度无关，有量纲
	  Nrr=0.5*luow*Lpp*Lpp*Lpp*Lpp*d*(0.5*CbBL-0.09)*(1-(30*CbBL-2.6)*tao);%与速度无关，有量纲
      Nvrr=(0.5*CbBL-0.05)*(1+(48*(CbBL^2)-16*CbBL+1.3)*100*tao);%速度有关不带量纲
      %p162 4-1-60, 此式有量纲化时尚未除以速度V
      Nvvr=(-57.5*(CbBL^2)+18.4*CbBL-1.6)*(1+(3*CbBL-1)*tao);%速度有关不带量纲
      %p162 4-1-60, 此式有量纲化时尚未除以速度V
	  %ifaH=0.6784-1.3374*Cb+1.8891*Cb*Cb; 
	  xH=-(0.4+0.1*Cb)*Lpp;%p136, 3-5-118
      xR=-0.5*Lpp;
      cc=0.3085+0.227*B/d-0.0043*Lpp/100;%p171, 4-1-70
		  %IJxx=m/9.81*(cc*B)*(cc*B);%p171, 4-1-69
		  IJxx=m*(cc*B)*(cc*B);%p171, 4-1-69,原为W/g*kx*kx,W为排水量
		  Jzz=1/100.0*(33-76.85*Cb*(1-0.784*Cb)+3.43*L_B*(1-0.63*Cb))*Lpp*Lpp;%p146
          Izz=(1.0+(Cb^4.5))*m*(Lpp*Lpp+power(B,2.4))/24.0;
		  %Izz=m*Lpp*Lpp/16.0;      
      if (hd<6)%浅水域
	        H=1/hd;
			 mx=(1+0.2/hd+3.3/hd/hd*hd)*mx;
			 %p180, 4-2-17
			 my=(1+0.2/hd+3.6/hd/hd*hd)*my;
			 %p180, 4-2-17
			 Jzz=((1+0.5/hd+4.6/hd/hd*hd))*Jzz;
			 %p180, 4-2-17	,  乐美龙，船舶操纵性预报与港航操纵运动仿真，p73
	
			 xvr=(1-0.9879/hd+21.9123/(hd*hd)-73.8161/(hd*hd*hd)+71.1409/(hd*hd*hd*hd))*xvr;
     		 %p181,  4-2-22  
			 Yv=(1+0.32/hd-1.74/hd/hd+4.2/hd/hd/hd)*Yv;% 乐美龙，船舶操纵性预报与港航操纵运动仿真，p73
			 Nv=(1+0.16/hd-1.32/hd/hd+3.4/hd/hd/hd)*Nv;
			 Yr=(1+0.16/hd-1.36/hd/hd+3.6/hd/hd/hd)*Yr;
			 Nr=(1+0.29/hd-1.30/hd/hd+2.6/hd/hd/hd)*Nr;
			 Yvv=(1.0+4.0*power(1/hd,3.5))*Yvv;%赵月林，浅水中船舶操纵运动的模拟计算，
			 Yrr=(1.0+3.0*power(1/hd,2.5))*Yrr;
			 %%Yvr=(1.0+3.0*pow(1/hd,2.5))*Yvr;
			 Nrr=(1.0+5.0*power(1/hd,2.5))*Nrr;
			 Nvvr=(1.0+6.0*power(1/hd,2.5))*Nvvr;
			 Nvrr=(1.0+6.0*power(1/hd,2.5))*Nvrr;
             
	         ifaH=(1+0.3621*H+1.1724*H*H)*ifaH;%p188, 4-2-59
             xH  =(1+0.3328*H-3.2134*H*H+2.5916*H*H*H)*xH;
             gmaR=(1+0.0161/hd+4.4222/hd/hd-4.9825/hd/hd/hd)*gmaR;%p188, 4-2-58
      end     
      %水动力导数结束
        
          %杨盐生，船舶运动数学模型， page 300，风压系数表，p299公式7-1-25
		  %wind model
		 %A[0]=2.152-5.00*As/Lpp/Lpp+0.243*2*Af/B/B-0.164*L_B;%已校对
	
  		   WA=             [ 2.152, -5.00,  0.243, -0.164,      0,     0,      0;
			                 1.714, -3.33,  0.145, -0.121,      0,     0,      0;
						     1.818, -3.97,  0.211, -0.143,      0,     0,   0.033;
						     1.965, -4.81,  0.243, -0.154,      0,     0,   0.041;
						     2.323, -5.99,  0.247, -0.190,      0,     0,   0.042;
						     1.726, -6.54,  0.189, -0.173,  0.343,     0,   0.048;
						     0.913, -4.68,      0, -0.104,  0.482,     0,   0.052;
						     0.457, -2.88,      0, -0.068,  0.346,     0,   0.043;
						     0.341, -0.91,      0, -0.031,      0,     0,   0.032;
						     0.355,     0,      0,      0,  -0.247,    0,   0.018;
						     0.601,     0,      0,      0,  -0.372,    0,  -0.020;
						     0.651,  1.29,      0,      0,  -0.582,    0,  -0.031;
						     0.564,  2.54,      0,      0,  -0.748,    0,  -0.024;
						    -0.142,  3.58,      0,  0.047,  -0.70,     0,  -0.028;
						    -0.677,  3.64,      0,  0.069,  -0.529,    0,  -0.032;
						    -0.723,  3.14,      0,  0.064,  -0.475,    0,  -0.032;
						    -2.148,  2.56,      0,  0.081,       0,  1.27, -0.027;
						    -2.707,  3.97, -0.175,  0.126,       0,  1.81,      0;
						    -2.529,  3.76, -0.174,  0.128,       0,  1.55,      0;]; % A[19];
 
  for(i=1:1:19)%部分数据与杨盐生的不一样，详见文本
  
	  A(i)=WA(i,1)+WA(i,2)*2*As/Lpp/Lpp+WA(i,3)*2*Af/B/B+WA(i,4)*L_B +WA(i,5)*zc/Lpp+WA(i,6)*Ck/Lpp+WA(i,7)*M;
      %zc为水线以上部分侧面投影面积的周长,CK为水线以上部分侧面投影面积的形心距首距离
	  %M为侧投影面积中桅杆或中线面支柱的数目;
  end
  A(20)=0;%专为180度时迭代运算，详见windforce函数求CWx
  WB=              [     0,      0,      0,     0,       0,      0,      0;
	                 0.096,   0.22,      0,     0,       0,      0,      0;
					 0.176,   0.71,      0,     0,       0,      0,      0;
					 0.225,   1.38,      0,  0.023,      0,   -0.29,     0;
					 0.329,   1.82,      0,  0.043,      0,   -0.55,     0;
					 1.164,   1.26,  0.121,      0, -0.242,   -0.69,     0;
					 1.163,   0.96,  0.101,      0, -0.127,   -0.88,     0;
					 0.916,   0.53,  0.069,      0,      0,   -0.65,     0;
					 0.844,   0.55,  0.082,      0,      0,   -0.54,     0;
					 0.889,      0,  0.138,      0,      0,   -0.66,     0;
					 0.799,      0,  0.155,      0,      0,   -0.55,     0;
					 0.797,      0,  0.151,      0,      0,   -0.55,     0;
					1.1,      0,  0.184,      0, -0.212,   -0.66,  0.34;
					 1.1,      0,  0.191,      0, -0.280,   -0.69,  0.44;
					 0.784,      0,  0.166,      0, -0.209,   -0.53,  0.38;
					 0.536,      0,  0.176, -0.029, -0.163,       0,  0.27;
					 0.251,      0,  0.106, -0.022,       0,      0,      0;
					 0.125,      0,  0.046, -0.012,       0,      0,      0;
					     0,      0,      0,      0,       0,      0,      0;];
     %  Bt[19];
	  for(i=1:1:19)
	     Bt(i)=WB(i,1)+WB(i,2)*2.0*As/Lpp/Lpp+WB(i,3)*2.0*Af/(B*B)+WB(i,4)*L_B+WB(i,5)*zc/Lpp+WB(i,6)*Ck/Lpp+WB(i,7)*Ass/As;
      end
      Bt(20)=0;%专为180度时迭代运算，详见windforce函数求CWy
	   WC             =[      0,      0,       0,       0,       0,      0;
		                 0.0596,  0.061,       0,       0,       0, -0.074;
					     0.1106,  0.204,       0,       0,       0, -0.170;
					     0.2258,  0.245,       0,       0,       0, -0.380;
					     0.2017,  0.457,       0,   0.0067,      0, -0.472;
					     0.1759,  0.573,       0,   0.0118,      0, -0.523;
					     0.1925,  0.480,       0,   0.0115,      0, -0.546;
					     0.2133,  0.315,       0,   0.0081,      0, -0.526;
					     0.1827,  0.254,       0,   0.0053,      0, -0.443;
					     0.2627,      0,       0,        0,      0, -0.508;
					     0.2102,      0, -0.0195,        0, 0.0335, -0.492;
					     0.1567,      0, -0.0258,        0, 0.0497, -0.457;
					     0.0801,      0, -0.0311,        0, 0.0740, -0.396;
					     0.0189,      0, -0.0488,   0.0101, 0.0728, -0.420;
					     0.0256,      0, -0.0422,   0.0100, 0.0889, -0.463;
					     0.0552,      0, -0.0381,   0.0109, 0.0689, -0.476;
					     0.0881,      0, -0.0306,   0.0091, 0.0366, -0.415;
					     0.0851,      0, -0.0122,   0.0025,      0, -0.220;
				              0,      0,       0,       0,       0,      0;];
%	   C[19];
	  for(i=1:1:19)
	     C(i)=WC(i,1)+WC(i,2)*2*As/Lpp/Lpp+WC(i,3)*2*Af/B/B+WC(i,4)*L_B+WC(i,5)*zc/Lpp+WC(i,6)*Ck/Lpp;
      end
      C(20)=0;%专为180度时迭代运算，详见windforce函数求CWn
%end

function yy=fdu(t,x,uss)
v=x(2); r=x(3);
global m mx my Wx cwave_Wx;
XH=fxh(t,x,uss);%裸船
XR=fxr(t,x,uss);%舵
XP=fxp(t,x,uss);%桨
Xwave=cwave_Wx;
Xwind=Wx;
yy=((m+my)*v*r+XR+XP+XH+Xwave+Xwind)/(m+mx);%p144 4-1-1再加风浪
%end

function yy=fxh(t,x,uss) %xh
u=x(1); v=x(2); r=x(3);
global  xvr xvv xrr
V=sqrt(u*u+v*v);
L_XH=0;
if( V~=0)
    xuu=fxuu(u,v);
    L_XH=xuu*u*u+xvv*v*v+xvr*v*r+xrr*r*r;
end
yy=L_XH;
% end


  
function yy=fxuu(u,v) %XUU
global  Ct S luow hd wh
V=sqrt(u*u+v*v);
if (V<16.7*1.852/3.6)%Fr<0.192时ct可认为不变，化为节
     Ct=0.00185;%+0.0005;//,重载污底系数+0.0005,略偏高,23.5节,79.5 rpm;;//
else 	 
    vv=0.00000118831;
    Re=V*274/vv;
    Cf=0.4631/power(log10(Re),2.6); %p151 4-1-29
    Cr=(V/((30-16.5)*1.852/3.6)-16.5/(30-16.5))*0.0009+0.000450;
    Ct=Cf+Cr;
end
if (hd<6)%浅水效应
    %p180, 4-2-21
    Fh=V/sqrt(9.81*wh);
    Ajian=1+0.9755*Fh-1.5926*Fh*Fh;
    Bjian=-121.8754*Fh+585.974*Fh*Fh-928.4468*Fh*Fh*Fh+490.581*Fh*Fh*Fh*Fh;
    Ct=(Ajian+Bjian/hd)*Ct;%p180, 4-2-20
end
yy=-0.5*luow*S*Ct;%X'(u')=-S/(Lpp*d)*Ct*u'*u', 有量纲系数为0.5*Lpp*d*luow	 p159 4-1-51
% end

function yy=fxr(t,x,uss)%舵X力 舵正压力已经考虑V=0的情况
u=x(1); v=x(2); r=x(3); n=x(5); Delta=x(6);
global tR
V=sqrt(u*u+v*v);
if(V==0)
    L_XR=0;
else
    FN=ffn(u,v,r,n,Delta);%舵正压力
    L_XR=tR*FN*sin(Delta);%p145, 4-1-8
    L_XR=-abs(L_XR);%无论如何，舵产生的都是阻力
end
yy=L_XR;
% end

function yy=ffn(u,v,r,n,Delta)%舵正压力
global Cb Lpp luow hd Dp Dh P AR wp0 wp fa gmaR
yx=0;
V=sqrt(u*u+v*v);
if(V~=0)
    beta=atan(-v/u);%
    betap=beta+0.5*r*Lpp/V;%p145，4-1-7
    betaR=beta+r*Lpp/V;%p145，4-1-8 或p135 3-5-110下面
    wp=wp0*exp(-4.0*betap*betap);%p145  4-1-7
    if (hd<6)
        wp=cos(1.8*Cb/hd)*wp;%p187, 4-2-57
    end
    up=(1.0-wp)*u;%感觉有问题，应该是wp0?
    s=1.0-up/n/P;%p126,3-5-59
    eta=Dp/Dh;%p126,3-5-54
    wR=1.00*wp;
    k=0.6*(1-wp)/(1-wR);%p145 4-1-8, k=0.6(1-wp)/(1-wR), wR=wR0*wp/wp0
    Gs=eta*k*(2.0-(2.0-k)*s)*s/(1.0-s)/(1.0-s);%p127 3-5-64之前
    if(Delta<0)   %p127, 3-5-64
        K=1.065;%系数
    else
        K=0.935;
    end
    uR=up*(1+K*Gs)^0.5; %舵处的平均有效流速，公式 p127 3-5-64。
    s0=1-(1-wp0)*u/n/P;%p126 3-5-59滑失, 用于直航s0=1-up/n/P
      %s0=1-up0*u/n/P, up=(1-wp0)u, up0为舵角为零时值。
    delt0=-s0/57.3;%s0为滑失,零正压力舵角，有所调整  p134 3-5-105
 %   delt0=0;
    vRp=uR*delt0;%p133 3-5-102近似式
    if (hd<6)
        wp=cos(1.8*Cb/hd)*wp;%p187, 4-2-57
    end
    DeltaR=gmaR*betaR*V/uR+delt0;%p134 3-5-107 
    vR=vRp-gmaR*(v-Lpp*r);%vR=vRp-gmaR(v+lR*r),lR=-Lpp, p133 3-5-99
    alphaR=Delta-DeltaR;  %p145 4-1-8
 %   alphaR=Delta-atan(vR/uR);  %p138 3-5-122, 但是vr难求
    UR2=uR*uR+vR*vR;
    yx=-1.0/2.0*luow*AR*fa*UR2*sin(alphaR);%p138, 3-5-122
end
yy=yx;
%end

function yy=fxp(t,x,uss)%桨X力
u=x(1); v=x(2); r=x(3); n=x(5);
global  Cb Lpp luow hd wp0 hs Dp  Kt tp0
V=sqrt(u*u+v*v);
if(V==0)
    betap=0;
    betaR=0;
else
    beta=atan(-v/u);
	betap=beta+0.5*r*Lpp/V;%p145, 4-1-7 betap=atan(-v/u)+0.5*r/(u*u+v*v)^0.5*Lpp;  
    betaR=beta+r*Lpp/V;%p145，4-1-8 或p135 3-5-110下面 betaR%漂角%p111,
end
wp=wp0*exp(-4.0*betap*betap);%p108，斜伴流系数,145,4-1-7
if(hd<6)
 	wp=cos(1.8*Cb/hd)*wp;%p187, 4-2-57
end
Jp=(1.0-wp)*u/(n*Dp);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 关于转速！！！！！！！
	 %hs=9.43-4.73;%jg桨距底高,da尾吃水???????
     %kt=-0.3137*Jp*Jp - 0.1703*Jp + 0.482;% ok 2006.10.14 ,ok1 14:25
     %kt=-0.28*Jp*Jp-0.123*Jp+0.482;%ok 2006.12.20 ,ok1 13:12
kT=-0.27*Jp*Jp-0.123*Jp+0.482;%ok 2006.12.20 ,ok1 13:12图谱拟合 老袁师兄
if(hs/Dp<=0.6)
  kT=kT*(0.6+hs/Dp*hs/Dp/0.36*0.4);% kt=kt*(0.475+0.875*hs/D);%2006.11.02修改
end
f=Kt*betaR; %p111,3-4-63,横向和旋转对推力的影响
tpx=1.0-tp0+f;
if(hd<=6)
  tpx=1.0/(1-0.1/hd+0.7295/(hd*hd))*tpx;%p187, 4-2-56
		 %原为tp=1.0/(1-0.2/hd+0.7295/(hd*hd))*tp;//p187, 4-2-56
end	%此修正公式有问题！
yy=tpx*luow*n*n*(Dp^4.0)*kT;%p144, 4-1-4 , 桨推力
%end

function yy=fdv(t,x,uss)
u=x(1); r=x(3);
global m mx my Wy cwave_Wy YH YR ;
YH=fyh(t,x,uss);%裸船
YR=fyr(t,x,uss);%舵
%%%%YP=fyp(t,x,uss);%桨YP=0
Ywave=cwave_Wy;
Ywind=Wy;
yy=1.0*(YH+YR+Ywave+Ywind-(m+mx)*u*r)/(m+my);%风浪、桨都为零
%end 

function yy=fyh(t,x,uss)%裸船y
u=x(1); v=x(2); r=x(3);
global Yv Yr Yvv Yrr Yvrr Yvvr luow Lpp d
V=sqrt(u*u+v*v);
L_YH=0;
if(V~=0)
    %先将四个系数化为有量纲
    Yv1=0.5*luow*Lpp*d*V*Yv;	  
    Yr1=0.5*luow*Lpp*Lpp*d*V*Yr;   
    Yvrr1=0.5*luow*Lpp*Lpp*Lpp*d/V*Yvrr;
    Yvvr1=0.5*luow*Lpp*Lpp*d/V*Yvvr;
	L_YH=Yv1*v+Yr1*r+Yvv*abs(v)*v+Yrr*abs(r)*r+Yvvr1*v*v*r+Yvrr1*v*r*r;	%有量纲 p186,4-2-44   
end 
yy=L_YH;
%end

function yy=fyr(t,x,uss)%舵y
global ifaH Lpp wp0 Cb hd Dp
u=x(1); v=x(2); r=x(3); n=x(5); Delta=x(6);
V=sqrt(u*u+v*v);
L_YR=0;
if(V~=0)
    betap=atan(-v/u)+0.5*r*Lpp/V;%p145, 4-1-7
    wp=wp0*exp(-4.0*betap*betap);%p108，斜伴流系数
    if(hd<6)
  	    wp=cos(1.8*Cb/hd)*wp;%p187, 4-2-57
    end
    J=u*(1-wp)/n/Dp;%p108,3-4-43
    if(J<=0.3)
        L_ifaH=ifaH*J/0.3;% p137, 3-5-119
    else
        L_ifaH=ifaH;
    end
    L_YR=ffn(u,v,r,n,Delta)*(1+L_ifaH)*cos(Delta);%舵力,p145, 4-1-8
    if(hd<6)
       L_YR=(1-0.5/hd/hd)*L_YR;%%%%%老袁论文
    end
end
yy=L_YR;
%end

function yy=fdr(t,x,uss)
global Jzz Izz Wn cwave_Wn;
NH=fnh(t,x,uss);%裸船考虑了横倾及中心距
NR=fnr(t,x,uss);%舵
%%%%%%%NP=fnp(t,x,uss);%桨 NP=0
Nwave=cwave_Wn;
Nwind=Wn;
yy=1.0*(NH+NR+Nwave+Nwind)/(Izz+Jzz);%风浪、桨都为零  
%end 
   
function yy=fnh(t,x,uss)%裸船
global luow Nv Nr Nvv Nrr Nvrr Nvvr Lpp d xb
L_NH=0;
u=x(1); v=x(2); r=x(3); phi=x(8);
V=sqrt(u*u+v*v);%总速度
if(V~=0)
    %量纲化
    Nv1=0.5*luow*Lpp*Lpp*d*V*Nv;
    Nr1=0.5*luow*Lpp*Lpp*Lpp*d*V*Nr;
    Nvrr1=0.5*luow*Lpp*Lpp*Lpp*Lpp*d/V*Nvrr;
    Nvvr1=0.5*luow*Lpp*Lpp*Lpp*d/V*Nvvr;
    L_NH0=Nv1*v+Nr1*r+Nvv*abs(v)*v+Nrr*abs(r)*r+Nvvr1*v*v*r+Nvrr1*v*r*r;%p144 4-1-3
    Nphi=1/2.0*luow*Lpp*d*V*V*(-0.008);%p172, 4-1-74
    Nvphi=1/2.0*luow*Lpp*d*V*(1.72*Nv);%p172, 4-1-74
    Nrphi=1/2.0*luow*Lpp*d*V*V*(-2.6*Nr);%p172, 4-1-74
    L_NH1=Nphi*phi+Nvphi*v*abs(phi)+Nrphi*r*abs(phi);%p171 4-1-73
    YH=fyh(t,x,uss);
    xC=xb;
    L_NH=L_NH0+L_NH1-YH*xC;%考虑横倾 p171 4-1-72
end
yy=L_NH;
%end

function yy=fnr(t,x,uss)%舵N
global ifaH Lpp wp0 Cb hd Dp xR xH
u=x(1); v=x(2); r=x(3); n=x(5); Delta=x(6);
V=sqrt(u*u+v*v);
L_NR=0;
if(V~=0)
    betap=atan(-v/u)+0.5*r*Lpp/V;%p145, 4-1-7
    wp=wp0*exp(-4.0*betap*betap);%p108，斜伴流系数
    if(hd<6)
  	    wp=cos(1.8*Cb/hd)*wp;%p187, 4-2-57
    end
    J=u*(1-wp)/n/Dp;%p108,3-4-43
    if(J<=0.3)
        L_ifaH=ifaH*J/0.3;% p137, 3-5-119
    else
        L_ifaH=ifaH;
    end
    L_NR=(xR+L_ifaH*xH)*ffn(u,v,r,n,Delta)*cos(Delta);%舵力,p145, 4-1-8
    if(hd<6)%%%%%%%%%%%参考论文 老袁
 	  L_NR =(1-0.75/hd/hd)*L_NR;
    end 
end
yy=L_NR;
%end

function yy=fdpsi(t,x,uss)%艏摇
r=x(3); phi=x(8);
yy=r*cos(phi);%%p171 4-1-68考虑横摇
%end

function yy=fdn(t,x,uss) %转加速度
u=x(1); v=x(2); r=x(3);  n=x(5);
moment=uss(2);
global  Cb Lpp luow hd Dp wp0 wp kq Qe
V=sqrt(u*u+v*v);
betap=0;
if(V~=0)
    betap=atan(-v/u)+0.5*r*Lpp/V;%p145, 4-1-7
end
wp=wp0*exp(-4.0*betap*betap);%p108，斜伴流系数
if(hd<6)
    wp=cos(1.8*Cb/hd)*wp;%p187, 4-2-57
end
J=u*(1-wp)/n/Dp;%p112,3-4-66
kq=(-0.48*J*J - 0.2*J + 0.8)/10.0;% 2006.12.20  21:20 ok 0.195  老袁师兄
yy=uss(2);
% Qp=luow*n*n*(Dp^5.0)*kq;%p114
% Qe=moment;
% Qf=0.03*Qe;
% Sn=1.0*(Qe-Qp-Qf)/(2.0*pi*(950507.2));%转速加速度，p114,3-4-70  %p144, 4-1-1，运动方程 Ipp+Jpp
% yy=Sn;%0;%强制调速
% %end


% function yy=fdn(t,x,uss) %转加速度
% u=x(1); v=x(2); r=x(3);  n=x(5);
% yy=uss(2);
% %end

function yy=fdDelta(t,x,uss)%舵角p138 3.5.8
Delta=x(6); Delta_ord=uss(1)*pi/180;
Delta_max=35*pi/180;
if (abs(Delta_ord)>Delta_max)
      Delta_ord=sign(Delta_ord)*Delta_max;		
end   
Dj=1/2.5*(Delta_ord-Delta);% p138 3-5-124 lyb
if(abs(Dj)<=0.00001)		
    Dj=Delta_ord-Delta;
end
if(abs(Dj)>3*pi/180)
    Dj=sign(Dj)*3*pi/180;		
end
yy= Dj;
%end

function yy=fdp(t,x,uss)%横倾角加速度
u=x(1); v=x(2); r=x(3); n=x(5); Delta=x(6); p=x(7); phi=x(8);
global   m Cb Lpp B D_mould hd Dp IJxx ifaH GM zH wp0
% 横倾角加速度
V=sqrt(u*u+v*v);
GZ=GM*sin(phi);%p173,4-1-81
miuphi0=0.057*Lpp*B*B*B*B/(2.0*m*9.81*(B*B+D_mould*D_mould*D_mould*D_mould))*0.55;%p172, 4-1-78,%%%%phim取0.55 W=m*g
miuphi=miuphi0*(1+3.3*V/sqrt(9.81*Lpp));%p172, 4-1-79
Np=miuphi*sqrt(IJxx*m*9.81*GM);%p172, 4-1-77,仅使用于|fai|<8-10度      
N=2.0*Np*p;%p172, 4-1-75;   
L_YH=fyh(t,x,uss);   
L_LH=-N-m*9.81*GZ-L_YH*zH;%p172 4-1-75,zH 全局变量 GM*sin(phi)

betap=0;
if(V~=0)
    betap=atan(-v/u)+0.5*r*Lpp/V;%p145, 4-1-7
end
wp=wp0*exp(-4.0*betap*betap);%p108，斜伴流系数
if(hd<6)
    wp=cos(1.8*Cb/hd)*wp;%p187, 4-2-57
end
J=u*(1-wp)/n/Dp;%p108,3-4-43
if(J<=0.3)
    L_ifaH=ifaH*J/0.3;% p137, 3-5-119
else
    L_ifaH=ifaH;
end   
L_LR=-(1+L_ifaH)*zH*ffn(u,v,r,n,Delta)*cos(Delta); %p173 4-1-84 
dp=(L_LH+L_LR)/IJxx;%p170 4-1-67
yy=dp;
%end

function yy=fdphi(t,x,uss)%横倾角速度
p=x(7);
yy=p;
%end

function yy=fduabs(du,x,uss)%附体坐标系绝对速度的加速度
r=x(3); psi=x(4);
flow_Vc=uss(5)*1852/3600;%流速
flow_psic=uss(6)*pi/180;%3.14159;%流出方向向
duabs=du+flow_Vc*r*sin(flow_psic-psi);% p350 7-3-4
yy=duabs;
%end

function yy=fdvabs(dv,x,uss)%附体坐标系绝对速度的加速度
r=x(3); psi=x(4);
flow_Vc=uss(5)*1852/3600;%流速
flow_psic=uss(6)*pi/180;%3.14159;%流出方向向
dvabs=dv-flow_Vc*r*cos(flow_psic-psi);% p350 7-3-4
yy=dvabs;
%end

function yy=fdxg(t,x,uss)%x方向速度
 psi=x(4); phi=x(8); abs_u=x(9); abs_v=x(10);
yy=abs_u*cos(psi)-abs_v*cos(phi)*sin(psi);
%end

function yy=fdyg(t,x,uss)%y方向速度
psi=x(4); phi=x(8); abs_u=x(9); abs_v=x(10);
yy=abs_u*sin(psi)+abs_v*cos(phi)*cos(psi);
% end




function yy=windforce(t,x,uss)%风力公式颠覆！参考张显库 《控制系统建模与数字仿真》
u=x(1); v=x(2); psi=x(4); Wut=uss(3); Wpsit=uss(4)*pi/180;
%风的干扰模型
global Loa Af As Wx Wy Wn pa A Bt C;
while psi>=2*pi
    psi=psi-2*pi;
end
while psi<=-2*pi
    psi=psi+2*pi;
end
Wur=-u-Wut*cos(Wpsit-psi);%Wut;%真风风速，单位m/s  Wpsit;%真风风向，单位弧度0-2pi p297 7-1-17
Wvr=-v-Wut*sin(Wpsit-psi);%
%Wur=u+Wut*cos(Wpsit-psi);%Wut;%真风风速，单位m/s  Wpsit;%真风风向，单位弧度0-2pi p297 7-1-17
%Wvr=-v+Wut*sin(Wpsit-psi);%
War=atan(Wvr/Wur);%风舷角；右舷为正
if Wur>=0
    War=War-pi*sign(Wvr);% p297 7-1-18~19
end
if Wur==0
    if Wvr>0
        War=-pi/2;
    else
        War=pi/2;
    end
end
War=War*180/pi;   %4.14159?????????%风向角

num=fix(abs(War)/10)+1;%商取整
CWx=A(num)+rem(abs(War),10)/10*(A(num+1)-A(num));%介于两点之间的，近似直线求点 线性插值
CWy=Bt(num)+rem(abs(War),10)/10*(Bt(num+1)-Bt(num));%介于两点之间的，近似直线求点
CWn=C(num)+rem(abs(War),10)/10*(C(num+1)-C(num));%介于两点之间的，近似直线求点

CWx=-CWx;   %
if War>0    %x方向的力正负不会变
    CWy=-CWy;
    CWn=-CWn;
end
arverge_Wx=1/2.0*pa*Af*(Wur*Wur+Wvr*Wvr)*CWx;%平均值
arverge_Wy=1/2.0*pa*As*(Wur*Wur+Wvr*Wvr)*CWy;
arverge_Wn=1/2.0*pa*As*Loa*(Wur*Wur+Wvr*Wvr)*CWn;    
kk=rand;
rand_Wx=0.20*2*(kk-0.5)*pa*Loa*Loa*(Wur*Wur+Wvr*Wvr)*abs(CWx);%平均值
rand_Wy=0.20*2*(kk-0.5)*pa*Loa*Loa*(Wur*Wur+Wvr*Wvr)*abs(CWy);
rand_Wn=0.20*2*(kk-0.5)*pa*Loa*Loa*Loa*(Wur*Wur+Wvr*Wvr)*abs(CWn);
Wx=arverge_Wx+rand_Wx;
Wy=arverge_Wy+rand_Wy;
Wn=arverge_Wn+rand_Wn;
yy=0;
%end

function yy=waveforce(t,x,uss)%袁师兄论文
 global Lpp  B d cwave_Wx cwave_Wy cwave_Wn;
 u=x(1); v=x(2); Wut=uss(3); Wpsi=uss(4)*pi/180; psi=x(4);
 V=sqrt(u*u+v*v);
	% Tw,     Ww, g,         k,  Hw,  X,     We,      Lw,a,b,c;
	%%波浪周期,频率,重力加速度,波数,波高,遭遇角,遭遇频率,波长,计算系数
    luow=1026;
    % pi=3.14159;
    % wave_angle;%波浪传递方向,为方向的方向
	%Tw=-0.0014*power(Wut,3.0)+0.042*power(Wut,2.0)+5.6; %浪周期
    Tw=-3.858E-04*Wut*Wut + 0.2819*Wut;%自己回归 
    if(Tw<=0)
		Tw=0.0001;
    end
	Ww=2.0*pi/Tw; %频率
	g=9.8;
	k=Ww*Ww/g; %波数
	%Hw=0.015*power(Wut,2.0)+1.5; %波高
    Hw=-0.019569534*Wut+0.013382311*Wut*Wut-4.4966E-05*Wut*Wut*Wut;
	if(Hw<=0)
        Hw=0.002;
    end
    wave_angle=pi+Wpsi;%浪向 去向与正北的夹角
	X=psi-wave_angle; %遭遇角,?????????,风向与浪向一致时,计算较大相差pi
    We=Ww-k*V*cos(X); %遭遇频率
	%与原文公式推导结果不一致
	Lw=2*pi/k;% 波长
    a=luow*g*(1-exp(-k/d))/(k*k);%计算系数
	b=k*Lpp/2*cos(X);
	c=k*B/2*sin(X);
	s=(k*Hw/2)*sin(We*t);
    epxl=(Hw/2.0)*cos(We*t);%相当于波高
	if(abs(b)<0.000001)	
		cwave_Wx=0;
        cwave_Wy=-2.0*a*Lpp*sin(c)*s;
		cwave_Wn=0;
	elseif (abs(c)<0.00001)	
		cwave_Wx=2.0*a*B*sin(b)*s;
        cwave_Wy=0;
		cwave_Wn=0;	
    else	
		cwave_Wx=2.0*a*B*sin(b)*sin(c)*s/c;
        cwave_Wy=-2.0*a*Lpp*sin(b)*sin(c)*s/b;
		cwave_Wn=a*k*(B*B*sin(b)*(c*cos(c)-sin(c))/(c*c)-Lpp*Lpp*sin(c)*(b*cos(b)-sin(b))/(b*b))* epxl;	
	end
	%以上无二次干扰力矩
	%以下计算二阶波浪力及力矩
	 %CXwd;%x向波浪力系数
	 %CYwd;%y向波浪力系数
	 %CNwd;%首摇向波浪力矩
	 %Xwd;%x向波浪力
	 %Ywd;%y向波浪力
	 %Nwd;%首摇向波浪力矩
	lmd_L=Lw/Lpp;
    CXwd=0.05-0.2*lmd_L+0.75*lmd_L*lmd_L-0.51*lmd_L*lmd_L*lmd_L;
	CYwd=0.46+6.83*lmd_L-15.65*lmd_L*lmd_L+8.44*lmd_L*lmd_L*lmd_L;
	CNwd=-0.11+0.68*lmd_L-0.79*lmd_L*lmd_L+0.21*lmd_L*lmd_L*lmd_L;
	aa=Hw/2;%波幅
	luow_L_aa_2_2=0.5*luow*Lpp*aa*aa;
	Xwd=luow_L_aa_2_2*CXwd;
	Ywd=luow_L_aa_2_2*CYwd;
	Nwd=luow_L_aa_2_2*CNwd;
	cwave_Wx=cwave_Wx+Xwd;
    cwave_Wy=cwave_Wy+Ywd;
	cwave_Wn=cwave_Wn+Nwd;    
%end
