% clean history and terminal
clear
clc
% 

addpath './code'

load("data/compEx4.mat");

% load image
img = imread("data/compEx4.jpg");
imagesc(img);
colormap gray
axis equal 

K_inv = inv(K)
n_corners = K_inv* corners

hold on 
% plot corners
plot(corners(1,[1:end 1]),corners(2,[1:end 1]),'*-', 'Color','r');
saveas(gcf,"corners_with_image.png");
hold off 
% plot corners without K
plot(n_corners(1,[1:end 1]),n_corners(2,[1:end 1]),'*-', 'Color','r');
axis ij
axis equal
saveas(gcf,"corners_without_k.png");

% show 3d point and camera center
pv = pflat(v)
s = -pv(1:3)'*n_corners
u = pflat([n_corners;s])

plot3(u(1,[1:end 1]),u(2,[1:end 1]),u(3,[1:end 1]),'*-', 'Color','b')

hold on
P=[1 0 0 0; 0 1 0 0; 0 0 1 0]

% compute the second camera P2
R = [cos(pi/6) 0 -sin(pi/6); 0 1 0 ; sin(pi/6) 0 cos(pi/6)]
C = [-2;0;0]
T = -R*C
P2 = [R T]

[center paxis] = camera_center_and_axis(P)
[center2 paxis2] = camera_center_and_axis(P2)

plot_camera(P,5);
plot_camera(P2,5)
axis equal
saveas(gcf,"3D_corners_and_P1_P2.png");
hold off

% calculate corners in P2 with restulr from exercise 8
H=R-T*pv(1:3)'
p2_corners_h= pflat(H*n_corners)

% calcualte corners in P2 projection of 3D point
p2_corners_p = pflat(P2*u)


plot(p2_corners_h(1,[1:end 1]),p2_corners_h(2,[1:end 1]),'*-', 'Color','r');
hold on 
plot(p2_corners_p(1,[1:end 1]),p2_corners_p(2,[1:end 1]),'+-', 'Color','b');

axis equal
saveas(gcf,"P1_to_P2_and_3D_to_P2.png");
hold off

% transfer img with H_tot
H_tot = K*H*K_inv 
h_corners = pflat(H_tot * corners)


tform = projtform2d(H_tot)
[im_new, RB] = imwarp(img, tform);
imshow(im_new,RB);
hold on 
plot(h_corners(1,[1:end 1]),h_corners(2,[1:end 1]),'+-', 'Color','r');
saveas(gcf,"img_to_P2.png");
hold off
