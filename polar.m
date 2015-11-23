function y=polar(t,x)
global gamma h k


u1 = gamma*cos(x(2))*x(1);
% 
% if x(2)~=0
% u2 =k*x(2)+gamma*cos(x(2))*sin(x(2))/x(2)*(x(2)+h*x(3));
% else
% u2 =gamma*h*x(3);
% end


u2 =k*x(2)+gamma*cos(x(2))*sin(x(2))/x(2)*(x(2)+h*x(3));

y(1,1)=-u1*cos(x(2));
y(2,1)=-u2+u1*sin(x(2))/x(1);
y(3,1)=u1*sin(x(2))/x(1);



