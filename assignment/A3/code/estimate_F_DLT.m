function [S,F] = estimate_F_DLT(x1s,x2s)
%ESTIMATE_F_DLT Summary of this function goes here
%   Detailed explanation goes here
    
    M=[];
    for i=1:size(x1s,2)
        M = [M; ...
            reshape(x2s(:,i)*x1s(:,i)',[1,9]); ...
            ];
    end 
    [U,S,V] = svd(M);
    F = reshape(V(:,end),[3,3]);
end

