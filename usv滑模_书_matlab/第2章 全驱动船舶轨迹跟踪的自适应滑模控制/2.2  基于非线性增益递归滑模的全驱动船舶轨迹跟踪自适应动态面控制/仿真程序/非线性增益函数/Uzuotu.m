close all;
a2=2;
    xsl1=-20:0.1:20;
for i=1:1:401;
    ysl1(i)=a2*(abs(xsl1(i))^(0.5))*sign(xsl1(i));
    if xsl1(i)==0;
        ysl2(i)=1;
    else
        ysl2(i)=0.5*a2*(abs(xsl1(i))^(-0.5));
    end
    ysl3(i)=0.5*(ysl2(i)*xsl1(i)+ysl1(i));
end
plot(xsl1,ysl3,'b','linewidth',2.5);
xlabel('x');ylabel('L(x)');

