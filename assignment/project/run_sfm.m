function run_sfm(id)
% run_sfm.m
% clear
close all
clc

% set up environoment
addpath ../vlfeat-0.9.21;
addpath ../vlfeat-0.9.21/toolbox/;
vl_setup()

addpath ./data/
addpath ./code/

rng(42);

skip_step_0 = true;
skip_step_1 = true;
skip_step_2 = true;
skip_step_3 = true;
skip_step_4 = true;

skip_step_0 = false;
skip_step_1 = false;
skip_step_2 = false;
skip_step_3 = false;
skip_step_4 = false;

using_parallel_RANSAC = true;
% uncomment this line to use the standard RANSAC
using_parallel_RANSAC = false;
if using_parallel_RANSAC == true
    fprintf("using paralle RANSAC\n");
else 
    fprintf("using standard RANSAC\n");
end 

data_set_id = id;
fprintf("####Loading dataset %d###\n", data_set_id);

% read data set info
[K, img_names, init_pair, pixel_threshold] = get_dataset_info(data_set_id);
fprintf("init_pair (%d:%d)\n", init_pair(1),init_pair(2));

epipolar_threshold = 1*pixel_threshold/K(1,1);
homography_threshold = 1*3 * pixel_threshold/K(1,1);
translation_threshold = 3*3 * pixel_threshold/K(1,1);

fprintf("pixel threshold %d px.\n", pixel_threshold);


%%%% step 0, extra feature.%%%%
fprintf("####Running step 0, do vl_sift to all images.####\n");

if skip_step_0
    fprintf("Skip step 0 by config.\n");
    load("step_0.mat");
else
    tic;

    fs=cell(1,size(img_names,2));
    ds=cell(1,size(img_names,2));
    for i=1:size(img_names,2)
        image_i = imread(img_names{i});
        [fi di] = vl_sift(single(rgb2gray(image_i)), 'PeakThresh', 1);
        fs{i} = fi;
        ds{i} = di;
    end

    elapsedTime = toc;
    fprintf("Step 0 done in %s second.\n", elapsedTime);

    save("step_0.mat","fs","ds");
end


%%%% step 1, to calculate relative R. %%%%%
fprintf("####Running step 1, to calculate relative rotation.####\n");

if skip_step_1
    fprintf("Skip step 1 by config.\n");
    load("step_1.mat");
else
    tic; 

    R_s = cell(1,size(img_names,2));
    R_s{1} = [1 0 0; 0 1 0; 0 0 1];
    for i = 1 : size(img_names,2)-1

     f1 = fs{i};
     f2 = fs{i+1};
     d1 = ds{i};
     d2 = ds{i+1};
     [matches, ~] = vl_ubcmatch(d1,d2);
     x1 = [f1(1,matches(1,:)); ...
           f1(2,matches(1,:)); ...
           ones(1,size(f1(2,matches(1,:)),2))];
     x2 = [f2(1,matches(2,:)); ...
           f2(2,matches(2,:)); ...
           ones(1,size(f2(2,matches(2,:)),2))];
     x1_normalized = inv(K)*x1;
     x2_normalized = inv(K)*x2;

     if using_parallel_RANSAC == false
         [E, ~, inliers_idx] = estimate_E_robust(K,x1_normalized,x2_normalized,epipolar_threshold);
         [P2,X,~,~]= get_P2_and_X_from_E(E,x1_normalized(:,inliers_idx),x2_normalized(:,inliers_idx));
         R_s{i+1} = P2(:,1:3);
     else
         [R,~,~,~] = estimate_R_robust( ...
             x1_normalized,x2_normalized, ...
             epipolar_threshold,homography_threshold);
         R_s{i+1} = R;
     end 
    end 
    
    elapsedTime = toc;
    fprintf("Step 1 done in %s second.\n", elapsedTime);
    save("step_1.mat","R_s");
end 

%%%%% step 2, update R to absolute rotations %%%%%
fprintf("####Running step 2, update R to absolute rotations.####\n");

if skip_step_2
    fprintf("Skip step 2 by config.\n");
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
fprintf("####Running step 3, reconstruct inital 3D points from an initial image pair.####\n");

if skip_step_3
    fprintf("Skip step 3 by config.\n");
    load("step_3.mat");
else
    tic;

    image_1 = imread(img_names{init_pair(1)});
    image_2 = imread(img_names{init_pair(2)});
    % extrac initial matched points
    f1 = fs{init_pair(1)};
    d1 = ds{init_pair(1)};
    f2 = fs{init_pair(2)};
    d2 = ds{init_pair(2)};

    [matches, scores] = vl_ubcmatch(d1,d2);
    x1 = [f1(1,matches(1,:)); f1(2,matches(1,:)); ones(1,size(f1(2,matches(1,:)),2))];
    x2 = [f2(1,matches(2,:)); f2(2,matches(2,:)); ones(1,size(f2(2,matches(2,:)),2))];
    
    % estimate E and get R|T from E, also X
    x1_normalized = inv(K)*x1;
    x2_normalized = inv(K)*x2;
    
    if using_parallel_RANSAC == false
        [E, ~, inliers_idx] = estimate_E_robust(K,x1_normalized,x2_normalized,epipolar_threshold);
        [P2,X,~,~,~]= get_P2_and_X_from_E(E,x1_normalized(:,inliers_idx),x2_normalized(:,inliers_idx));
    
    else
        [R,T,X,inliers_idx] = estimate_R_robust( ...
             x1_normalized,x2_normalized, ...
             epipolar_threshold,homography_threshold);
        P2=[R T];
    end 

    % center X (TODO)
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

    %
    elapsedTime = toc;
    fprintf("Step 3 done in %s second.\n", elapsedTime);

    % bring X to world cooridnates. 
    X_0 = R_s_abs{init_pair(1)}' * X(1:3,:); 
    % X_0 = X(1:3,:);
    % save inlier desc_X 
    d1_matches = d1(:,matches(1,:));
    desc_x = x1(:,inliers_idx);
    desc_X = d1_matches(:,inliers_idx);
    desc_img = image_1;
    save("step_3.mat","X_0","desc_X","desc_x","desc_img");

end
%%%% step 4 calculate the camera center C/T robustly %%%%
fprintf("####Running step 4, calculate the camera center C/T robustly.####\n");
if skip_step_4 
    fprintf("Skip step 4 by config.\n");
    load("step_4.mat");
else 
    tic;

    Ps = cell(1,size(img_names,2));
    xs = cell(1,size(img_names,2)); % to save inlier X and x for step 6
    Xs = cell(1,size(img_names,2));
    for i=1:size(img_names,2)
        image_i = imread(img_names{i});
        fi = fs{i};
        di = ds{i};
        [matches, scores] = vl_ubcmatch(di,desc_X);
        xi = [fi(1,matches(1,:)); fi(2,matches(1,:)); ones(1,size(fi(2,matches(1,:)),2))];
        xm = desc_x(:,matches(2,:));
    
        random_index = randperm(size(xi,2),10);
    
        xi = inv(K)*xi;
        Xi = X_0(:,matches(2,:));
        % 2 points method
        % method (simpilify) calculate camera DLT in CE2
    %       [Pi, ~] = estimate_T_robust(xi,Xi,K);
        [Ps{i}, inliers_t_idx] = estimate_T_robust_2p(xi,Xi,K,R_s_abs{i},translation_threshold);
        Xs{i} = Xi(:,inliers_t_idx);
        xs{i} = xi(:,inliers_t_idx);
    end

    elapsedTime = toc;
    fprintf("Step 4 done in %s second.\n", elapsedTime);

    save("step_4.mat","Ps","Xs","xs");
end 

%%%% step 5, refine camera centers (translation vectors) using
%%%% Levenberg-Marquardt
fprintf("####Running step 5, refining camera centers (T).####\n");
o_Ps = Ps;
for i=1:size(Ps,2)
    [P,t] = LM_refine_T(Ps{i},xs{i},[Xs{i};ones(1,size(Xs{i},2))]);
    Ps{i} = P;
end 

%%%% step 6, traingualte points for all pairs(i,i+1)
% TODO compute vl_sift early for all steps!
fprintf("####Running step 6, traingualte points for all pairs(i,i+1).####\n");
tic;
Xs= cell(1,size(img_names,2)-1);
for i=1:size(img_names,2)-1
    image_1 = imread(img_names{i});
    image_2 = imread(img_names{i+1});
    f1 = fs{i};
    d1 = ds{i};
    f2 = fs{i+1};
    d2 = ds{i+1};

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
end 

elapsedTime = toc;
fprintf("Step 6 done in %s second.\n", elapsedTime);

figure
for i=1: size(Xs,2)
    plot3(Xs{i}(1,:),Xs{i}(2,:),Xs{i}(3,:),'.', 'MarkerSize',3);
    hold on
end 
plotcams(Ps);
hold off 
axis equal

end
