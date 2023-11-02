% clean history and terminal
clear
clc
% 
img = imread("data/compEx2.jpg");
load("data/compEx2.mat");
imagesc(img);
colormap gray
hold on

% plot the original points
plot(p1(1,:),p1(2,:),'+', 'Color','r');
plot(p2(1,:),p2(2,:),'+', 'Color','g');
plot(p3(1,:),p3(2,:),'+', 'Color','y');

% calculate line that goes throught the paired points.
p = {p1, p2, p3};
lines = zeros(3,length(p));
for i=1:length(p)
    lines(:,i) = cross(p{i}(:,1),p{i}(:,2));
end
rital(lines);
% calculate the intersection of l2 and l3
inter_p = pflat(cross(lines(:,2),lines(:,3)));
plot(inter_p(1,:),inter_p(2,:),'*', 'Color','r');
saveas(gcf,"ce_2.png");
% calculate the distance between interscetion and l1
dist = point_line_distance_2D(inter_p,pflat(lines(:,1)))

hold off