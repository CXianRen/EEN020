function [R,T] = step_1(image_1,image_2,K)
%STEP_1 Summary of this function goes here
%   Detailed explanation goes here
%figure
% extrac initial matched points
[x1,x2] = sfm(image_1,image_2);
% debug show all matched points.
% perm = randperm(size(x1,2));
% subplot(2,2,1)
% imagesc([image_1 image_2]);
% hold on
% end_idx = 100
% plot([x1(1,perm(1:end_idx)); x2(1,perm(1:end_idx))+ size(image_1,2)], ...
%      [x1(2,perm(1:end_idx)); x2(2,perm(1:end_idx))], '-')
% 
% axis equal
% hold off
% debug 

% normalize x1,x2 with K.
x1_normalized = inv(K)*x1;
x2_normalized = inv(K)*x2;
% debug show normalized points 
% subplot(2,2,3)
% plot(x1_normalized(1,:),x1_normalized(2,:),'+');
% axis equal
% subplot(2,2,4)
% plot(x2_normalized(1,:),x2_normalized(2,:),'+');
% axis equal
% debug

[E, epsilon, inliers_idx] = estimate_E_robust(K,x1_normalized,x2_normalized);
%F = convert_E_to_F(E,K,K);
%F = F ./ F(3,3); % normalized F ensure F(3,3) = 1

%%% debug %%%%
[P2,X,P2s,Xs]= get_P2_and_X_from_E(E,x1_normalized(:,inliers_idx),x2_normalized(:,inliers_idx));
P1= [diag([1 1 1]) [0 0 0]'];

% subplot(2,2,2)
% figure
% plot3(X(1,:),X(2,:),X(3,:),'.' ,'color', 'b', 'MarkerSize',4);
% hold on
% plotcams({P1,P2});
% axis equal
% hold off

R = P2(:,1:3);
T = P2(:,4);
end

