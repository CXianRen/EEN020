function [R,T,best_X, inliers_idx] = estimate_R_robust( ...
    x1,x2,e_threshold,h_threshold)
%ESTIMATE_R_ROBUST Summary of this function goes here
% This function is for searching for E and H in parallel
% x1,x2 are normalized
% e_threshold: epipolar threshold
% h_threshold: homography threshold

alpha = 0.99;
% initial inliner fraction
epsilon_e = 0.1;
epsilon_h = 0.1;
% the size of subset should be?
sample_point_num_e = 8;
sample_point_num_h = 4;

update_T = @(epsilon,sample_point_num) ceil(log10(1-alpha)/(log10(1-epsilon^sample_point_num)));
build_skew_m = @(t) [0 -t(3) t(2); t(3) 0 -t(1); -t(2) t(1) 0];

T_e = update_T(epsilon_e,sample_point_num_e);
T_h = update_T(epsilon_h,sample_point_num_h);

iteration_count_e = 0;
iteration_count_h = 0;

update_flag = 0;
while iteration_count_e <= T_e || iteration_count_h <= T_h
    if iteration_count_e <= T_e
        iteration_count_e = iteration_count_e +1;   
        random_index = randperm(size(x1,2),sample_point_num_e);
    
        [~,~,~,~,E_n] = estimate_F_DLT( ...
            x1(:,random_index),x2(:,random_index));
        bE_n = enforce_essential(E_n);
        
        errors_e = (compute_epipolar_errors(bE_n',x2,x1).^2 ...
            + compute_epipolar_errors(bE_n,x1,x2).^2)/2;
        
        inliners_e = errors_e< e_threshold^2;
    
        temp_inliners_idx_e = find(inliners_e > 0);
        
        inliners_number_e = size(temp_inliners_idx_e,2);
        
        n_epsilon_e = inliners_number_e / size(x1,2);
        if n_epsilon_e > epsilon_e
            epsilon_e = n_epsilon_e;
            best_E = bE_n;
            inliers_idx = temp_inliners_idx_e;
            T_e = update_T(epsilon_e,sample_point_num_e);
            iteration_count_e = 0;
            [P2,best_X,~,~,best_count]= get_P2_and_X_from_E( ...
                best_E,x1(:,inliers_idx),x2(:,inliers_idx));

            R= P2(:,1:3);
            T= P2(:,4);
            update_flag = 0;
        end % if end 
    end % E iteration if end

    % estimate H
    if iteration_count_h <= T_h
       iteration_count_h = iteration_count_h +1;
       random_index = randperm(size(x1,2),sample_point_num_h);
       H=estimate_H_DLT(x1(:,random_index),x2(:,random_index));
       y_h = pflat(H*x1); 
       detal = y_h - x2;
       detal = detal.^2;
       errors = detal(1,:) + detal(2,:);

       inliners_h = errors< h_threshold^2;
       temp_inliners_idx_h = find(inliners_h > 0);
        
       inliners_number_h = size(temp_inliners_idx_h,2);
        
       n_epsilon_h = inliners_number_h / size(x1,2);
       if n_epsilon_h > epsilon_h
           % new best H
           % extract R and T from H
            [R1,t1,R2,t2]=homography_to_RT(H,x1,x2);
            E1 = build_skew_m(t1) * R1;
            E1 = enforce_essential(E1);
            [P2_1,X_1,~,~,count_1]= get_P2_and_X_from_E( ...
                E1,x1(:,temp_inliners_idx_h),x2(:,temp_inliners_idx_h));
    
            E2 = build_skew_m(t2) * R2;
            E2 = enforce_essential(E2);
            [P2_2,X_2,~,~,count_2]= get_P2_and_X_from_E( ...
                E2,x1(:,temp_inliners_idx_h),x2(:,temp_inliners_idx_h));
            
%             subplot(121);
%             plot3(X_1(1,:),X_1(2,:),X_1(3,:),'.');
%             subplot(122);
%             plot3(X_2(1,:),X_2(2,:),X_2(3,:),'.');

            % which R from H is better 
            best_h_E = E1;
            best_h_P = P2_1;
            if count_2 > count_1
                best_h_E = E2;
                best_h_P = P2_2;
            end

            R= best_h_P(:,1:3);
            T= best_h_P(:,4); 
           
            errors_e_h = (compute_epipolar_errors(best_h_E',x2,x1).^2 ...
                + compute_epipolar_errors(best_h_E,x1,x2).^2)/2;
    
            inliners_e_h = errors_e_h< e_threshold^2;
        
            temp_inliners_idx_e_h = find(inliners_e_h > 0);
            
            inliners_number_e_h = size(temp_inliners_idx_e_h,2);
            
            n_epsilon_e_h = inliners_number_e_h / size(x1,2);

%             E from H is better
            if n_epsilon_e_h > epsilon_e
                epsilon_e = n_epsilon_e_h;
                best_E = best_h_E;
                inliers_idx = temp_inliners_idx_e_h;
                T_e = update_T(epsilon_e,sample_point_num_e);
                iteration_count_e = 0;
                [P2,best_X,~,~,best_count]= get_P2_and_X_from_E( ...
                    best_E,x1(:,inliers_idx),x2(:,inliers_idx));
                R= P2(:,1:3);
                T= P2(:,4);  
                update_flag = 1;
            end

            epsilon_h = n_epsilon_h;
%             best_H = H;
%             inliers_idx_h = temp_inliners_idx;
            T_h = update_T(epsilon_h,sample_point_num_h);
            iteration_count_h = 0;
        end % if end 
    end

end % while end 
if update_flag == 1
    fprintf("R from H\n");
else 
    fprintf("R from E\n");
end

%    debug 
% figure
% plot3(best_X(1,:),best_X(2,:),best_X(3,:),'.');
% hold on;
% plotcams({[1 0 0 0; 0 1 0 0; 0 0 1 0],[R T]});
% hold off;
% axis equal;

end % function end

