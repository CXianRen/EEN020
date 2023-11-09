function plot_camera(camera_p, scale)
%PLOT_CAMERA Summary of this function goes here
%   Detailed explanation goes here
[center axis] = camera_center_and_axis(camera_p);
quiver3(center(1),center(2),center(3),axis(1),axis(2),axis(3), scale);
end

