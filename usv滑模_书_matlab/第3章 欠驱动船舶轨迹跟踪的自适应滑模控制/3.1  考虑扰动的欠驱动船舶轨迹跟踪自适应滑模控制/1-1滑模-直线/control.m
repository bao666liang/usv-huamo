
function [sys,x0,str,ts] = control(t,x,u,flag)

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
sizes.NumOutputs     = 2;
sizes.NumInputs      = 13;
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

a=1;
eta1=1*10^4;eta2=1*10^4;
Twumax=1*10^5;Twvmax=1*10^2;Twrmax=1*10^6;
lamda1=1;lamda2=1;

H=0.2;
m11=1.2*10^5;m22=1.779*10^5;m33=6.36*10^7;
d11=2.15*10^4;d22=1.47*10^5;d33=8.02*10^6;
MM11=m11*0.05;MM22=m22*0.05;MM33=m33*0.05;
D11=d11*0.05;

alfu=u(1);
alfv=u(2);
dalfu=u(3);
dalfv=u(4);
ue=u(5);
s1=u(6);
s2=u(7);
f_dot=u(8);
dut=u(9);
ut=u(10);
dv=u(11);
v=u(12);
r=u(13);


K1=lamda1*MM11*abs(ue)+MM22*abs(v*r)+D11*abs(ut)+MM11*abs(dalfu)+eta1+Twumax;
taou=-lamda1*m11*ue-m22*v*r+d11*ut+m11*dalfu-K1*sign(s1);

hh=-(m22*alfu*((m11-m22)*ut*v-d33*r)+m22*m33*(r*dalfu-f_dot+lamda2*(dv-dalfv))-d22*m33*dv-m11*m33*dut*r+m11*d33*ut*r+m11*(m22-m11)*ut^2*v);
b=m22*alfu-m11*ut;
K2=a*(H+eta2+b*Twrmax+MM33*Twvmax)+(a-1)*abs(hh);
taor=(hh-K2*sign(s2))/b;

sys(1)=taou;
sys(2)=taor;

function sys=mdlGetTimeOfNextVarHit(t,x,u)

sampleTime = 1;    %  Example, set the next hit to be one second later.
sys = t + sampleTime;


function sys=mdlTerminate(t,x,u)

sys = [];

% end mdlTerminate
