function [P_2,X, P_2s, Xs] = get_P2_and_X_from_E(E,x_1_n,x_2_n)
%GET_P2_X_FROM( Summary of this function goes here

P_1 = [diag([1 1 1]) [0 0 0]'];

best_P2_idx = 1;
best_point_count = 0;

P_2s = extract_P_from_E(E);
for Pi=1:size(P_2s,2)
    X = [];
    for i= 1: size(x_1_n,2)
        X_i = triangulate_3D_point_DLT(x_1_n(:,i),x_2_n(:,i),P_1,P_2s{Pi});
        X = [X X_i];
    end
    X=pflat(X);
    Xs{Pi} = X;
    % evaluate P2
    x1 = P_1 * X;
    x2 = P_2s{Pi} *X;
    temp_postive_count = sum(x1(3,:)>0) + sum(x2(3,:)>0);
    if  temp_postive_count > best_point_count
        best_point_count = temp_postive_count;
        best_P2_idx = Pi;
    end 
end

P_2 = P_2s{best_P2_idx};
% re compute the X after we have the best P_2
% X = [];
% for i= 1: size(x_1_n,2)
%     X_i = triangulate_3D_point_DLT(x_1_n(:,i),x_2_n(:,i),P_1,P_2);
%     X = [X X_i];
% end
% X=pflat(X);
X=Xs{best_P2_idx};
end

