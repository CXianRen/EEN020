function N = buildN(x)
%BUILDN Summary of this function goes here
% input x, the points need to be normalized
%   Detailed explanation goes here
x_mean = mean(x(1:2,:),2);
x_std = std(x(1:2,:),0,2);

N = [1/x_std(1,1) 0 -x_mean(1,1)/x_std(1,1); ...
     0 1/x_std(2,1) -x_mean(2,1)/x_std(2,1); ...
     0 0 1; ...
    ];
end

