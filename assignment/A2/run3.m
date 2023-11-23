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

img_cube1 = imread("data/cube1.JPG");
img_cube2 = imread("data/cube2.JPG");

[f1 d1] = vl_sift(single(rgb2gray(img_cube1)), 'PeakThresh', 1);

[f2 d2] = vl_sift(single(rgb2gray(img_cube2)), 'PeakThresh', 1);

imshow(img_cube1)
hold on 
vl_plotframe(f1);
axis equal
hold off

[matches, scores] = vl_ubcmatch(d1,d2);

x1 = [f1(1,matches(1,:)); f1(2,matches(1,:))];
x2 = [f2(1,matches(2,:)); f2(2,matches(2,:))];


perm = randperm(size(matches,2));
figure;
imagesc([img_cube1 img_cube1]);
hold on
end_idx = 10
plot([x1(1,perm(1:end_idx)); x2(1,perm(1:end_idx))+ size(img_cube1,2)], ...
     [x1(2,perm(1:end_idx)); x2(2,perm(1:end_idx))], '-')

axis equal
hold off


% save matches point
save("matched_points.mat", "x1","x2");
