function [best_E,epsilon,inliers_idx] = estimate_E_robust(K,x1,x2)
%ESTIMATE_E_ROBUST Summary of this function goes here

alpha = 0.99;
% initial inliner fraction
epsilon = 0.1;
% the size of subset should be?
sample_point_num = 8;
err_threshold_pix = 2;

update_T = @(epsilon) ceil(log10(1-alpha)/(log10(1-epsilon^sample_point_num)));

T = update_T(epsilon);

err_threshold = err_threshold_pix/K(1,1);
iteration_count = 0;
iteration_real_count = 0;
while iteration_count <= T %&& iteration_count < 1000
    iteration_count = iteration_count +1;
    iteration_real_count = iteration_real_count +1;

    random_index = randperm(size(x1,2),sample_point_num);
    % % debug 
    % imagesc([img_1 img_2]);
    % hold on
    % plot([x{1}(1,random_index); x{2}(1,random_index)+ size(img_1,2)], ...
    %      [x{1}(2,random_index); x{2}(2,random_index)], '-')
    % axis equal
    % hold off
    % % debug end 
    
    [M,U,S,V,E_n] = estimate_F_DLT(x1(:,random_index),x2(:,random_index));
    bE_n = enforce_essential(E_n);
    
    errors = (compute_epipolar_errors(bE_n',x2,x1).^2 ...
        + compute_epipolar_errors(bE_n,x1,x2).^2)/2;
    
    % debug 
    % histogram(errors,100);
    % debug
    
    inliners = errors< err_threshold^2;

    temp_inliners_idx = find(inliners > 0);
    
    inliners_number = size(temp_inliners_idx,2);
    
    n_epsilon = inliners_number / size(x1,2);
    if n_epsilon > epsilon
        epsilon = n_epsilon;
        best_E = bE_n;
        inliers_idx = temp_inliners_idx;
        T = update_T(epsilon);
        iteration_count = 0;
    end % if end 
end % while end 

end % function end

