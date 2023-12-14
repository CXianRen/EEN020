clear
close all
clc

addpath ./data/
addpath ./code/

% result from ce2
% load ce2_result.mat
load data/compEx3data.mat

% % combination 1
% X_std_err = 0;
% x_n_std_err = 10;

% % combination 2
% X_std_err = 0.2;
% x_n_std_err = 3;

% % combination 3
% X_std_err = 0.1;
% x_n_std_err = 6;

% % combination 4
% X_std_err = 0.1;
% x_n_std_err = 3;

% % combination 5
X_std_err = 0.5;
x_n_std_err = 0;

X_noise = randn(3,size(X,2)) * X_std_err; 
x_1_noise = randn(2,size(X,2)) * x_n_std_err;
x_2_noise = randn(2,size(X,2)) * x_n_std_err;

subplot(2,2,1);
% x_1 nosie 
plot(x_1_noise(1,:),x_1_noise(2,:),'+', 'MarkerSize',3);
axis equal
title("x\_1\_noise")
subplot(2,2,2);
plot(x_2_noise(1,:),x_2_noise(2,:),'+', 'MarkerSize',3);
axis equal
title("x\_2\_noise")


subplot(2,2,3);
plot(x{1}(1,:),x{1}(2,:),'+','MarkerSize',3, 'color', 'b');
x_1 = x{1} + [x_1_noise; ones(1,size(x{1},2))];
hold on 
plot(x_1(1,:),x_1(2,:),'o','MarkerSize',3, 'color', 'r');
hold off
axis equal
title("x1(blue) and x1(red) with noise")

subplot(2,2,4);
plot(x{2}(1,:),x{2}(2,:),'+','MarkerSize',3, 'color', 'b');
x_2 = x{2} + [x_2_noise; ones(1,size(x{2},2))];
hold on 
plot(x_2(1,:),x_2(2,:),'o','MarkerSize',3, 'color', 'r');
hold off
axis equal
title("x2(blue) and x2(red) with noise")



x_1_n_f=inv(K)*x{1};
x_2_n_f=inv(K)*x{2};
P1=inv(K)*P{1};
P2=inv(K)*P{2};

figure;
subplot(1,2,1);
plot3(X_noise(1,:),X_noise(2,:),X_noise(3,:),'+', 'MarkerSize',3);
title("X noise")
axis equal

subplot(1,2,2);
plot3(X(1,:),X(2,:),X(3,:),'+', 'MarkerSize',3, 'color','b');
hold on
X = X + [X_noise; ones(1,size(X,2))];
plot3(X(1,:),X(2,:),X(3,:),'*', 'MarkerSize',3, 'color','r');

err_before= zeros(1,size(X,2));
for i=1:size(X,2)
    [err,res] = ComputeReprojectionError(P1,P2,X(:,i),x_1_n_f(:,i),x_2_n_f(:,i));
    err_before(i) =  err;
end
sum_err_before = sum(err_before)
median_err_before = median(err_before)

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
        delta_delta_X = delta_X' * delta_X;
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


plot3(X(1,:),X(2,:),X(3,:),'+' ,'color', 'g', 'MarkerSize',3);

axis equal
title("X (blue), X with noise (red), X optimized (green)")
hold off



