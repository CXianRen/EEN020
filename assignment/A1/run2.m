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
plot(p1(1,:),p1(2,:),'*', 'Color','r')
plot(p2(1,:),p2(2,:),'+', 'Color','g')
plot(p3(1,:),p3(2,:),'+', 'Color','y')

% calculate line that goes throught the paired points.
p = {p1, p2, p3}
lines = zeros(3,length(p));
for i=1:length(p)
    dy = p{i}(2,2)-p{i}(2,1)
    dx = p{i}(1,2)-p{i}(1,1)
    k= dy / dx;
    c=-(p{i}(2,1)-k*p{i}(1,1));
    a=-k;
    b=1;
    lines(:,i) = [a;b;c];
end

rital(lines);

hold off