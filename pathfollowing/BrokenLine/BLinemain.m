clear all
clc

global h gamma k lam ep s xint yint

%A BrokenLine is defined by the vector L where each row gives one point (x,y) 

L=[0 0;1 2;3 -1;6 4];

[s,xint,yint]=BrokenLine(L);

h=1;
gamma=3;
k=6;
lam=0.01;
ep=0.02;

x0=[-3 4 3*pi/4 0]';

% [t y]=ode45('BLinefollowing',[0 10],x0);

h1=0.02;
a=0;b1=15;
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
   
   [p1,q1,q2,q3]=BLinefollowing(t(ii),y(:,ii));
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
y1=y(:,1:3);

x0=x0(1:3);

plotv(y1,'mode',1);
