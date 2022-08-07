
figure(1);
subplot(311);
plot(t,x,'r',t,xg,'--','linewidth',2.5);
set(gca, 'Fontname', 'Times New Roman','FontSize',18);
legend('$x$','$\hat{x}$','Interpreter','latex','FontSize',18);
xlabel('$t$/s','Interpreter','latex','FontSize',18);
ylabel('m','Interpreter','latex','FontSize',18);
subplot(312);
plot(t,y,'r',t,yg,'--','linewidth',2.5);
set(gca, 'Fontname', 'Times New Roman','FontSize',18);
legend('$y$','$\hat{y}$','Interpreter','latex','FontSize',18);
xlabel('$t$/s','Interpreter','latex','FontSize',18);
ylabel('m','Interpreter','latex','FontSize',18);
subplot(313);
plot(t,abs(fai),'r',t,abs(faig),'--','linewidth',2.5);
set(gca, 'Fontname', 'Times New Roman','FontSize',18);
legend('$\psi$','$\hat\pai$','Interpreter','latex','FontSize',18);
xlabel('$t$/s','Interpreter','latex','FontSize',18);
ylabel('rad','Interpreter','latex','FontSize',18);

figure(2);
plot(t,u,'b',t,ug,'r:','linewidth',2.5);
set(gca, 'Fontname', 'Times New Roman','FontSize',18);
legend('$u$','$\hat{u}$','Interpreter','latex','FontSize',18);
xlabel('$t$/s','Interpreter','latex','FontSize',18);
ylabel('$u$/m${\cdot}$s$^{-1}$','Interpreter','latex','FontSize',18);

figure(3);
plot(t,v,'b',t,vg,'r:','linewidth',2.5);
set(gca, 'Fontname', 'Times New Roman','FontSize',18);
legend('$v$','$\hat{v}$','Interpreter','latex','FontSize',18);
xlabel('$t$/s','Interpreter','latex','FontSize',18);
ylabel('$v$/m${\cdot}$s$^{-1}$','Interpreter','latex','FontSize',18);

figure(4);
plot(t,r,'b',t,rg,'r:','linewidth',2.5);
set(gca, 'Fontname', 'Times New Roman','FontSize',18);
legend('$r$','$\hat{r}$','Interpreter','latex','FontSize',18);
xlabel('$t$/s','Interpreter','latex','FontSize',18);
ylabel('$r$/rad${\cdot}$s$^{-1}$','Interpreter','latex','FontSize',18);


figure(4);
subplot(311);
plot(t,u,'r',t,ug,'--','linewidth',2.5);
set(gca, 'Fontname', 'Times New Roman','FontSize',18);
legend('$u$','$\hat{u}$','Interpreter','latex','FontSize',18);
xlabel('$t$/s','Interpreter','latex','FontSize',18);
ylabel('$u$/m${\cdot}$s$^{-1}$','Interpreter','latex','FontSize',18);

subplot(312);
plot(t,v,'r',t,vg,'--','linewidth',2.5);
set(gca, 'Fontname', 'Times New Roman','FontSize',18);
legend('$v$','$\hat{v}$','Interpreter','latex','FontSize',18);
xlabel('$t$/s','Interpreter','latex','FontSize',18);
ylabel('$v$/m${\cdot}$s$^{-1}$','Interpreter','latex','FontSize',18);

subplot(313);
plot(t,r,'r',t,rg,'--','linewidth',2.5);
set(gca, 'Fontname', 'Times New Roman','FontSize',18);
legend('$r$','$\hat{r}$','Interpreter','latex','FontSize',18);
xlabel('$t$/s','Interpreter','latex','FontSize',18);
ylabel('$r$/rad${\cdot}$s$^{-1}$','Interpreter','latex','FontSize',18);

figure(5);
plot(t,u-ug,'b',t,v-vg,'g--',t,r-rg,'r:','linewidth',2.5);
set(gca, 'Fontname', 'Times New Roman','FontSize',18);
legend('$u_e$','$v_e$','$r_e$','Interpreter','latex','FontSize',18);
xlabel('$t$/s','Interpreter','latex','FontSize',18);
ylabel('$v$/m${\cdot}$s$^{-1}$','Interpreter','latex','FontSize',18);

