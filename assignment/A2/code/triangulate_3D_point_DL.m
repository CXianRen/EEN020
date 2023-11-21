function X = triangulate_3D_point_DL(x1,x2,P1,P2)
%TRIANGULATE_3D_POINT_DL Summary of this function goes here
    % build M
    M = [
        P1(1,:) - x1(1)*P1(3,:); ...
        P1(2,:) - x1(2)*P1(3,:); ...
        P2(1,:) - x2(1)*P2(3,:); ...
        P2(2,:) - x2(2)*P2(3,:);
        ];
    % SVD 
    [U,S,V] = svd(M);
    X= V(:,end);

    % show the ||MX||, for debug
%     norm_M =  (M*X)'*M*X
%     norm_X = X'*X
end

