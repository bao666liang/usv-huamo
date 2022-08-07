close all;

figure(1);
plot(x,y,'--',xd,yd,'r','linewidth',2.5);
set(gca, 'Fontname', 'Times New Roman','FontSize',18);
% legend('实际轨迹','参考轨迹');
legend('actual trajectory','reference trajectory');

xlabel('$x$/m','Interpreter','latex','FontSize',18);
ylabel('$y$/m','Interpreter','latex','FontSize',18);

figure(2);
subplot(311);
plot(t,x,'linewidth',2.5);
set(gca, 'Fontname', 'Times New Roman','FontSize',18);
xlabel('$t$/s','Interpreter','latex','FontSize',18);
ylabel('$x$/m','Interpreter','latex','FontSize',18);

subplot(312);
plot(t,y,'linewidth',2.5);
set(gca, 'Fontname', 'Times New Roman','FontSize',18);
xlabel('$t$/s','Interpreter','latex','FontSize',18);
ylabel('$y$/m','Interpreter','latex','FontSize',18);

subplot(313);
plot(t,abs(fai),'linewidth',2.5);
set(gca, 'Fontname', 'Times New Roman','FontSize',18);
xlabel('$t$/s','Interpreter','latex','FontSize',18);
ylabel('$\psi$/rad','Interpreter','latex','FontSize',18);


figure(3);
subplot(311);
plot(t,u,'linewidth',2.5);
set(gca, 'Fontname', 'Times New Roman','FontSize',18);
legend('u');
xlabel('$t$/s','Interpreter','latex','FontSize',18);
% ylabel('u/(m/s)');
% ylabel('$u$/(m/s)','Interpreter','latex','FontSize',16);
ylabel('$u$/m${\cdot}$s$^{-1}$','Interpreter','latex','FontSize',18);

subplot(312);
plot(t,v,'linewidth',2.5);
set(gca, 'Fontname', 'Times New Roman','FontSize',18);
legend('v');
xlabel('$t$/s','Interpreter','latex','FontSize',18);
% ylabel('v/(m/s)');
ylabel('$v$/m${\cdot}$s$^{-1}$','Interpreter','latex','FontSize',18);

subplot(313);
plot(t,r,'linewidth',2.5);
set(gca, 'Fontname', 'Times New Roman','FontSize',18);
legend('r');
xlabel('$t$/s','Interpreter','latex','FontSize',18);
% ylabel('r/(rad/s)');
ylabel('$r$/rad${\cdot}$s$^{-1}$','Interpreter','latex','FontSize',18);

figure(4);
subplot(211);
plot(t,xd,'r',t,x,'b--','linewidth',2.5);
set(gca, 'Fontname', 'Times New Roman','FontSize',18);
legend('$x_d$','$x$','Interpreter','latex','FontSize',18);
xlabel('$t$/s','Interpreter','latex','FontSize',18);
% ylabel('x/m');
ylabel('m','Interpreter','latex','FontSize',18);
subplot(212);
plot(t,yd,'r',t,y,'b--','linewidth',2.5);
set(gca, 'Fontname', 'Times New Roman','FontSize',18);
% legend('y','y_d');
legend('$y_d$','$y$','Interpreter','latex','FontSize',18);
xlabel('$t$/s','Interpreter','latex','FontSize',18);
% ylabel('y/m');
ylabel('m','Interpreter','latex','FontSize',18);

figure(5);
subplot(211);
plot(t,xe,'linewidth',2.5);
set(gca, 'Fontname', 'Times New Roman','FontSize',18);
legend('x_e');
xlabel('$t$/s','Interpreter','latex','FontSize',18);
% ylabel('x_e/m');
ylabel('$x_e$/m','Interpreter','latex','FontSize',18);

subplot(212);
plot(t,ye,'linewidth',2.5);
set(gca, 'Fontname', 'Times New Roman','FontSize',18);
legend('y_e');
xlabel('$t$/s','Interpreter','latex','FontSize',18);
% ylabel('y_e/m');
ylabel('$y_e$/m','Interpreter','latex','FontSize',18);


figure(6);
subplot(211);
plot(t,ue,'linewidth',2.5);
set(gca, 'Fontname', 'Times New Roman','FontSize',18);
legend('u_e');
xlabel('$t$/s','Interpreter','latex','FontSize',18);
% ylabel('u_e/(m/s)');
ylabel('$u_e$/m${\cdot}$s$^{-1}$','Interpreter','latex','FontSize',18);

subplot(212);
plot(t,ve,'linewidth',2.5);
set(gca, 'Fontname', 'Times New Roman','FontSize',18);
legend('v_e');
xlabel('$t$/s','Interpreter','latex','FontSize',18);
% ylabel('v_e/(m/s)');
ylabel('$v_e$/m${\cdot}$s$^{-1}$','Interpreter','latex','FontSize',18);

figure(7);
plot(t,ue,'r',t,ve,'b--','linewidth',2.5);
set(gca, 'Fontname', 'Times New Roman','FontSize',18);
legend('u_e','v_e');
xlabel('$t$/s','Interpreter','latex','FontSize',18);
% ylabel('u_e/(m/s)');
ylabel('m${\cdot}$s$^{-1}$','Interpreter','latex','FontSize',18);


figure(8);
subplot(211);
plot(t,taou,'linewidth',2.5);
set(gca, 'Fontname', 'Times New Roman','FontSize',18);
legend('\tau_u');
xlabel('$t$/s','Interpreter','latex','FontSize',18);
% ylabel('\tau_u/N');
ylabel('$\tau_u$/N','Interpreter','latex','FontSize',18);
subplot(212);
plot(t,taor,'linewidth',2.5);
set(gca, 'Fontname', 'Times New Roman','FontSize',18);
legend('\tau_r');
xlabel('$t$/s','Interpreter','latex','FontSize',18);
% ylabel('\tau_r/N\cdotm');
ylabel('$\tau_r$/N${\cdot}$m','Interpreter','latex','FontSize',18);

figure(9);
subplot(211);
plot(t,(twu),t,Twu,'linewidth',2.5);
set(gca, 'Fontname', 'Times New Roman','FontSize',18);
legend('\tau_{wu}','\tau_{wu}估计值');
xlabel('$t$/s','Interpreter','latex','FontSize',18);
% ylabel('$\hat{\tau_{wu}}$','Interpreter','latex','FontSize',16);
ylabel('N','Interpreter','latex','FontSize',18)
subplot(212);
plot(t,(twr),t,Twr,'linewidth',2.5);
set(gca, 'Fontname', 'Times New Roman','FontSize',18);
legend('\tau_{wr}','\tau_{wr}估计值');
xlabel('$t$/s','Interpreter','latex','FontSize',18);
ylabel('N${\cdot}$m','Interpreter','latex','FontSize',18);
% ylabel('$\hat{\tau_{wr}}$','Interpreter','latex','FontSize',16);


figure(10);
subplot(311);
plot(t,xd,'r',t,x,'b--','linewidth',2.5);
set(gca, 'Fontname', 'Times New Roman','FontSize',18);
legend('$x_d$','$x$','Interpreter','latex','FontSize',18);
xlabel('$t$/s','Interpreter','latex','FontSize',18);
ylabel('m','Interpreter','latex','FontSize',18);
subplot(312);
plot(t,yd,'r',t,y,'b--','linewidth',2.5);
set(gca, 'Fontname', 'Times New Roman','FontSize',18);
% legend('y','y_d');
legend('$y_d$','$y$','Interpreter','latex','FontSize',18);
xlabel('$t$/s','Interpreter','latex','FontSize',18);
% ylabel('y/m');
ylabel('m','Interpreter','latex','FontSize',18);
subplot(313);
plot(t,abs(fai),'linewidth',2.5);
set(gca, 'Fontname', 'Times New Roman','FontSize',18);
legend('$\psi$','Interpreter','latex','FontSize',18);
xlabel('$t$/s','Interpreter','latex','FontSize',18);
ylabel('rad','Interpreter','latex','FontSize',18);

figure(11);
subplot(211);
plot(t,dfu,t,Dfu,'r--','linewidth',2.5);
set(gca, 'Fontname', 'Times New Roman','FontSize',18);
legend('\Deltaf_u','\Deltaf_u逼近值');
xlabel('$t$/s','Interpreter','latex','FontSize',18);
ylabel('N','Interpreter','latex','FontSize',18);
subplot(212);
plot(t,dfr,t,Dfr,'r--','linewidth',2.5);
set(gca, 'Fontname', 'Times New Roman','FontSize',18);
legend('\Deltaf_r','\Deltaf_r逼近值');
xlabel('$t$/s','Interpreter','latex','FontSize',18);
ylabel('N${\cdot}$m','Interpreter','latex','FontSize',18);

