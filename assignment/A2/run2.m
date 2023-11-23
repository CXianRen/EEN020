clear
close all
clf
clc

addpath code
addpath data

load('compEx3data.mat');
img_cube_1 = imread('cube1.JPG');
img_cube_2 = imread('cube2.JPG');


% normalize the measured points
build_N = @(x_mean, x_std) [1/x_std(1,1)  0 -x_mean(1,1)/x_std(1,1); ...
                            0  1/x_std(2,1) -x_mean(2,1)/x_std(2,1); ...
                            0 0 1];
% x_1
x_1_mean = mean(x{1}(1:2,:),2)
x_1_std = std(x{1}(1:2,:), 0 ,2)
N_1  = build_N(x_1_mean,x_1_std);
x_1_normalized = N_1 *x{1};
% check the normalized result 
x_1_normalized_mean_check = mean(x_1_normalized(1:2,:),2)
x_1_normalized_std_check = std(x_1_normalized(1:2,:), 0 ,2)

% x_2
x_2_mean = mean(x{2}(1:2,:),2)
x_2_std = std(x{2}(1:2,:), 0 ,2)
N_2  = build_N(x_2_mean,x_2_std);
x_2_normalized = N_2 *x{2};
% check the normalized result 
x_2_normalized_mean_check  = mean(x_2_normalized(1:2,:),2)
x_2_normalized_std_check = std(x_2_normalized(1:2,:), 0 ,2)

%plot normalized points 
plot(x_1_normalized(1,:),x_1_normalized(2,:),'*' ,'color', 'b');
hold on 
plot(x_2_normalized(1,:),x_2_normalized(2,:),'o' ,'color', 'r');
axis equal
hold off
title("C2:normalized points, x{1} (BLUE), x{2}(RED)")
saveas(gcf,"c2_1.png");


% estimate  camera DLT 
% p1
% TODO should we use just only 6 points? or all points?
v_1 = estimate_camera_DLT(x_1_normalized(:,1:end),Xmodel(:,1:end));
v_1_T = v_1' % just to print v_1
P_1 =  reshape(v_1(1:12),[4,3])'
P_1_dN =  inv(N_1) * P_1
x_1_p = P_1_dN * [Xmodel;ones(1,size(Xmodel,2))];
% flatten
x_1_p=x_1_p ./ x_1_p(end,:);

figure;
imshow(img_cube_1);
hold on 
plot(x{1}(1,:), x{1}(2,:), 'o', 'color', 'y');
plot(x_1_p(1,:), x_1_p(2,:), '+', 'color', 'r');
axis equal
hold off
title("C2:measured points(x{1},(YELLOW)) and projective points(RED) with estimated P1")
saveas(gcf,"c2_2.png");

% p2
v_2 = estimate_camera_DLT(x_2_normalized(:,1:end),Xmodel(:,1:end));
v_2_T = v_2' % just to print v_1
P_2 =  reshape(v_2(1:12),[4,3])'
P_2_dN =  inv(N_2) * P_2
x_2_p = P_2_dN * [Xmodel;ones(1,size(Xmodel,2))];
% flatten
x_2_p=x_2_p ./ x_2_p(end,:);

figure;
imshow(img_cube_2);
hold on 
plot(x{2}(1,:), x{2}(2,:), 'o', 'color', 'y');
plot(x_2_p(1,:), x_2_p(2,:), '+', 'color', 'r');
axis equal
hold off
title("C2:measured points(x{2},(YELLOW)) and projective points(RED) with estimated P2")
saveas(gcf,"c2_3.png");


% plot cameras and 3d model points
figure;
plot3([Xmodel(1,startind); Xmodel(1,endind)], ...
      [Xmodel(2,startind); Xmodel(2,endind)], ...
      [Xmodel(3,startind); Xmodel(3,endind)], 'b-');
hold on
plotcams({P_1_dN, P_2_dN});
axis equal
hold off
title("C2:3D plot of cameras and model points")
saveas(gcf,"c2_4.png");


% compute the K
[K_1 R_1] = rq(P_1_dN);
[K_2 R_2] = rq(P_2_dN);


% save P_1 and P_2 for exercise 4
save("estimated_p.mat","P_1_dN","P_2_dN");


%Optional
eRMS = @(xp) sqrt(norm(x{1}-xp,'fro').^2/size(Xmodel,2));

% the eRMS , normalized points 
eRMS_normalized = eRMS(x_1_p);

% calculate P1 without noromalization
v_1_in = estimate_camera_DLT(x{1}(:,1:end),Xmodel(:,1:end));
P_1_in =  reshape(v_1_in(1:12),[4,3])';
x_1_in_p = P_1_in * [Xmodel;ones(1,size(Xmodel,2))];
% flatten
x_1_in_p=x_1_in_p ./ x_1_in_p(end,:);

% figure;
% imshow(img_cube_1);
% hold on 
% plot(x{1}(1,:), x{1}(2,:), 'o', 'color', 'y');
% plot(x_1_in_p(1,:), x_1_in_p(2,:), '+', 'color', 'r');
% axis equal
% hold off


eRMS_without_normalization =  eRMS(x_1_in_p);


point_idx = [1 4 13 16 25 28 31];
% P1 with 7 points and noromalization
v_1_7ps = estimate_camera_DLT(x_1_normalized(:,point_idx),Xmodel(:,point_idx));
P_1_7ps = reshape(v_1_7ps(1:12),[4,3])'
P_1_7ps_dN =  inv(N_1) * P_1_7ps
x_1_7ps_p = P_1_7ps_dN * [Xmodel;ones(1,size(Xmodel,2))];
% flatten
x_1_7ps_p=x_1_7ps_p ./ x_1_7ps_p(end,:);

% imshow(img_cube_1);
% hold on 
% plot(x{1}(1,:), x{1}(2,:), 'o', 'color', 'y');
% plot(x_1_7ps_p(1,:), x_1_7ps_p(2,:), '+', 'color', 'r');
% axis equal
% hold off

eRMS_7ps =  eRMS(x_1_7ps_p);


% P1 with 7 points and without noromalization
v_1_7ps_in = estimate_camera_DLT(x{1}(:,point_idx),Xmodel(:,point_idx));
P_1_7ps_in = reshape(v_1_7ps_in(1:12),[4,3])'
x_1_7ps_in_p = P_1_7ps_in * [Xmodel;ones(1,size(Xmodel,2))];
% flatten
x_1_7ps_in_p=x_1_7ps_in_p ./ x_1_7ps_in_p(end,:);

% imshow(img_cube_1);
% hold on 
% plot(x{1}(1,:), x{1}(2,:), 'o', 'color', 'y');
% plot(x_1_7ps_in_p(1,:), x_1_7ps_in_p(2,:), '+', 'color', 'r');
% axis equal
% hold off

eRMS_7ps_in =  eRMS(x_1_7ps_in_p);

% to show all eRMS
eRMS_normalized
eRMS_without_normalization
eRMS_7ps
eRMS_7ps_in
