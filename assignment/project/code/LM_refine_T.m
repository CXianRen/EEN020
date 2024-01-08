function [Pb,T] = LM_refine_T(P,xn,X)
%UNTITLED Summary of this function goes here
% x: normalized 
% X: homogenous
R = P(:,1:3);
t = P(:,4);
mu = 0.01;

diff = xn - pflat([R t]*X);
% error before optimization
rb = reshape(diff(1:2,:),[],1);
while true
    % re-projection error
    diff = xn- pflat([R t]*X) ;
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
    diff = xn - pflat([R t+delta_T]*X);
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
% error after optimization
diff = xn-pflat([R t]*X);
ra = reshape(diff(1:2,:),[],1);
fprintf("error before: %d, after: %d , mu is: %d \n", rb'* rb, ra'* ra, mu);
end

