function [dist] = point_line_distance_2D(p,line)
%POINT_LINE_DISTANCE_2D Summary of this function goes here
%   Detailed explanation goes here
a=line(1);
b=line(2);
c=line(3);
x1=p(1);
x2=p(2);

dist =abs(a*x1+b*x2+c)/sqrt(a*a+b*b);
end
