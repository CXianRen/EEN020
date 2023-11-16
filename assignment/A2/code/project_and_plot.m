function project_and_plot(P,X, image)
%PROJECT_AND_PLOT Summary of this function goes here
%   Detailed explanation goes here

x_p = P*X;
% flatten x1_p
x_p_f = x_p ./ x_p(end,:);

imshow(image);
hold on 
plot(x_p_f(1,:), x_p_f(2,:),'+', 'Markersize', 3, 'color', 'r');
hold off
end

