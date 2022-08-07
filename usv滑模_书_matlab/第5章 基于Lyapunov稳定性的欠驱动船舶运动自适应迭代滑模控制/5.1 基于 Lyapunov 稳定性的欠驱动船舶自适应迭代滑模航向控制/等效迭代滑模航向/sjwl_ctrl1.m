%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%源自: 沈智鹏 著《船舶运动自适应滑模控制》 2019年科学出版社
%%下载地址www.shenbert.cn/book/shipmotionASMC.html
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [sys,x0,str,ts] = sjwl_ctrl1(t,x,u,flag)
switch flag,
  case 0,
    [sys,x0,str,ts]=mdlInitializeSizes; 
  case 1,
    sys=mdlDerivatives(t,x,u);
  case 3
   sys=mdlOutputs(t,x,u); 
  case {2,4,9},
    sys=[]; %do nothing
  otherwise
    DAStudio.error('Simulink:blocks:unhandledFlag', num2str(flag));
end
% u=x(1);v=x(2);r=x(3);psi=x(4);n=x(5);delta=x(6);p=x(7);phi=x(8);uabs=x(9);vabs=x(10);x=x(11);y=x(12);
function [sys,x0,str,ts]=mdlInitializeSizes
global cij bj ;
sizes = simsizes;
sizes.NumContStates  = 81;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;%delta
sizes.NumInputs      = 17;%u=[u;v;r;Phi;Psi;ddPsid;Delta;n;k0;k1;k2;k3;depsi;dsgm2;sgm1;sgm2;Bd]
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;% at least one sample time is needed
sys = simsizes(sizes);
x0=0*ones(1,81);
str = [];
ts  = [0 0];
a1=[-20 -19.5 -19 -18.5 -18 -17.5 -17 -16.5 -16 -15.5 -15 -14.5 -14 -13.5 -13 -12.5 -12 -11.5 -11 -10.5 -10......
    -9.5 -9 -8.5 -8 -7.5 -7 -6.5 -6 -5.5 -5 -4.5 -4 -3.5 -3 -2.5 -2 -1.5 -1 -0.5 0......
    0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 5.5 6 6.5 7 7.5 8 8.5 9 9.5 10.....
    10.5 11 11.5 12 12.5 13 13.5 14 14.5 15 15.5 16 16.5 17 17.5 18 18.5 19 19.5 20];
% a1=0.1*[110 111 112 113 114 115 116 117 118 119 ...
%     120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 ...
%     151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 ...
%     181 182 183 184 185 186 187 188 189 190];
a2=0.025*[-20 -19.5 -19 -18.5 -18 -17.5 -17 -16.5 -16 -15.5 -15 -14.5 -14 -13.5 -13 -12.5 -12 -11.5 -11 -10.5 -10 ...
    -9.5 -9 -8.5 -8 -7.5 -7 -6.5 -6 -5.5 -5 -4.5 -4 -3.5 -3 -2.5 -2 -1.5 -1 -0.5 0 ...
    0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 5.5 6 6.5 7 7.5 8 8.5 9 9.5 10 ...
    10.5 11 11.5 12 12.5 13 13.5 14 14.5 15 15.5 16 16.5 17 17.5 18 18.5 19 19.5 20];
a3=0.0004*[-20 -19.5 -19 -18.5 -18 -17.5 -17 -16.5 -16 -15.5 -15 -14.5 -14 -13.5 -13 -12.5 -12 -11.5 -11 -10.5 -10 ...
    -9.5 -9 -8.5 -8 -7.5 -7 -6.5 -6 -5.5 -5 -4.5 -4 -3.5 -3 -2.5 -2 -1.5 -1 -0.5 0 ...
    0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 5.5 6 6.5 7 7.5 8 8.5 9 9.5 10 ...
    10.5 11 11.5 12 12.5 13 13.5 14 14.5 15 15.5 16 16.5 17 17.5 18 18.5 19 19.5 20];
a4=0.0006*[-20 -19.5 -19 -18.5 -18 -17.5 -17 -16.5 -16 -15.5 -15 -14.5 -14 -13.5 -13 -12.5 -12 -11.5 -11 -10.5 -10 ...
    -9.5 -9 -8.5 -8 -7.5 -7 -6.5 -6 -5.5 -5 -4.5 -4 -3.5 -3 -2.5 -2 -1.5 -1 -0.5 0 ...
    0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 5.5 6 6.5 7 7.5 8 8.5 9 9.5 10 ...
    10.5 11 11.5 12 12.5 13 13.5 14 14.5 15 15.5 16 16.5 17 17.5 18 18.5 19 19.5 20];


cij=[a1;a2;a3;a4];%;81个神经网络隐含层节点数
% cij=[a2;a3;a4];
bj=2;


% function Initial

simStateCompliance = 'UnknownSimState';
%  
%  end mdlInitializeSizes
 
%
%=============================================================================
% mdlDerivatives
% Return the derivatives for the continuous states.
%=============================================================================
%
function sys=mdlDerivatives(t,x,u)
global cij bj v ddPsid Phi r  rou ePsi ut Delta n sgm2 dsgm2 
ut=u(1);v=u(2);r=u(3);Phi=u(4);ePsi=u(5);ddPsid=u(6);Delta=u(7);n=u(8);rou=0.00001;dsgm2=u(9);sgm2=u(16);D=0.1;%D=100
% z1=Psi-Psid;
xi=[ut;v;r;Phi];%4个神经网络的输入
% xi=[v;r;Phi];
h=zeros(81,1);
for j=1:1:81
    h(j)=exp(-norm(xi-cij(:,j))^2/(2*bj^2));%高斯基函数输出
end
gama=100000;

% W=[x(1) x(2) x(3) x(4) x(5) x(6) x(7) x(8) x(9) x(10) x(11) x(12) x(13) x(14) x(15) x(16) x(17) x(18) x(19) x(20) x(21) x(22) x(23) x(24) x(25) x(26) x(27) x(28) x(29) x(30) x(31) x(32) x(33) x(34) x(35) x(36) x(37) x(38) x(39) x(40) x(41)]';
%为什么不对
for i=1:1:81
% sys(i)=-(1/gama)*D*dsgm2*h(i);%得到W自适应率
sys(i)=(1/gama)*D*sgm2*h(i);%得到W自适应率
% sys(i)=-(1/gama)*(dsgm2*h(i)-rou*x(i));

end

 function sys=mdlOutputs(t,x,u)%状态变量     
global cij bj ePsi ddPsid r  Phi v ut Delta n dsgm2 sgm1 depsi k0 k1 k2 k3 sgm2
ut=u(1);v=u(2);r=u(3);Phi=u(4);ePsi=u(5);ddPsid=u(6);Delta=u(7);n=u(8);dsgm2=u(9);sgm1=u(10);depsi=u(11);k0=u(12);k1=u(13);k2=u(14);k3=u(15);sgm2=u(16);Bd=u(17);xite=0.001;

W=[x(1) x(2) x(3) x(4) x(5) x(6) x(7) x(8) x(9) x(10) x(11) x(12) x(13) x(14) x(15) x(16) x(17) x(18) x(19) x(20) x(21) x(22) x(23) x(24) x(25) x(26) x(27) x(28) x(29) x(30) x(31) x(32) x(33) x(34) x(35) x(36) x(37) x(38) x(39) x(40) x(41)......
   x(42) x(43) x(44) x(45) x(46) x(47) x(48) x(49) x(50) x(51) x(52) x(53) x(54) x(55) x(56) x(57) x(58) x(59) x(60) x(61) x(62) x(63) x(64) x(65) x(66) x(67) x(68) x(69) x(70) x(71) x(72) x(73) x(74) x(75) x(76) x(77) x(78) x(79) x(80) x(81)]';
xi=[ut;v;r;Phi];
% xi=[v;r;Phi];
h=zeros(81,1);
for j=1:1:81
    h(j)=exp(-norm(xi-cij(:,j))^2/(2*bj^2));%高斯基函数输出
end
fn=W'*h;%得到神经网络f(x)的估计值
%   a=0.1;b=1;
% kl=10*(a+b*ePsi);
D=1;

ud=((1/D)*dsgm2+k3*tanh(k2*sgm1)+k1*k0*depsi*(sech(k0*ePsi))^2+ddPsid-fn)/(Bd+0.00000000001);%+xite*sign(dsgm2)/Bd
% ud=(k3*tanh(k2*sgm1)+k1*k0*depsi*(sech(k0*ePsi))^2+ddPsid-fn)/Bd;

sys(1)=ud;%输出控制器deltar
sys(2)=fn;%输出f的估计值
% sys(3)=W;



