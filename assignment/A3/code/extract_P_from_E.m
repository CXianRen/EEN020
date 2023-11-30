function P2cell = extract_P_from_E(E)
%EXTRACT_P_FROM_E Summary of this function goes here
%   Detailed explanation goes here
    [U S V] = svd(E);
    if det(U*V') < 0
        V=-V;
    end 
    u_3 = U(:,3);
    W=[0 -1 0; 1 0 0; 0 0 1;];
    P1=[U*W*V' u_3];
    P2=[U*W*V' -u_3];
    P3=[U*W'*V' u_3];
    P4=[U*W'*V' -u_3];
    P2cell = {P1,P2,P3,P4};
end

