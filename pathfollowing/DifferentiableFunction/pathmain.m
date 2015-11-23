clear all
clc

global h gamma k lam ep s xint

%Given a function y=f(x) or a paramterized curve y=y(t) x=x(t), get the
% relation (s,x) or (s,t) where 's' is the length of the curver from x=0 
%(function case) or t=0 (parameter case)
%The range of the function case is x<=30
%The data for several functions are given in the mat functions
%func1: y=1/2x
%func2: y=arctan(x^2)

% load('func1.mat')% y=1/2x
load('func2.mat')% y=arctan(x^2)

% syms p fx fy s1
% 
% fx=p;
% fy=atan(p^2);
% s1=sqrt(diff(fx,p)^2+diff(fy,p)^2);
% 
% xint=0:0.05:10;
% s=zeros(length(xint),1);
% i=0;
% for j=xint
%     i=i+1;
%     s(i)=eval(int(s1,p,0,j));
% end

h=1;
gamma=3;
k=6;
lam=0.01;
ep=0.02;

x0=[-3 4 3*pi/4 0]';

% [t y]=ode45('Pathfollowing',[0 10],x0);

h1=0.02;
a=0;b1=6;
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
   
   [p1,q1,q2,q3]=pathfollowing(t(ii),y(:,ii));
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
y=y(:,1:3);

x0=x0(1:3);

plotv(y,'x0',x0,'mode',1);
