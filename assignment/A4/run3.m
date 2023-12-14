clear
close all
clc

addpath ./data/
addpath ./code/

% result from ce2
% load ce2_result.mat

% or 
load data/compEx3data.mat
x_1_n_f=inv(K)*x{1};
x_2_n_f=inv(K)*x{2};
P1=inv(K)*P{1};
P2=inv(K)*P{2};
%

err_before= zeros(1,size(X,2));
for i=1:size(X,2)
    [err,res] = ComputeReprojectionError(P1,P2,X(:,i),x_1_n_f(:,i),x_2_n_f(:,i));
    err_before(i) =  err;
end
sum_err_before = sum(err_before)
median_err_before = median(err_before)

% plot it before 
plot3(X(1,:),X(2,:),X(3,:),'x' ,'color', 'b', 'MarkerSize',4);
hold on 


last_delta_X_n = 0;

for i=1:size(X,2)
     while true
        mu = 0.01;
        [r,J] = LinearizeReprojErr(P1,P2,X(:,i),x_1_n_f(:,i),x_2_n_f(:,i));
        delta_X = ComputeUpdate(r,J,mu);
        [err,~]=ComputeReprojectionError(P1,P2,X(:,i),x_1_n_f(:,i),x_2_n_f(:,i));
        [err_p,~]=ComputeReprojectionError(P1,P2,X(:,i)+delta_X,x_1_n_f(:,i),x_2_n_f(:,i));
        if err_p< err
           X(:,i) = X(:,i) + delta_X;
           mu = mu/10;
        else
           mu = mu*10;
        end
        delta_delta_X = delta_X' * delta_X
        if abs(last_delta_X_n - delta_delta_X) < 1e-10
            break
        end
        last_delta_X_n = delta_delta_X;
    end
end

err_after= zeros(1,size(X,2));
for i=1:size(X,2)
    [err,res] = ComputeReprojectionError(P1,P2,X(:,i),x_1_n_f(:,i),x_2_n_f(:,i));
    err_after(i) =  err;
end
sum_err_after = sum(err_after)
median_err_after = median(err_after)

plot3(X(1,:),X(2,:),X(3,:),'+' ,'color', 'r', 'MarkerSize',4);
axis equal
hold off
title("reconstruction with (blue) and without optimization (Red)")
saveas(gcf,"c3-reconstruction_with-without-optimization.png");


