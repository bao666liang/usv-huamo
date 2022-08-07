close all;
figure(1);% 实际路径与期望路径
plot(X,Y,'b',x,y,'r:','linewidth',2.5);
xlabel('x/m');ylabel('y/m');
legend('reference trajectory','actual trajectory');

figure(2);% 实际轨迹 x y psi 与期望 xd yd psid 横坐标为t
subplot(311);
plot(t,X,'b',t,x,'r:','linewidth',2.5);
ylabel('m');
legend('xd','x');
subplot(312);
plot(t,Y,'b',t,y,'r:','linewidth',2.5);
ylabel('m');
legend('yd','y');
subplot(313);
plot(t,PSI,'b',t,psi,'r:','linewidth',2.5);
xlabel('t/s');ylabel('rad');
legend('\psid','\psi');

figure(3);%船体坐标系下的u v r
subplot(311);
plot(t,u,'b','linewidth',2.5);
ylabel('m/s');
legend('u');
subplot(312);
plot(t,v,'b','linewidth',2.5);
ylabel('m/s');
legend('v');
subplot(313);
plot(t,r,'b','linewidth',2.5);
xlabel('t/s');ylabel('rad/s');
legend('r');

figure(4);%控制器输出推力减去观测扰动力后的船舶输入推力 因为单位为KN要除1000
subplot(311);
plot(t,TAO(:,1)/1000,'linewidth',2.5);
ylabel('\tau_1/kN');
legend('\tau_1');
subplot(312);
plot(t,TAO(:,2)/1000,'linewidth',2.5);
ylabel('\tau_2/kN');
legend('\tau_2');
subplot(313);
plot(t,TAO(:,3)/1000,'linewidth',2.5);
xlabel('t/s');ylabel('\tau_3/kN\cdotm');
legend('\tau_3');

figure(5);%观测估计扰动DD和真实扰动DDD 数轴单位为千牛要除1000
subplot(311);
plot(t,DDD(:,1)/1000,'b',t,DD(:,1)/1000,'r:','linewidth',2.5);
ylabel('kN');
legend('d_1','d_1估计值');
subplot(312);
plot(t,DDD(:,2)/1000,'b',t,DD(:,2)/1000,'r:','linewidth',2.5);
ylabel('kN');
legend('d_2','d_2估计值');
subplot(313);
plot(t,DDD(:,3)/1000,'b',t,DD(:,3)/1000,'r:','linewidth',2.5);
xlabel('t/s');ylabel('kN\cdotm');
legend('d_3','d_3估计值');

figure(6);%观测误差DDD-DD及其上界delta的估计值和误差上界乘双曲正切的值(X5/绿)
subplot(311);
plot(t,DDD(:,1)/1000-DD(:,1)/1000,'b',t,DGJ(:,1)/1000,'r:',t,X5(:,1)/1000,'g:','linewidth',2.5);
ylabel('kN');
legend('d_1\sim','\delta1');
subplot(312);
plot(t,DDD(:,2)/1000-DD(:,2)/1000,'b',t,DGJ(:,2)/1000,'r:',t,X5(:,2)/1000,'g:','linewidth',2.5);
ylabel('kN');
legend('d_2\sim','\delta2');
subplot(313);
plot(t,DDD(:,3)/1000-DD(:,3)/1000,'b',t,DGJ(:,3)/1000,'r:',t,X5(:,3)/1000,'g:','linewidth',2.5);
xlabel('t/s');ylabel('kN\cdotm');
legend('d_3\sim','\delta3');

% figure(7);
% subplot(311);
% plot(t,XI(:,1),'b','linewidth',2.5);
% ylabel('kN');
% legend('xi');
% subplot(312);
% plot(t,XI(:,2),'b','linewidth',2.5);
% ylabel('kN');
% legend('xi');
% subplot(313);
% plot(t,XI(:,3),'b','linewidth',2.5);
% xlabel('t/s');ylabel('kN\cdotm');
% legend('xi');

figure(7);%真实扰动和扰动误差上界
subplot(311);
plot(t,DDD(:,1)/1000,'b',t,DGJ(:,1)/1000,'r:','linewidth',2.5);
ylabel('kN');
legend('d_1\sim','\delta1');
subplot(312);
plot(t,DDD(:,2)/1000,'b',t,DGJ(:,2)/1000,'r:','linewidth',2.5);
ylabel('kN');
legend('d_2\sim','\delta2');
subplot(313);
plot(t,DDD(:,3)/1000,'b',t,DGJ(:,3)/1000,'r:','linewidth',2.5);
xlabel('t/s');ylabel('kN\cdotm');
legend('d_3\sim','\delta3');

% figure(9);
% subplot(311);
% plot(t,DGJ(:,1)/1000,'b',t,XI(:,1)/1000,'r:','linewidth',2.5);
% ylabel('kN');
% legend('d_1','d_1估计值');
% subplot(312);
% plot(t,DGJ(:,2)/1000,'b',t,XI(:,2)/1000,'r:','linewidth',2.5);
% ylabel('kN');
% legend('d_2','d_2估计值');
% subplot(313);
% plot(t,DGJ(:,3)/1000,'b',t,XI(:,3)/1000,'r:','linewidth',2.5);
% xlabel('t/s');ylabel('kN\cdotm');
% legend('d_3','d_3估计值');

figure(8);%位姿误差向量z1
subplot(311);
plot(t,X-x,'b','linewidth',2.5);
ylabel('xe/m');
subplot(312);
plot(t,Y-y,'b','linewidth',2.5);
ylabel('ye/m');
subplot(313);
plot(t,PSI-psi,'b','linewidth',2.5);
xlabel('t/s');ylabel('\psie/rad');

figure(9);%重新定义的速度误差向量z2
subplot(311);
plot(t,u-ud,'b','linewidth',2.5);
ylabel('ue/m/s');
subplot(312);
plot(t,v-vd,'b','linewidth',2.5);
ylabel('ve/m/s');
subplot(313);
plot(t,r-rd,'b','linewidth',2.5);
xlabel('t/s');ylabel('re/rad/s');

figure(10);%位姿误差向量z1的范数
plot(t,sqrt((x-X).^2+(y-Y).^2+(psi-PSI).^2),'b','linewidth',2.5);
xlabel('t/s');ylabel('||z_1||');
