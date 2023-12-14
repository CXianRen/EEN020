clear
close all
clf
clc


% set up environoment
addpath ../vlfeat-0.9.21;
addpath ../vlfeat-0.9.21/toolbox/;
vl_setup()

addpath data
addpath code 

img_1 = imread("data/fountain1.png");
img_2 = imread("data/fountain2.png");

% img_1 = imread("data/test1.jpg");
% img_2 = imread("data/test2.jpg");

[f1 d1] = vl_sift(single(rgb2gray(img_1)), 'PeakThresh', 1);
[f2 d2] = vl_sift(single(rgb2gray(img_2)), 'PeakThresh', 1);

f1_size = size(f1,2)
f2_size = size(f2,2)

% debug
imshow(img_1)
hold on 
vl_plotframe(f1);
axis equal
hold off
%

[matches, scores] = vl_ubcmatch(d1,d2);

matches_size = size(matches)

x1 = [f1(1,matches(1,:)); f1(2,matches(1,:))];
x2 = [f2(1,matches(2,:)); f2(2,matches(2,:))];

% debug
perm = randperm(size(matches,2));
figure;
imagesc([img_1 img_1]);
hold on
end_idx = 100
plot([x1(1,perm(1:end_idx)); x2(1,perm(1:end_idx))+ size(img_1,2)], ...
     [x1(2,perm(1:end_idx)); x2(2,perm(1:end_idx))], '-')

axis equal
hold off
% debug 

% save matches point
save("matched_points.mat", "x1","x2");