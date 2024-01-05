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

image_1 = imread(img_names{2});
image_2 = imread(img_names{3});

[x1,x2] = sfm(image_1,image_2);
x1_n = inv(K) * x1;
x2_n = inv(K) * x2;
[best_H,epsilon,inliers_idx] = estimate_H_DLT_robust(x1,x2,K);
[R1,t1,R2,t2]=homography_to_RT(best_H,x1_n,x2_n);

tx2= best_H*x1_n(:,inliers_idx);
tx2= pflat(tx2);
tx2 = K * tx2;

figure;
subplot(1,2,1);
imshow(image_1);
hold on
plot(x1(1,inliers_idx),x1(2,inliers_idx),'*', Color='r')
hold off 
subplot(1,2,2);
imshow(image_2);
hold on
plot(x2(1,inliers_idx),x2(2,inliers_idx),'+', Color='r')

plot(tx2(1,:),tx2(2,:),'o', Color='g')
hold off