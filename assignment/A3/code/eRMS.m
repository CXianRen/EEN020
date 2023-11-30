function error = eRMS(x1,x2)
%ERMS Summary of this function goes here
%   Detailed explanation goes here
    error = sqrt(norm(x2-x1,'fro').^2/size(x1,2));
end

