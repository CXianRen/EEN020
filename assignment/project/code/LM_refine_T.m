function [Pb,T] = LM_refine_T(P,xn,X)
%UNTITLED Summary of this function goes here
% x: normalized 
% X: homogenous
R = P(:,1:3);
t = P(:,4);
mu = 0.01;
while true
    % re-projection error
    diff = pflat([R t]*X)- xn;
    r = reshape(diff(1:2,:),[],1);
    % build Jacobian matrix
    J=[];
    for i = 1:size(xn,2)
        J=[J;
            (-P(3,:)*X(:,i)*[1 0 0]+P(1,:)*X(:,i)*[0 0 1])/(P(3,:)*X(:,i)).^2; ...
            (-P(3,:)*X(:,i)*[0 1 0]+P(2,:)*X(:,i)*[0 0 1])/(P(3,:)*X(:,i)).^2; ...
           ];
    end
    % compute update
    delta_T = -inv((J'*J+mu*eye(size(J,2))))*J'*r;
    %
    err= r'* r;
    diff = pflat([R t+delta_T]*X)- xn;
    rp = reshape(diff(1:2,:),[],1);
    err_p = rp' * rp;
    if err_p< err
       t = t + delta_T;
       mu = mu/10;
    else
       mu = mu*10;
    end

    if norm(delta_T) < 1e-10
        break
    end
end
Pb = [R t];
T = t;
end

