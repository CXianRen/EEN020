function [H] = estimate_H_DLT(xs,ys)
    % ESTIMIATE_H_DLT
    % xs and ys should be in homography cooridination,
    % and normalized!

    % lecture 4, PPT page 15/47
    % given x = P1*X, y = P2*X,
    % then X = inv(P1)*x
    % y = P2* inv(P1)*x = H *x
    % cross(y,H*x) = 0
    M=zeros(2*size(xs,2),9);
    for i = 1:size(xs,2)
      x = xs(:,i);
      y = ys(:,i);
      M(2*i-1,:)= [x' 0 0 0 -y(1)*x' ];
      M(2*i,:)=   [0 0 0 x' -y(2)*x' ];
    end
  
    [U,S,V] = svd(M);
    v= V(:,end);
    H = reshape(v,[3,3])';
end

