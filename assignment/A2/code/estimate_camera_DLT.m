function v = estimate_camera_DLT(x,X)
%ESTIMATE_CAMERA_DLT Summary of this function goes here
%   Detailed explanation goes here
    M = [];
    for i = 1:size(x,2)
        M= [M; ...
            X(:,i)' 1 0 0 0 0 -x(1,i)*[X(:,i)' 1]; ...
            0 0 0 0 X(:,i)' 1 -x(2,i)*[X(:,i)' 1];];
    end
    [U,S,V] = svd(M);
    v= V(:,end);
    % show the ||Mv||
    norm_Mv =  (M*v)'*M*v
    norm_v = v'*v
    % show the sigular value
    sigluars = diag(S)'
end

