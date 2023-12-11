function delta_X_j = ComputeUpdate(r,J,mu)
%COMPUTEUPDATE Summary of this function goes here
   delta_X_j = -inv((J'*J+mu*eye(size(J,2))))*J'*r;
end

