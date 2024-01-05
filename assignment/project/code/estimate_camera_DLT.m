function P = estimate_camera_DLT(x,X)
% ESTIMATE_CAMERA_DLT Summary of this function goes here
%   input X is not in homography coordinate.

% TODO improve the code for better performance!.
    M = [];
    for i = 1:size(x,2)
        M = [M; ...
            X(:,i)' 1 0 0 0 0 -x(1,i)*[X(:,i)' 1]; ...
            0 0 0 0 X(:,i)' 1 -x(2,i)*[X(:,i)' 1];];
    end
    [U,S,V] = svd(M);
    v= V(:,end);
    P = reshape(v,[4,3])';
end

