function [s,xint,yint]=BrokenLine(L)

xint=[];
yint=[];

for i=1:numrows(L)-1
    for j=1:ceil(abs(L(i+1)-L(i)))/0.01
        xt(j,1)=L(i,1)+(j-1)*0.01;
    end
    yt=interp1(L(i:i+1,1),L(i:i+1,2),xt);
    xint=[xint;xt];
    yint=[yint;yt];
end

s=zeros(length(xint),1);
s(1)=0;
for i=2:length(xint)
    s(i)=s(i-1)+norm([xint(i)-xint(i-1),yint(i)-yint(i-1)],2);
end


