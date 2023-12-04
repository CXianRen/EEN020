clear
close all
clc

addpath ./data/
addpath ./code/

load data/compEx1data.mat
load data/compEx2data.mat

img_1= imread("data/kronan1.JPG");
img_2 = imread('data/kronan2.JPG');


N_1 = inv(K)
N_2 = inv(K)

% N_1 = buildN(x{1})
% N_2 = buildN(x{2})


% 
% % normalize x with N1 and N2
x_1_n = N_1 * x{1};
x_2_n = N_2 * x{2};

% debug code start
mean_before = mean(x{1}(1:2,:),2)
mean_after = mean(x_1_n(1:2,:),2)
% debug code end

[M,U,S,V,E_n] = estimate_F_DLT(x_1_n,x_2_n);
% the minimal singular value of M
minimum_s = S(9:9)

% check |Mv|
sqare_norm_Mv= norm(M*V(:,end)).^2

det_E_n = det(E_n)

bE_n = enforce_essential(E_n);
%bE_n = enforce_fundamental(E_n);

det_bE_n = det(bE_n)

plot(diag(x_2_n'*bE_n*x_1_n));
title("C2:x_{2_n}E_n'x_{1_n}");
saveas(gcf,"c2_1.png");

% compute the un_normalized fundamental matrix F
F = convert_E_to_F(bE_n,K,K);
F = F ./ F(3,3)
plot(diag(x{2}'*F*x{1}));
title("C2:x_{2}F'x_{1}");
saveas(gcf,"c2_2.png");

l = F*x{1};

random_index = randperm(size(x{2},2),20);
imshow(img_2)
hold on
plot(x{2}(1,random_index),x{2}(2,random_index), '*', 'Color','r');
rital(l(:,random_index));
hold off
title("C2:random 20 points and epipolar lines");
saveas(gcf,"c2_3.png");

% compute error and plot in a historgram
errors_n = compute_epipolar_errors(F,x{1},x{2});

mean_error_n = mean(errors_n)
hist(errors_n,100);
title("C2: distance between all the points and their corresponding epipolar lines");
saveas(gcf,"c2_4.png");

save("bE_n.mat","bE_n");
