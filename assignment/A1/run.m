load data/compEx1.mat
x2Df = pflat(x2D);
x3Df = pflat(x3D);
plot(x2Df(1,:),x2Df(2,:),'.');
axis equal
saveas(gcf,"2_x2d.png");
plot3(x3Df(1,:),x3Df(2,:),x3Df(3,:),'.')
axis equal
saveas(gcf,"2_x3d.png");