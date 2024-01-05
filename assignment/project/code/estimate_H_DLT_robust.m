function [best_H,epsilon,inliers_idx] = estimate_H_DLT_robust(x1,x2,K)
%ESTIMATE_H_ROBUST Summary of this function goes here
% estimate H with RANSAC 
% RANSAC config 
alpha = 0.99;
% initial inliner fraction
epsilon = 0.1;
% the size of subset should be?
sample_point_num = 4;
err_threshold_pixel = 2;
%

x1 = inv(K)*x1;
x2 = inv(K)*x2;

update_T = @(epsilon) ceil(log10(1-alpha)/(log10(1-epsilon^sample_point_num)));
T = update_T(epsilon);
err_threshold = err_threshold_pixel/K(1,1);

iteration_count = 0;
iteration_real_count = 0;
while iteration_count <= T %&& iteration_count < 1000
    iteration_count = iteration_count +1;
    iteration_real_count = iteration_real_count +1;

    random_index = randperm(size(x1,2),sample_point_num);
    
    H=estimate_H_DLT(x1(:,random_index),x2(:,random_index));
    y_h = pflat(H*x1);
    
    detal = y_h - x2;
    detal = detal.^2;
    errors = detal(1,:) + detal(2,:);
    
    % debug 
    % histogram(errors,100);
    % debug
    inliners = errors< err_threshold^2;

    temp_inliners_idx = find(inliners > 0);
    
    inliners_number = size(temp_inliners_idx,2);
    
    n_epsilon = inliners_number / size(x1,2);
    if n_epsilon > epsilon
        epsilon = n_epsilon;
        best_H = H;
        inliers_idx = temp_inliners_idx;
        T = update_T(epsilon);
        iteration_count = 0;
    end % if end 
end % while end 
end

