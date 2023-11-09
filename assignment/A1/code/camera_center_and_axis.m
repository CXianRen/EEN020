function [center,principal_axis] = camera_center_and_axis(camera_p)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
P33=camera_p(1:3,1:3);
P4 = camera_p(:,4);
center = -inv(P33)*P4;
principal_axis = transpose(P33)*[0;0;1];
principal_axis = principal_axis/ norm(principal_axis);
end
