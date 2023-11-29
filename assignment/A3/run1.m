clear
close all
clc

addpath ./data/
addpath ./code/

load data/compEx1data.mat

img_1= imread("data/kronan1.JPG");
img_2 = imread('data/kronan2.JPG');


% with normalization

% N_1 = buildN(x{1})
% N_2 = buildN(x{2})

% without normalization
N_1 = [1 0 0; 0 1 0; 0 0 1];
N_2 = [1 0 0; 0 1 0; 0 0 1];

% normalize x with N1 and N2
x_1_n = N_1 * x{1};
x_2_n = N_1 * x{1};

% debug code start
mean_before = mean(x{1}(1:2,:),2)
mean_after = mean(x_1_n(1:2,:),2)
% debug code end

[S,F_n] = estimate_F_DLT(x_1_n,x_2_n);
% the minimal singular value of M
minimum_s = S(9:9)

det_F_n = det(F_n)

bF_n = enforce_fundamental(F_n);

det_bF_n = det(bF_n)

plot(diag(x_2_n'*bF_n*x_1_n));
title("C1:x_{2_n}F_n'x_{1_n}");
saveas(gcf,"c1_1.png");

% compute the un_normalized fundamental matrix F
F = N_2'*bF_n*N_1
plot(diag(x{2}'*F*x{1}));
title("C1:x_{2}F'x_{1}");
saveas(gcf,"c1_2.png");

l = F*x{1};
%l = l./sqrt(repmat(l(1,:).^2 +l(2,:).^2,[3 1]));

random_index = randperm(size(x{2},2),20);
imshow(img_2)
hold on
plot(x{2}(1,random_index),x{2}(2,random_index), '*', 'Color','r');
rital(l(:,random_index));
hold off
title("C1:random 20 points and epipolar lines");
saveas(gcf,"c1_3.png");

% compute error and plot in a historgram
errors_n = compute_epipolar_errors(F,x{1},x{2});

mean_error_n = mean(errors_n)
hist(errors_n,100);
title("C1: distance between all the points and their corresponding epipolar lines");
saveas(gcf,"c1_4.png");

