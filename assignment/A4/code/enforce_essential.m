function bE = enforce_essential(E)
%ENFORCE_FUNDAMENTAL Summary of this function goes here
%   Detailed explanation goes here
    [U,S,V] = svd(E);
    if det(U*V') < 0
        V=-V;
    end 
    bE= U*diag([1 1 0])*V';
end

