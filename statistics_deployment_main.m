clear;clc;
addpath("db_operator\");
addpath("deployment\");

leaf=4;
pcd=readmatrix('data\F22-solidworks-整机点云.txt');
pcd=voxel(pcd,leaf);
noise=readmatrix('data\gz.txt');
noise=voxel(noise,leaf);
ground=readmatrix('data\ground.txt');
ground=voxel(ground,leaf*2);
keypoints=[
    2.2e+02, 24., -6.4e+02;
    -2.3e+02, 24., -6.4e+02;
    19., 62., -5.9e+02;
    -19., 60., -2.9e+02
    ];
total_pcd=[pcd;noise;ground;keypoints];

n_pcd=size(pcd,1);
n_noise=size(noise,1);
n_ground=size(ground,1);
n_keypoint=size(keypoints,1);
pcd_range=[1,n_pcd];
noise_range=pcd_range(1,2)+[1,n_noise];
ground_range=noise_range(1,2)+[1,n_ground];
keypoint_range=ground_range(1,2)+[1,n_keypoint];

conn=sqlite("db_operator\202209201650.db","connect");
sql=sprintf('select * from base_info where name in ("ROA","PROA") and F="deployment6" and idx>20 order by id');
base_info_results=fetch(conn,sql);
n_base_info_results=size(base_info_results,1);

for i=1:n_base_info_results
    id=base_info_results{i,1};
    sql=sprintf('select * from deployment_x_best where base_info_id=%d',id);
    x_best_result=fetch(conn,sql);
    x_best=x_best_result(1,2:end);
    x_best=cell2mat(x_best);
    new_p_best=objective(x_best,total_pcd,n_pcd,n_keypoint,pcd_range,noise_range,ground_range,keypoint_range);
    new_base_info_result=base_info_results(i,:);
    new_base_info_result{1,end}=new_p_best;
    insert(conn,'deployment_base_info',{'id','name','F','idx','NP','D','g_max','p_best'},new_base_info_result);

    sql=sprintf('select * from deployment_x_history where base_info_id=%d',id);
    x_history_results=fetch(conn,sql);
    x_history_results=x_history_results(:,2:end);
    x_history_results=cell2mat(x_history_results);
    iter_history=cell(500,3);
    for j=1:500
        x_history_item=x_history_results(j,:);
        new_history_p_best=objective(x_history_item,total_pcd,n_pcd,n_keypoint,pcd_range,noise_range,ground_range,keypoint_range);
        iter_history{j,1}=id;
        iter_history{j,2}=j;
        iter_history{j,3}=new_history_p_best;
    end
    insert(conn,'deployment_iter_history',{'base_info_id','iter_idx','iter_best'},iter_history);

    % log
    status=sprintf('[%s] completed: %d/%d',datestr(now,'yyyy/mm/dd HH:MM:SS.FFF'),i,n_base_info_results);
    disp(status);
end


function visible_percent=objective(x,total_pcd,n_pcd,n_keypoint,pcd_range,noise_range,ground_range,keypoint_range)
%% [constraints]
% 1、跟踪仪站位在测量目标包围盒*（1+zoom_factor）平面上。
% 2、不少于2个站位看到关键点。
% 3、相邻站位之间测量目标上的（含工装）转站点数量≥3，地面转站点数量≥2。
%% [target]
% 所有站位看到测量目标上的点占总数80%。（求最小值，即fitness=1-visible/total）
tic;
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
    % statistics visible point count (≥3)
    statistics_visible_result(i,1)=numel(statistics_visible_indices)-visible_constraint;
    % statistics ground point count (≥2)
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
toc;
end

