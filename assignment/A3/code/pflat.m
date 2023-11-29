function [x_output] = pflat(x_input)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
x_n = x_input(end,:);
x_output = x_input./x_n;
end
