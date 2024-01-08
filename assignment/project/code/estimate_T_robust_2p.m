function [best_P,inliers_idx] = estimate_T_robust_2p(xn,X,K,R,err_threshold)
%ESTIMATE_T_ROBUST. Summary of this function goes here
% inpute xn is normalized.

% RANSAC config 
alpha = 0.99;
% initial inliner fraction
epsilon = 0.1;
% the size of subset should be?
sample_point_num = 2;
% err_threshold_pixel = 3;

update_T = @(epsilon) ceil(log10(1-alpha)/(log10(1-epsilon^sample_point_num)));
T = update_T(epsilon);
% err_threshold = err_threshold_pixel/K(1,1);

iteration_count = 0;
iteration_real_count = 0;
while iteration_count <= T %&& iteration_count < 1000
    iteration_count = iteration_count +1;
    iteration_real_count = iteration_real_count +1;

    random_index = randperm(size(xn,2),sample_point_num);
    
    t=estimate_T_DLT(R,xn(:,random_index),X(:,random_index));
    P = [R t];
    y_h = pflat(P * [X;ones(1,size(X,2))]);
    
    detal = y_h - xn;
    detal = detal.^2;
    errors = detal(1,:) + detal(2,:);
    
%     debug 
%     histogram(errors,100);
%     debug

    inliners = errors< err_threshold^2;

    temp_inliners_idx = find(inliners > 0);
    
    inliners_number = size(temp_inliners_idx,2);
    
    n_epsilon = inliners_number / size(xn,2);
    if n_epsilon > epsilon
        epsilon = n_epsilon;
        best_P = P;
        inliers_idx = temp_inliners_idx;
        T = update_T(epsilon);
        iteration_count = 0;
    end % if end 
end % while end 
end
