clear
close all
clc

addpath ./data/
addpath ./code/

load data/compEx2data.mat



% for customized image 
% img_1 = imread("data/test1.jpg");
% img_width = size(img_1,2);
% img_height = size(img_1,1);
% f=26 %mm
% fx = img_width * f/40;
% cx = img_width/2;
% cy = img_height/2;
% K=[fx,0,cx; 0, fx , cy; 0, 0, 1];
%

% run extract_matched_points.m to getr x1 and x2
load matched_points.mat
x1 = [x1; ones(1,size(x1,2))];
x2 = [x2; ones(1,size(x2,2))];


% normalize x with N1 and N2
x_1_n = inv(K) * x1;
x_2_n = inv(K) * x2;

plot(x_1_n(1,:),x_1_n(2,:),'+');
plot(x_2_n(1,:),x_2_n(2,:),'+');

[ransac_E,epsilon, inliers_idx] = estimate_E_robust(K,x_1_n,x_2_n);
ransac_F = convert_E_to_F(ransac_E,K,K);
ransac_F = ransac_F ./ ransac_F(3,3);
ransac_l1 = ransac_F'*x2;
ransac_l2 = ransac_F*x1;

epsilon

%plot(diag(x{2}'*F*x{1}));


%%% debug %%%%
[P2,X]= get_P2_and_X_from_E(ransac_E,x_1_n(:,inliers_idx),x_2_n(:,inliers_idx));

plot3(X(1,:),X(2,:),X(3,:),'.' ,'color', 'b', 'MarkerSize',4);
hold on
P1= [diag([1 1 1]) [0 0 0]'];
plotcams({P1});
plotcams({P2});
axis equal
hold off

x_1_n_f=x_1_n(:,inliers_idx);
x_2_n_f=x_2_n(:,inliers_idx);

save("ce2_result.mat", "X","P2","P1","x_1_n_f","x_2_n_f");


