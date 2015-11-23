clear all
clc
global h gamma k

h=1;
gamma=3;
k=6;

x0=[sqrt(2) -pi -pi/4]';

% [t y]=ode45('polar',[0 10],x0);

h1=0.001;
a=0;b1=20;
y0=x0;

n=floor((b1-a)/h1);                                    %求步数
t(1)=a;                                       %时间起点
y(:,1)=y0;

for ii=1:n
   t1(ii)=t(ii);
   t(ii+1)=t(ii)+h1;
   
   p1=polar(t(ii),y(:,ii));
   y(:,ii+1)=y(:,ii)+h1*p1;      
   
end 
y=y';

plot(t,y(:,1),t,y(:,2),t,y(:,3))