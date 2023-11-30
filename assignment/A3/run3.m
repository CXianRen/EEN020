clear
close all
clc

addpath ./data/
addpath ./code/

load data/compEx1data.mat
load data/compEx2data.mat
% load E we get from run2.m
load bE_n.mat

img_1= imread("data/kronan1.JPG");
img_2 = imread('data/kronan2.JPG');

x_1_n = inv(K)*x{1};
x_2_n = inv(K)*x{2};

% x_1_n = x{1};
% x_2_n = x{2};

P_2s = extract_P_from_E(bE_n);

P_1 = [diag([1 1 1]) [0 0 0]']

P_2 = P_2s{4};
X = [];
for i= 1: size(x_1_n,2)
    X_i = triangulate_3D_point_DLT(x_1_n(:,i),x_2_n(:,i),P_1,P_2);
    X = [X X_i];
end
X=pflat(X);

plot3(X(1,:),X(2,:),X(3,:),'.' ,'color', 'g', 'MarkerSize',4);
hold on
plotcams({P_1});
plotcams({P_2});
hold off
axis equal


P_2_dn= K*P_2;
project_and_plot(P_2_dn,X,img_2);
hold on
plot(x{2}(1,1:end),x{2}(2,1:end), 'o', 'Color','b');
hold off

errors=eRMS(pflat(P_2_dn*X),x{2})
