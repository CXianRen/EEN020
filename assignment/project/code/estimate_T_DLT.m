function T = estimate_T_DLT(R,x,X)
%ESTIMATE_T_DLT Summary of this function goes here
%  R, the rotation matrix we know
%  x and X, the correpsonding 2d-3d points.
    M = [];
    x1 = x(:,1);
    x2 = x(:,2);
    X1 = X(:,1);
    X2 = X(:,2);
    
    M =[  -1, 0 ,x1(1); ...
           0, -1,x1(2); ...
          -1,  0,x2(1); ...
           0, -1,x2(2)
    ];

    b = [ R(1,:)*X1-x1(1)* R(3,:)*X1; ...
          R(2,:)*X1-x1(2)* R(3,:)*X1; ...
          R(1,:)*X2-x2(1)* R(3,:)*X2; ...
          R(2,:)*X2-x2(2)* R(3,:)*X2];
% method 1
%     T = M\b;
% method 2
    M=[M -b];
    [~,~,V] = svd(M);
    v= V(:,end);
    if v(end) ~=1
        v = v/v(end);
    end
    T= v(1:3);
end
