function F = convert_E_to_F(E,K_1,K_2)
%CONVERT_E_TO_F Summary of this function goes here
%   Detailed explanation goes here
    F = inv(K_2)'*E*inv(K_1);
end

