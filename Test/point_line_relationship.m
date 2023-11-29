clear 
clc
close all 

x = linspace(-2,2,2);
y = linspace(-2,2,2);

[X,Y] = meshgrid(x,y);

Z = ones(size(X));

surf(X,Y,Z, 'FaceAlpha', 0.5);
hold on 
a = [1; 1; 1];
b = [1; -1; 1];
c = cross(a,b);

quiver3(0,0,0, a(1),a(2),a(3), 'AutoScale', 'off')
quiver3(0,0,0, b(1),b(2),b(3), 'AutoScale', 'off')
quiver3(0,0,0, c(1),c(2),c(3), 'AutoScale', 'off')

% project to the camera plane 
e = c - [0 0 0]';
quiver3(0,0,1, e(1),e(2),0,0)
e = b-a;
quiver3(a(1),a(2),a(3),e(1),e(2),e(3), 'AutoScale', 'off')

axis equal
hold off

