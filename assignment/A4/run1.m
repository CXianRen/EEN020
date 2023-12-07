clear
close all
clc

addpath ./data/
addpath ./code/

load data/compEx1data.mat

img_1= imread("data/round_church1.jpg");
img_2 = imread("data/round_church2.jpg");

% normalize x with N1 and N2
x_1_n = inv(K) * x{1};
x_2_n = inv(K) * x{2};

%plot(x_1_n(1,:),x_1_n(2,:),'+');
%plot(x_2_n(1,:),x_2_n(2,:),'+');

%using all points
[M,U,S,V,E_n] = estimate_F_DLT(x_1_n,x_2_n);
bE_n = enforce_essential(E_n);

%plot(diag(x_2_n'*bE_n*x_1_n))

% compute the un_normalized fundamental matrix F
F = convert_E_to_F(bE_n,K,K);
F = F ./ F(3,3);

%plot(diag(x{2}'*F*x{1}));

% compute eRMS
% l1 , l2
erms = rms(sqrt((compute_epipolar_errors(F',x{2},x{1}).^2 + compute_epipolar_errors(F,x{1},x{2}).^2)/2))

% l1, image 1
epipolar_errors_l1 = compute_epipolar_errors(F',x{2},x{1});
mean_error_l1 = mean(epipolar_errors_l1)
histogram(epipolar_errors_l1,100);


% l2, image 2
epipolar_errors_l2 = compute_epipolar_errors(F,x{1},x{2});
mean_error_l2 = mean(epipolar_errors_l2)
histogram(epipolar_errors_l2,100);

% random 20 points 
l1 = F'*x{2};
l2 = F*x{1};

random_20_index = randperm(size(x{2},2),20);

imshow(img_1);
hold on
plot(x{1}(1,random_20_index),x{1}(2,random_20_index),'*');
rital(l1(:,random_20_index));
hold off

imshow(img_2);
hold on
plot(x{2}(1,random_20_index),x{2}(2,random_20_index),'*');
rital(l2(:,random_20_index));
hold off

imagesc([img_1 img_2]);
hold on
plot([x{1}(1,random_20_index); x{2}(1,random_20_index)+ size(img_1,2)], ...
     [x{1}(2,random_20_index); x{2}(2,random_20_index)], '-')
axis equal
hold off

%%%%%%% RANSAC %%%%%

[ransac_E,epsilon, inliers_idx] = estimate_E_robust(K,x_1_n,x_2_n);
ransac_F = convert_E_to_F(ransac_E,K,K);
ransac_F = ransac_F ./ ransac_F(3,3);
ransac_l1 = ransac_F'*x{2};
ransac_l2 = ransac_F*x{1};

%plot(diag(x{2}'*F*x{1}));

% compute eRMS
% l1 , l2
ransac_erms = rms(sqrt((compute_epipolar_errors(ransac_F',x{2},x{1}).^2 ...
                + compute_epipolar_errors(ransac_F,x{1},x{2}).^2)/2))

% l1, image 1
ransac_epipolar_errors_l1 = compute_epipolar_errors(ransac_F',x{2},x{1});
ransac_mean_error_l1 = mean(ransac_epipolar_errors_l1)
histogram(ransac_epipolar_errors_l1,100);

% l2, image 2
ransac_epipolar_errors_l2 = compute_epipolar_errors(ransac_F,x{1},x{2});
ransac_mean_error_l2 = mean(ransac_epipolar_errors_l2)
histogram(ransac_epipolar_errors_l2,100);


% plot 20 random inlier.
random_20_inlier_index = randperm(size(inliers_idx,2),20);
% img 2
imshow(img_2);
hold on
plot(x{2}(1,inliers_idx(1,random_20_inlier_index)),x{2}(2,inliers_idx(1,random_20_inlier_index)),'*');
rital(ransac_l2(:,inliers_idx(1,random_20_inlier_index)));
hold off
 

%%% debug %%%%
[P2,X]= get_P2_and_X_from_E(ransac_E,x_1_n(:,inliers_idx),x_2_n(:,inliers_idx));

plot3(X(1,:),X(2,:),X(3,:),'.' ,'color', 'b', 'MarkerSize',4);
hold on
plotcams({[diag([1 1 1]) [0 0 0]']});
plotcams({P2});
axis equal
hold off


