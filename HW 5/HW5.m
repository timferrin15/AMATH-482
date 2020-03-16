x = -5:.1:5;
y = -2:.1:10;
y1 = tanh(x);
y2 = max(x,0);
y3 = [exp(-5:0.1:-0.1)-1, 0:0.1:5];
subplot(1,3,1)
hold on
plot(x,y1,'g','Linewidth',2)
plot(x,zeros(101),'k')
plot(zeros(21),-1:.1:1,'k')
title('tanh')
set(gca,'Fontsize',12)
subplot(1,3,2)
hold on
plot(x,y2,'b','Linewidth',2)
plot(x,zeros(101),'k')
plot(zeros(121),y,'k')
set(gca,'ylim',[-2,6],'Fontsize',12)
title('ReLU')
subplot(1,3,3)
hold on
plot(x,y3,'r','Linewidth',2)
plot(x,zeros(101),'k')
plot(zeros(121),y,'k')
title('ELU')
set(gca,'ylim',[-2,6],'Fontsize',12)

print(gcf,'Activationfuns.png','-dpng')