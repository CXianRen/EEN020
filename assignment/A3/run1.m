clear
close all
clc

addpath ./data/
addpath ./code/

load data/compEx1data.mat

img_1= imread("data/kronan1.JPG");
img_2 = imread('data/kronan2.JPG');


% with normalization
% % Part 1 start 
N_1 = buildN(x{1})
N_2 = buildN(x{2})
flag_str = ""
% Part 1 end

% without normalization
% Part 2 start 
% N_1 = [1 0 0; 0 1 0; 0 0 1];
% N_2 = [1 0 0; 0 1 0; 0 0 1];
% flag_str = "-P2"
% Part 2 end

% normalize x with N1 and N2
x_1_n = N_1 * x{1};
x_2_n = N_2 * x{2};

% debug code start
mean_before = mean(x{1}(1:2,:),2)
mean_after = mean(x_1_n(1:2,:),2)
% debug code end

[M,U,S,V,F_n] = estimate_F_DLT(x_1_n,x_2_n);
% the minimal singular value of M
minimum_s = S(9:9)

det_F_n = det(F_n)

bF_n = enforce_fundamental(F_n);
% make bF_n(3,3) = 1
bF_n = bF_n ./bF_n(3,3)

det_bF_n = det(bF_n)

% check y'Fx=0
plot(diag(x_2_n'*bF_n*x_1_n));
title("C1:x_{2_n}F_n'x_{1_n}" + flag_str);
saveas(gcf,"c1_1" + flag_str + ".png");

% compute the un_normalized fundamental matrix F
F = N_2'*bF_n*N_1;
F = F ./ F(3,3)
plot(diag(x{2}'*F*x{1}));
title("C1:x_{2}F'x_{1}" + flag_str);
saveas(gcf,"c1_2"+ flag_str +".png");

l = F*x{1};
%l = l./sqrt(repmat(l(1,:).^2 +l(2,:).^2,[3 1]));

random_index = randperm(size(x{2},2),20);
imshow(img_2)
hold on
plot(x{2}(1,random_index),x{2}(2,random_index), ...
    '.', 'Color','r', 'MarkerSize',20);
rital(l(:,random_index));
hold off
title("C1:random 20 points and epipolar lines" + flag_str);
saveas(gcf,"c1_3"+ flag_str+".png");

% compute error and plot in a historgram
errors_n = compute_epipolar_errors(F,x{1},x{2});

% mean error (distance)
mean_error_n = mean(errors_n)
hist(errors_n,100);
title("C1: distance between all the points and their corresponding epipolar lines" + flag_str);
saveas(gcf,"c1_4"+ flag_str +".png");

