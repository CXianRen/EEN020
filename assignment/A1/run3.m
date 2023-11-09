% clean history and terminal
clear
clc
% 

addpath './code'

load("data/compEx3.mat");

uf=pflat(U);

plot3(uf(1,:),uf(2,:),uf(3,:), '.', 'Markersize', 2);
hold on
plot_camera(P1,10);
plot_camera(P2,10);
saveas(gcf,"3D_U_and_P1_P2.png");
hold off

% % load image
img = imread("data/compEx3im1.jpg");
imagesc(img);
colormap gray
hold on 
pu1=pflat(P1*uf);
plot(pu1(1,:),pu1(2,:), '.', 'Markersize',2);
saveas(gcf,"U_in_P1.png");
hold off 

% load image
img = imread("data/compEx3im2.jpg");
imagesc(img);
colormap gray
hold on 
pu2=pflat(P2*uf);
plot(pu2(1,:),pu2(2,:), '.', 'Markersize',2);
saveas(gcf,"U_in_P2.png");
hold off 
