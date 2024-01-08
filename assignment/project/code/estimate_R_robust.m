function [best_E,best_H,inliers_idx] = estimate_R_robust(x1,x2,e_threshold,h_threshold)
%ESTIMATE_R_ROBUST Summary of this function goes here
% This function is for searching for E and H in parallel
% x1,x2 are normalized
% e_threshold: epipolar threshold
% h_threshold: homography threshold

alpha = 0.99;
% initial inliner fraction
epsilon_E = 0.1;
epsilon_H = 0.1;

% the size of subset should be?
sample_point_num = 8;
sample_point_num_H = 4;

update_T = @(epsilon) ceil(log10(1-alpha)/(log10(1-epsilon^sample_point_num)));
build_skew_m = @(t) [0 -t(3) t(2); t(3) 0 -t(1); -t(2) t(1) 0];

T = update_T(epsilon_E);

iteration_count = 0;
iteration_real_count = 0;
while iteration_count <= T %&& iteration_count < 1000
    iteration_count = iteration_count +1;
    iteration_real_count = iteration_real_count +1;

    %%%% first we estimate E %%%%
    random_index = randperm(size(x1,2),sample_point_num);
    
    [M,U,S,V,E_n] = estimate_F_DLT(x1(:,random_index),x2(:,random_index));
    bE_n = enforce_essential(E_n);
    
    errors_E = (compute_epipolar_errors(bE_n',x2,x1).^2 ...
        + compute_epipolar_errors(bE_n,x1,x2).^2)/2;
    
    
    inliners_E = errors_E< e_threshold^2;

    temp_inliners_idx_E = find(inliners_E > 0);
    
    inliners_number_E = size(temp_inliners_idx_E,2);
    
    n_epsilon_E = inliners_number_E / size(x1,2);
    if n_epsilon_E > epsilon_E
        % new best E
        epsilon_E = n_epsilon_E;
        best_E = bE_n;
        inliers_idx = temp_inliners_idx_E;
        T = update_T(epsilon_E);
        iteration_count = 0;
    end % if end 

    %%%% then estimate H %%%%
    random_index_H = randperm(size(x1,2),sample_point_num_H);
    
    H=estimate_H_DLT(x1(:,random_index_H),x2(:,random_index_H));
    y_h = pflat(H*x1);
    detal = y_h - x2;
    detal = detal.^2;
    errors_H = detal(1,:) + detal(2,:);

    inliners_H = errors_H< h_threshold^2;
    temp_inliners_idx_H = find(inliners_H > 0);
    inliners_number_H = size(temp_inliners_idx_H,2);
    n_epsilon_H = inliners_number_H / size(x1,2);

    if n_epsilon_H > epsilon_H
        % new best H
        % test new best H
        [R1,t1,R2,t2]=homography_to_RT(H,x1,x2);
        Rs={R1,R2};
        Ts={t1,t2};
        for i=1:2
            t = Ts{i};
            R = Rs{i};
            E = build_skew_m(t)* R;
            
            errors_E = (compute_epipolar_errors(E',x2,x1).^2 ...
                    + compute_epipolar_errors(E,x1,x2).^2)/2;
                 
            inliners_E = errors_E< e_threshold^2;
        
            temp_inliners_idx_E = find(inliners_E > 0);
            
            inliners_number_E = size(temp_inliners_idx_E,2);
            
            n_epsilon_E = inliners_number_E / size(x1,2);
            if n_epsilon_E > epsilon_E
                % new best E
                epsilon_E = n_epsilon_E;
                best_E = bE_n;
                inliers_idx = temp_inliners_idx_E;
                T = update_T(epsilon_E);
                iteration_count = 0;
                % update e
                epsilon_H = n_epsilon_H;
                best_H = H;
            end % if end 
        end
    end % if end 
end % while end 

end % function end

