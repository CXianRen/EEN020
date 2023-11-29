function bF = enforce_fundamental(F)
%ENFORCE_FUNDAMENTAL Summary of this function goes here
%   Detailed explanation goes here
    [U,S,V] = svd(F);
    S(3,3) = 0;
    bF= U*S*V';
end

