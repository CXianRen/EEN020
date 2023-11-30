function bE = enforce_essential(E)
%ENFORCE_FUNDAMENTAL Summary of this function goes here
%   Detailed explanation goes here
    [U,S,V] = svd(E);
    s= (S(1,1)+S(2,2))/2;
    S= diag([s s 0]);
    if det(U*V') < 0
        V=-V;
    end 
    bE= U*S*V';
end

