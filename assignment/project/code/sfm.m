function [x1,x2] = sfm(img_1,img_2)
%SFM Summary of this function goes here
%   Detailed explanation goes here
[f1 d1] = vl_sift(single(rgb2gray(img_1)), 'PeakThresh', 1);
[f2 d2] = vl_sift(single(rgb2gray(img_2)), 'PeakThresh', 1);


% debug
% imshow(img_1)
% hold on 
% vl_plotframe(f1);
% axis equal
% hold off
%

[matches, scores] = vl_ubcmatch(d1,d2);

% return extended x

x1 = [f1(1,matches(1,:)); f1(2,matches(1,:)); ones(1,size(f1(2,matches(1,:)),2))];
x2 = [f2(1,matches(2,:)); f2(2,matches(2,:)); ones(1,size(f2(2,matches(2,:)),2))];

end

