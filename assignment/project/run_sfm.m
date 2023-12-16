clear
close all
clc

% set up environoment
addpath ../vlfeat-0.9.21;
addpath ../vlfeat-0.9.21/toolbox/;
vl_setup()

addpath ./data/
addpath ./code/

% read data set info
[K, img_names, init_pair, pixel_threshold] = get_dataset_info(2);

image_1 = imread(img_names{init_pair(1)});
image_2 = imread(img_names{init_pair(2)});

% extrac initial matched points
[x1,x2] = sfm(image_1,image_2);
% debug show all matched points.
perm = randperm(size(x1,2));
figure;
imagesc([image_1 image_2]);
hold on
end_idx = 100
plot([x1(1,perm(1:end_idx)); x2(1,perm(1:end_idx))+ size(image_1,2)], ...
     [x1(2,perm(1:end_idx)); x2(2,perm(1:end_idx))], '-')

axis equal
hold off
% debug 

% normalize x1,x2 with K.
x1_normalized = inv(K)*x1;
x2_normalized = inv(K)*x2;
% debug show normalized points 
figure 
subplot(1,2,1);
plot(x1_normalized(1,:),x1_normalized(2,:),'+');
axis equal
subplot(1,2,2);
plot(x2_normalized(1,:),x2_normalized(2,:),'+');
axis equal
% debug

[E, epsilon, inliers_idx] = estimate_E_robust(K,x1_normalized,x2_normalized);
F = convert_E_to_F(E,K,K);
F = F ./ F(3,3); % normalized F ensure F(3,3) = 1
epiploar_l1 = F'*x2;
epiploar_l2 = F*x1;

epsilon
inliers_size = size(inliers_idx,2)

%%% debug %%%%
[P2,X,P2s,Xs]= get_P2_and_X_from_E(E,x1_normalized(:,inliers_idx),x2_normalized(:,inliers_idx));
P1= [diag([1 1 1]) [0 0 0]'];

figure;
plot3(X(1,:),X(2,:),X(3,:),'.' ,'color', 'b', 'MarkerSize',4);
hold on
plotcams({P1});
plotcams({P2});
axis equal
hold off
