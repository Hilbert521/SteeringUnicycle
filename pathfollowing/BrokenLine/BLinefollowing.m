function [y,theta,alpha,phi]=BLinefollowing(t,x)

global gamma h k lam ep s xint yint
    
if x(4)+0.02>=s(end)
    x(4)=s(end)-0.02;
end
xt=interp1(s,xint,x(4));
yt=interp1(s,yint,x(4));

dyt=interp1(s,yint,x(4)+0.02)-interp1(s,yint,x(4));
dxt=interp1(s,xint,x(4)+0.02)-interp1(s,xint,x(4));


theta1=atan2(dyt,dxt);

e=norm([xt-x(1),yt-x(2)],2);

theta=atan2(yt-x(2),xt-x(1))-theta1;
phi=x(3)-theta1;
alpha=theta-phi;

u1 = gamma*cos(alpha)*e;
% 
% if alpha~=0
% u2 =k*alpha+gamma*cos(alpha)*sin(alpha)/alpha*(alpha+h*theta);
% else
% u2 =gamma*h*theta;
% end

u2 =k*alpha+gamma*cos(alpha)*sin(alpha)/alpha*(alpha+h*theta);

V=lam*e^2+alpha^2+h*theta^2;

y(1,1)=u1*cos(x(3));
y(2,1)=u1*sin(x(3));
y(3,1)=u2;

if (x(4)+0.02<=s(end))
    y(4,1)=max(0,2-V/ep);
else
    y(4,1)=0;
end