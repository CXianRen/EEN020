clear
close all
clc

% set up environoment
addpath ../vlfeat-0.9.21;
addpath ../vlfeat-0.9.21/toolbox/;
vl_setup()

addpath ./data/
addpath ./code/

skip_step_1 = true;
skip_step_2 = true;
skip_step_3 = true;
skip_step_4 = true;

% skip_step_1 = false;
% skip_step_2 = false;
% skip_step_3 = false;
% skip_step_4 = false;




% read data set info
[K, img_names, init_pair, pixel_threshold] = get_dataset_info(2);

%%%% step 1, to calculate relative R. %%%%%
if skip_step_1
    load("step_1.mat");
else

    R_s = cell(1,size(img_names,2));
    R_s{1} = [1 0 0; 0 1 0; 0 0 1];
    for i = 1 : size(img_names,2)-1
     image_1 = imread(img_names{i});
     image_2 = imread(img_names{i+1});
     [R,T] = step_1(image_1,image_2,K);
     R_s{i+1} = R;
    end 
    save("step_1.mat","R_s");
end 

%%%%% step 2, update R to absolute rotations %%%%%
if skip_step_2
    load("step_2.mat");
else
    R_s_abs = cell(1, size(R_s,2));
    R_s_abs{1} = [1 0 0; 0 1 0; 0 0 1];
    for i = 2 : size(R_s,2)
        R_s_abs{i} = R_s{i} * R_s_abs{i-1};
    end
    save("step_2.mat","R_s_abs");
end

%%%% step 3, reconstruct inital 3D points from an initial image pair %%%%
if skip_step_3
    load("step_3.mat");
else
    image_1 = imread(img_names{init_pair(1)});
    image_2 = imread(img_names{init_pair(2)});
    % extrac initial matched points
    [f1 d1] = vl_sift(single(rgb2gray(image_1)), 'PeakThresh', 1);
    [f2 d2] = vl_sift(single(rgb2gray(image_2)), 'PeakThresh', 1);
    [matches, scores] = vl_ubcmatch(d1,d2);
    x1 = [f1(1,matches(1,:)); f1(2,matches(1,:)); ones(1,size(f1(2,matches(1,:)),2))];
    x2 = [f2(1,matches(2,:)); f2(2,matches(2,:)); ones(1,size(f2(2,matches(2,:)),2))];
    
    % estimate E and get R|T from E, also X
    x1_normalized = inv(K)*x1;
    x2_normalized = inv(K)*x2;
    [E, epsilon, inliers_idx] = estimate_E_robust(K,x1_normalized,x2_normalized);
    [P2,X,P2s,Xs]= get_P2_and_X_from_E(E,x1_normalized(:,inliers_idx),x2_normalized(:,inliers_idx));
    % center X (TODO)
    % bring X to world cooridnates. 
    %% improve X with LM (will the result be better?)
    P1=[1 0 0 0; 0 1 0 0; 0 0 1 0];
    x_1_n_f = x1_normalized(:,inliers_idx);
    x_2_n_f = x2_normalized(:,inliers_idx);
    last_delta_X_n = 0;
    for i=1:size(X,2)
        mu = 0.01;
        while true
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

    %%


    X_0 = R_s_abs{init_pair(1)}' * X(1:3,:);  % TODO WHY?
    % X_0 = X(1:3,:);
    % save inlier desc_X 
    d1_matches = d1(:,matches(1,:));
    desc_x = x1(:,inliers_idx);
    desc_X = d1_matches(:,inliers_idx);
    desc_img = image_1;
    save("step_3.mat","X_0","desc_X","desc_x","desc_img");

    % debug 
%     xrp = P2 * [X_0;ones(1,size(X_0,2))];
%     xrp= pflat(xrp);
%     plot(x2_normalized(1,inliers_idx),x2_normalized(2,inliers_idx),'+', Color='r');
%     hold on 
%     plot(xrp(1,:),xrp(2,:),'o', Color='b');
%     hold off
    % 
end
%%%% step 4 calculate the camera center C/T robustly %%%%
if skip_step_4 
    load("step_4.mat");
else 
    Ps = cell(1,size(img_names,2));
    xs = cell(1,size(img_names,2)); % to save inlier X and x for step 6
    Xs = cell(1,size(img_names,2));
    for i=1:size(img_names,2)
        image_i = imread(img_names{i});
        [fi di] = vl_sift(single(rgb2gray(image_i)), 'PeakThresh', 1);
        [matches, scores] = vl_ubcmatch(di,desc_X);
        xi = [fi(1,matches(1,:)); fi(2,matches(1,:)); ones(1,size(fi(2,matches(1,:)),2))];
        xm = desc_x(:,matches(2,:));
    
        random_index = randperm(size(xi,2),10);
    %     figure;
    %     imagesc([image_i desc_img]);
    %     hold on 
    %     plot([xi(1,random_index); xm(1,random_index)+ size(image_i,2)], ...
    %          [xi(2,random_index); xm(2,random_index)], '-')
    
        xi = inv(K)*xi;
        Xi = X_0(:,matches(2,:));
        % debug 
    %     P1= [1 0 0 0; 0 1 0 0; 0 0 1 0];
    %     xrp =K* P1 * [Xi;ones(1,size(Xi,2))];
    %     xrp= pflat(xrp);
    %    
    %     plot(xm(1,random_index) + size(image_i,2),xm(2,random_index),'+', Color='r');
    % 
    %     plot(xrp(1,random_index)+ size(image_i,2),xrp(2,random_index),'o', Color='b');
        % 
    
        % 2 points method (TODO)
        % method (simpilify) calculate camera DLT in CE2
    %       [Pi, ~] = estimate_T_robust(xi,Xi,K);
        [Ps{i}, inliers_t_idx] = estimate_T_robust_2p(xi,Xi,K,R_s_abs{i});
        Xs{i} = Xi(:,inliers_t_idx);
        xs{i} = xi(:,inliers_t_idx);
    %      P1 = estimate_camera_DLT(inv(K)*xm(:,random_index),Xi(:,random_index));
    
    %     xrp =K* P1 * [Xi;ones(1,size(Xi,2))];
    %     xrp= pflat(xrp);
    %     plot(xm(1,random_index)+ size(image_i,2),xm(2,random_index),'x', Color='y');
    %    
    %     plot(xrp(1,random_index)+ size(image_i,2),xrp(2,random_index),'*', Color='g');
    %     hold off
    
%         figure
    %     plot 3d points
%         subplot(1,2,1)
%         plot3(Xi(1,inliers_t_idx),Xi(2,inliers_t_idx),Xi(3,inliers_t_idx),'+', 'Color',rand(1,3));
%         hold on
%             plotcams({Ps{i}})
%         hold off
%         axis equal
        %plot projected points from 3d points with estimated camera
%         subplot(1,2,2)
%         xi_p = Ps{i} * [Xi;ones(1,size(Xi,2))];
%         xi_p= pflat(xi_p);
%         plot(xi(1,inliers_t_idx),xi(2,inliers_t_idx),'+', Color='r');
%         hold on 
%         plot(xi_p(1,inliers_t_idx),xi_p(2,inliers_t_idx),'o', Color='b');
%         hold off
    end
    subplot(1,2,1);
    imshow(desc_img)
    subplot(1,2,2);
    plot3(X_0(1,:),X_0(2,:),X_0(3,:),'.');
    hold on
        plotcams(Ps)
    hold off
    axis equal

    save("step_4.mat","Ps","Xs","xs");
end 

%%%% step 5, refine camera centers (translation vectors) using
%%%% Levenberg-Marquardt
o_Ps = Ps;
for i=1:size(Ps,2)
    [P,t] = LM_refine_T(Ps{i},xs{i},[Xs{i};ones(1,size(Xs{i},2))]);
    Ps{i} = P;
end 

%%%% step 6, traingualte points for all pairs(i,i+1)
% TODO compute vl_sift early for all steps!
Xs= cell(1,size(img_names,2)-1);
for i=1:size(img_names,2)-1
    image_1 = imread(img_names{i});
    image_2 = imread(img_names{i+1});
    [f1 d1] = vl_sift(single(rgb2gray(image_1)), 'PeakThresh', 1);
    [f2 d2] = vl_sift(single(rgb2gray(image_2)), 'PeakThresh', 1);
    [matches, scores] = vl_ubcmatch(d1,d2);
    x1 = [f1(1,matches(1,:)); f1(2,matches(1,:)); ones(1,size(f1(2,matches(1,:)),2))];
    x2 = [f2(1,matches(2,:)); f2(2,matches(2,:)); ones(1,size(f2(2,matches(2,:)),2))];
    x1n = inv(K)*x1;
    x2n = inv(K)*x2;

    Xi = [];
    for j= 1: size(x1n,2)
        X_ij = triangulate_3D_point_DLT(x1n(:,j),x2n(:,j),Ps{i},Ps{i+1});
        Xi = [Xi X_ij];
    end
    Xi=pflat(Xi); 
    
    % filter Xi
    Xi_mean = mean(Xi')';
    Xi_dist = vecnorm(Xi - Xi_mean,2,1);
    threshold = 2 * quantile(Xi_dist,0.90);
    Xi_inliners = Xi_dist <= threshold;
    Xi_inliners_idx = find(Xi_inliners > 0);
    Xi = Xi(:,Xi_inliners_idx);

    Xs{i} = Xi;

    figure;
    plot3(Xi(1,:),Xi(2,:),Xi(3,:),'.');
    hold on
        plotcams({Ps{i},Ps{i+1}});
    hold off
    axis equal 
end 

figure
for i=1: size(Xs,2)
    plot3(Xs{i}(1,:),Xs{i}(2,:),Xs{i}(3,:),'.', 'MarkerSize',3);
    hold on
end 
plotcams(Ps);
hold off 
axis equal
