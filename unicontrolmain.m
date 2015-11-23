clear all
clc
global h gamma k

h=1;
gamma=3;
k=6;

x0=[-1 1 3*pi/4]';

% [t y]=ode45('unicontrol',[0 10],x0);

h1=0.001;
a=0;b1=10;
y0=x0;

n=floor((b1-a)/h1);                                    %求步数
t(1)=a;                                       %时间起点
y(:,1)=y0;
u1=zeros(n,1);
u2=zeros(n,1);
u3=zeros(n,1);
t1=zeros(n,1);
%赋初值，可以是向量，但是要注意维数
for ii=1:n
   t1(ii)=t(ii);
   t(ii+1)=t(ii)+h1;
   
   [p1,q1,q2,q3]=unicontrol(t(ii),y(:,ii));
%    [p2,~,~,~]=unicontrol(t(ii)+h1/2,y(:,ii)+h1*p1/2);
%    [p3,~,~,~]=unicontrol(t(ii)+h1/2,y(:,ii)+h1*p2/2);
%    [p4,~,~,~]=unicontrol(t(ii)+h1,y(:,ii)+h1*p3);
%    
   u1(ii)=q1;
   u2(ii)=q2;
   u3(ii)=q3;
%    y(:,ii+1)=y(:,ii)+h1*(p1+2*p2+2*p3+p4)/6;       %按照龙格库塔方法进行数值求解
   y(:,ii+1)=y(:,ii)+h1*p1;       
   
end 
y=y';

plotv(y,'x0',x0,'mode',1);
