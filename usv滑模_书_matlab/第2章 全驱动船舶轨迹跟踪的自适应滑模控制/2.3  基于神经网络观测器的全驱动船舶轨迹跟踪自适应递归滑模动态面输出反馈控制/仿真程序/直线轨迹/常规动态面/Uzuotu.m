close all;
figure(1);
plot(X,Y,'b',x,y,'r:','linewidth',2.5);
xlabel('x/m');ylabel('y/m');
legend('参考轨迹','本文算法');

figure(2);
subplot(311);
plot(t,X,'b',t,x,'r:','linewidth',2.5);
ylabel('m');
legend('xd','x');
subplot(312);
plot(t,Y,'b',t,y,'r:','linewidth',2.5);
ylabel('m');
legend('yd','y');
subplot(313);
plot(t,0.01*t,'b',t,psi,'r:','linewidth',2.5);
xlabel('t/s');ylabel('rad');
legend('\psid','\psi');

figure(3);
subplot(311);
plot(t,ut,'b',t,Vd(:,1),'r:',t,VG(:,1),'g:','linewidth',2.5);
ylabel('u/m/s');
subplot(312);
plot(t,v,'b',t,Vd(:,2),'r:',t,VG(:,2),'g:','linewidth',2.5);
ylabel('v/m/s');
subplot(313);
plot(t,r,'b',t,Vd(:,3),'r:',t,VG(:,3),'g:','linewidth',2.5);
xlabel('t/s');ylabel('r/rad/s');

figure(4);
subplot(311);
plot(t,TAO1(:,1)/1000,'linewidth',2.5);
ylabel('\tau_1/kN');
subplot(312);
plot(t,TAO1(:,2)/1000,'linewidth',2.5);
ylabel('\tau_2/kN');
subplot(313);
plot(t,TAO1(:,3)/1000,'linewidth',2.5);
xlabel('t/s');ylabel('\tau_3/kN\cdotm');

figure(5);
subplot(311);
plot(t,TAO(:,1)/1000,'linewidth',2.5);
ylabel('\tau_1/kN');
subplot(312);
plot(t,TAO(:,2)/1000,'linewidth',2.5);
ylabel('\tau_2/kN');
subplot(313);
plot(t,TAO(:,3)/1000,'linewidth',2.5);
xlabel('t/s');ylabel('\tau_3/kN\cdotm');

figure(6);
subplot(311);
plot(t,FFS(:,1)/1000,'b',t,FF(:,1)/1000,'r:','linewidth',2.5);
ylabel('kN');
legend('f_1','NN_1');
subplot(312);
plot(t,FFS(:,2)/1000,'b',t,FF(:,2)/1000,'r:','linewidth',2.5);
ylabel('kN');
legend('f_2','NN_2');
subplot(313);
plot(t,FFS(:,3)/1000,'b',t,FF(:,3)/1000,'r:','linewidth',2.5);
xlabel('t/s');ylabel('kN\cdotm');
legend('f_3','NN_3');

figure(7);
subplot(311);
plot(t,Fos(:,1)/1000,'b',t,Fog(:,1)/1000,'r:','linewidth',2.5);
ylabel('kN');
legend('^o^b^sf_1','^o^b^sNN_1');
subplot(312);
plot(t,Fos(:,2)/1000,'b',t,Fog(:,2)/1000,'r:','linewidth',2.5);
ylabel('kN');
legend('^o^b^sf_2','^o^b^sNN_2');
subplot(313);
plot(t,Fos(:,3)/1000,'b',t,Fog(:,3)/1000,'r:','linewidth',2.5);
xlabel('t/s');ylabel('kN\cdotm');
legend('^o^b^sf_3','^o^b^sNN_3');

figure(8);
subplot(311);
plot(t,x-X,'b','linewidth',2.5);
ylabel('x_e/m');
subplot(312);
plot(t,y-Y,'b','linewidth',2.5);
ylabel('y_e/m');
subplot(313);
plot(t,psi-0.01*t,'b','linewidth',2.5);
xlabel('t/s');ylabel('\psi_e/rad');

figure(9);
plot(t,sqrt((x-X).^2+(y-Y).^2+(psi-0.01*t).^2),'b','linewidth',2.5);
xlabel('t/s');ylabel('轨迹跟踪误差');

figure(10);
subplot(311);
plot(t,(DDD(:,1))/1000-(FFS(:,1)-FF(:,1))/1000,'b',t,DGJ(:,1)/1000,'r:',t,(DDD(:,1))/1000,'g:',t,(DS(:,1))/1000,'y:','linewidth',2.5);
ylabel('kN');
legend('\delta1','\delta1估计值');
subplot(312);
plot(t,(DDD(:,2))/1000-(FFS(:,2)-FF(:,2))/1000,'b',t,DGJ(:,2)/1000,'r:',t,(DDD(:,2))/1000,'g:',t,(DS(:,2))/1000,'y:','linewidth',2.5);
ylabel('kN');
legend('\delta2','\delta2估计值');
subplot(313);
plot(t,(DDD(:,3))/1000-(FFS(:,3)-FF(:,3))/1000,'b',t,DGJ(:,3)/1000,'r:',t,(DDD(:,3))/1000,'g:',t,(DS(:,3))/1000,'y:','linewidth',2.5);
xlabel('t/s');ylabel('kN\cdotm');
legend('\delta3','\delta3估计值');

figure(11);
subplot(311);
plot(t,abs(DDD(:,1)/1000)+abs((FFS(:,1)-FF(:,1))/1000),'b',t,DGJ(:,1)/1000,'r:',t,abs(DDD(:,1))/1000,'g:',t,abs(DS(:,1))/1000,'y:','linewidth',2.5);
ylabel('kN');
legend('\delta1','\delta1估计值');
subplot(312);
plot(t,abs(DDD(:,2)/1000)+abs((FFS(:,2)-FF(:,2))/1000),'b',t,DGJ(:,2)/1000,'r:',t,abs(DDD(:,2))/1000,'g:',t,abs(DS(:,2))/1000,'y:','linewidth',2.5);
ylabel('kN');
legend('\delta2','\delta2估计值');
subplot(313);
plot(t,abs(DDD(:,3)/1000)+abs((FFS(:,3)-FF(:,3))/1000),'b',t,DGJ(:,3)/1000,'r:',t,abs(DDD(:,3))/1000,'g:',t,abs(DS(:,3))/1000,'y:','linewidth',2.5);
xlabel('t/s');ylabel('kN\cdotm');
legend('\delta3','\delta3估计值');



