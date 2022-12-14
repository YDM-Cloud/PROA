function [Score,BestRemora,Convergence,time_stamp_history,time_p_best_history,x_history]=ROA(X,Max_iterations,Lowerbound,Upperbound,pcd,noise,ground,keypoints,shelter,n_pcd,n_noise,n_ground,n_keypoint,pcd_range,noise_range,ground_range,keypoint_range,total_pcd)
tic;

start_stamp=datevec(now);
time_stamp_history=[];
time_p_best_history=[];
p_best=inf;


[Search_Agents,dimensions]=size(X);
BestRemora=zeros(1,dimensions);
Score=inf;
Remora=X;
Prevgen{1}=Remora;
Convergence=zeros(1,Max_iterations);
x_history=zeros(Max_iterations,dimensions);

t=0;
while t<Max_iterations

    %% Memory of previous generation

    if t<=1
        PreviousRemora = Prevgen{1};
    else
        PreviousRemora = Prevgen{t-1};
    end

    % Boundary check

    for i=1:size(Remora,1)
        Flag4Upperbound=Remora(i,:)>Upperbound;
        Flag4Lowerbound=Remora(i,:)<Lowerbound;
        Remora(i,:)=(Remora(i,:).*(~(Flag4Upperbound+Flag4Lowerbound)))+Upperbound.*Flag4Upperbound+Lowerbound.*Flag4Lowerbound;
        fitness=objective(Remora(i,:),total_pcd,n_pcd,n_keypoint,pcd_range,noise_range,ground_range,keypoint_range,shelter);

        % Evaluate fitness function of search agents

        if fitness<Score
            Score=fitness;
            BestRemora=Remora(i,:);
        end
    end

    x_history(t+1,:)=BestRemora;

    % Make a experience attempt through equation (2)

    for j=1:size(Remora,1)
        RemoraAtt = Remora(j,:)+(Remora(j,:)-PreviousRemora(j,:))*randn;                    %Equation(2)

        % Calculate the fitness function value of the attempted solution (fitnessAtt)

        fitnessAtt=objective(RemoraAtt,total_pcd,n_pcd,n_keypoint,pcd_range,noise_range,ground_range,keypoint_range,shelter);

        % Calculate the fitness function value of the current solution (fitnessI)

        fitnessI=objective(Remora(j,:),total_pcd,n_pcd,n_keypoint,pcd_range,noise_range,ground_range,keypoint_range,shelter);

        % Check if the current fitness (fitnessI) is better than the attempted fitness(fitnessAtt)
        % if No, Perform host feeding by equation (9)

        if fitnessI>fitnessAtt
            V = 2*(1-t/Max_iterations);                                                     % Equation (12)
            B = 2*V*rand-V;                                                                 % Equation (11)
            C = 0.1;
            A = B*(Remora(j,:)-C*BestRemora);                                               % Equation (10)
            Remora(j,:)= Remora(j,:)+A;                                                     % Equation (9)

            % If yes perform host conversion using equation (1) and (5)

        elseif randi([0 1],1)==0
            % WOA strategy
            a=-(1+t/Max_iterations);                                                        % Equation (7)
            alpha = rand*(a-1)+1;                                                           % Equation (6)
            D = abs(BestRemora-Remora(j,:));                                                % Equation (8)
            Remora(j,:) = D*exp(alpha)*cos(2*pi*a)+Remora(j,:);                             % Equation (5)
        else
            % SFO strategy
            m=randperm(size(Remora,1));
            Remora(j,:)=BestRemora-((rand*(BestRemora+Remora(m(1),:))/2)-Remora(m(1),:));   % Equation (1)
        end
    end

    t=t+1 ;
    Prevgen{t+1}=Remora;
    Convergence(t)=Score;

    if Score<p_best
        p_best=Score;
        current_stamp=datevec(now);
        time_stamp_history=[time_stamp_history;etime( current_stamp,start_stamp)];
        time_p_best_history=[time_p_best_history;p_best];
    end
end
toc;
end

function visible_percent=objective(x,total_pcd,n_pcd,n_keypoint,pcd_range,noise_range,ground_range,keypoint_range,shelter)
%% [constraints]
% 1??????????????????????????????????????????*???1+zoom_factor???????????????
% 2????????????2???????????????????????????
% 3????????????????????????????????????????????????????????????????????????3???????????????????????????2???
%% [target]
% ????????????????????????????????????????????????80%????????????????????????fitness=1-visible/total???
% tic;
%% init constraints paras
keypoint_constraint=0.75;
visible_constraint=3;
ground_constraint=2;
%% transform x to tracker positions
tracker_count=numel(x)/3;
tracker_positions=reshape(x,3,tracker_count)';
%% init cells
pcd_cell=cell(1,tracker_count);
noise_cell=cell(1,tracker_count);
ground_cell=cell(1,tracker_count);
keypoint_total_indices=[];
%% get visible points
for i=1:tracker_count
    position=tracker_positions(i,:);
%     translated_shelter=translate_shelter(shelter,position);
%     indices=HPR([total_pcd;translated_shelter],position);
    indices=HPR(total_pcd,position);
    pcd_indices=indices(indices>=pcd_range(1,1)&indices<=pcd_range(1,2));
    noise_indices=indices(indices>=noise_range(1,1)&indices<=noise_range(1,2));
    ground_indices=indices(indices>=ground_range(1,1)&indices<=ground_range(1,2));
    keypoint_indices=indices(indices>=keypoint_range(1,1)&indices<=keypoint_range(1,2));
    if numel(pcd_indices)~=0
        pcd_cell{1,i}=pcd_indices;
    end
    if numel(noise_indices)~=0
        noise_cell{1,i}=noise_indices;
    end
    if numel(ground_indices)~=0
        ground_cell{1,i}=ground_indices;
    end
    keypoint_total_indices=[keypoint_total_indices,keypoint_indices];
end
%% statistics pcd/noise/ground
statistics_visible_result=zeros(tracker_count,2);
for i=1:tracker_count
    if i~=tracker_count
        statistics_visible_indices=intersect([pcd_cell{1,i},noise_cell{1,i}],[pcd_cell{1,i+1},noise_cell{1,i+1}]);
        statistics_ground_indices=intersect(ground_cell{1,i},ground_cell{1,i+1});
    else
        statistics_visible_indices=intersect([pcd_cell{1,i},noise_cell{1,i}],[pcd_cell{1,1},noise_cell{1,1}]);
        statistics_ground_indices=intersect(ground_cell{1,i},ground_cell{1,1});
    end
    % statistics visible point count (???3)
    statistics_visible_result(i,1)=numel(statistics_visible_indices)-visible_constraint;
    % statistics ground point count (???2)
    statistics_visible_result(i,2)=numel(statistics_ground_indices)-ground_constraint;
end
%% statistics keypoint
statistics_keypoint_result=zeros(1,n_keypoint);
keypoint_flat_indices=keypoint_range(1,1):keypoint_range(1,2);
for i=1:n_keypoint
    statistics_keypoint_indices=keypoint_total_indices(keypoint_total_indices==keypoint_flat_indices(1,i));
    statistics_keypoint_result(1,i)=numel(statistics_keypoint_indices);
end
statistics_keypoint_result=numel(statistics_keypoint_result>0)/n_keypoint-keypoint_constraint;
%% visible percent
visible_union=pcd_cell{1,1};
for i=2:tracker_count
    visible_union=union(visible_union,pcd_cell{1,i});
end
visible_percent=1-numel(visible_union)/n_pcd;
%% add penalty value to fitness
penalty_facotr=1e6;
statistics_visible_result=statistics_visible_result(statistics_visible_result<0);
if numel(statistics_visible_result)~=0
    statistics_visible_result=statistics_visible_result.^2*penalty_facotr;
    visible_percent=visible_percent+sum(statistics_visible_result,"all");
end
if statistics_keypoint_result<0
    visible_percent=visible_percent+statistics_keypoint_result^2*penalty_facotr;
end
% toc;
end

