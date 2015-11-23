function [y phi theta alpha]=unicontrol(t,x)
global gamma h k

e=norm([x(1),x(2)],2);
theta=atan2(-x(2),-x(1));
phi=x(3);
alpha=theta-phi;

u1 = gamma*cos(alpha)*e;
% 
% if alpha~=0
% u2 =k*alpha+gamma*cos(alpha)*sin(alpha)/alpha*(alpha+h*theta);
% else
% u2 =gamma*h*theta;
% end


u2 =k*alpha+gamma*cos(alpha)*sin(alpha)/alpha*(alpha+h*theta);

y(1,1)=u1*cos(x(3));
y(2,1)=u1*sin(x(3));
y(3,1)=u2;



