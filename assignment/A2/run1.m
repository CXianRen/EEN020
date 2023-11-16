clc
clear

addpath code
addpath data

load('compEx1data.mat')


% (1) plot X and all camera 
plot3(X(1,:),X(2,:),X(3,:),'.', 'Markersize',2);
hold on 

plotcams(P);
axis equal
saveas(gcf,"c1_1.png");
hold off

% (2) plot img_1 and projected X on P1 (x1_p = P1X) and x1
img_1 = imread(imfiles{1});
p1 = P{1};
x1_idx = isfinite(x{1}(1,:));
x1_p = p1*X;
% flatten x1_p
x1_p_f = x1_p ./ x1_p(end,:);

imshow(img_1);
hold on 
plot(x1_p_f(1,x1_idx), x1_p_f(2,x1_idx),'+' ,'color', 'r', 'Markersize',4);
plot(x{1}(1,x1_idx), x{1}(2,x1_idx), 'o', 'color', 'b', 'Markersize', 4);
axis equal
saveas(gcf,"c1_2.png");
hold off

% (3) plot TX and Pinv(T) 
T1= [1 0 0 0; 0 3 0 0; 0 0 1 0; 1/8 1/8 0 1]
T2= [1 0 0 0; 0 1 0 0; 0 0 1 0; 1/16 1/16 0 1]
X1= T1*X;
X2= T2*X;
% flatten X1 X2
X1_f = X1 ./ X1(end,:);
X2_f = X2 ./ X2(end,:);

Pt1 = cell(1,length(P));
Pt2 = cell(1,length(P));
for i = 1:length(P)
    Pt1{i} = P{i}*inv(T1);
    Pt2{i} = P{i}*inv(T2);
end

% original X , T1X and P1t1
%plot3(X(1,:),X(2,:),X(3,:),'+', 'Markersize',2, 'color', 'b');
plot3(X1_f(1,:),X1_f(2,:),X1_f(3,:),'+', 'Markersize',2, 'color', 'r');
hold on 
plotcams(Pt1);
axis equal
saveas(gcf,"c1_T1.png");
hold off 

plot3(X2_f(1,:),X2_f(2,:),X2_f(3,:),'+', 'Markersize',2, 'color', 'g');
hold on 
plotcams(Pt2);
axis equal
saveas(gcf,"c1_T2.png");
hold off 

% (4) 
% plot 1st img with T1X  and Pt1_1*T1X 
hold on
plot(x{1}(1,x1_idx), x{1}(2,x1_idx), 'o', 'color', 'b', 'Markersize', 3);
project_and_plot(Pt1{1}, X1_f(:,x1_idx),imread(imfiles{1}));
saveas(gcf,"c1_4_T1.png");
hold off

% plot 1st img with T2X  and Pt2_1*T1X 
hold on
plot(x{1}(1,x1_idx), x{1}(2,x1_idx), 'o', 'color', 'b', 'Markersize', 3);
project_and_plot(Pt2{1}, X2_f(:,x1_idx),imread(imfiles{1}));
saveas(gcf,"c1_4_T2.png");
hold off





