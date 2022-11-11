function generate_deployment_data(NP,D,lb,ub,GMAX,N,pcd,noise,ground,keypoints,shelter,n_pcd,n_noise,n_ground,n_keypoint,pcd_range,noise_range,ground_range,keypoint_range,total_pcd)
addpath("..\deployment\");

id=53620;

for i=21:21+N-1
    X=zeros(NP,D);
    for d=1:D
        X(:,d)=unifrnd(lb(1,d),ub(1,d),NP,1);
    end
    f_name='deployment6';

    % ROA
    [p_best,x_best,p_history,time_stamp_history,time_p_best_history,x_history]=ROA(X,GMAX,lb,ub,pcd,noise,ground,keypoints,shelter,n_pcd,n_noise,n_ground,n_keypoint,pcd_range,noise_range,ground_range,keypoint_range,total_pcd);
    insert_deployment_data(id,'ROA',f_name,i,NP,D,GMAX,p_best,p_history,time_stamp_history,time_p_best_history,x_best,x_history);
    id=id+1;

    % PROA
    [p_best,x_best,p_history,time_stamp_history,time_p_best_history,x_history]=PROA(X,GMAX,lb,ub,pcd,noise,ground,keypoints,shelter,n_pcd,n_noise,n_ground,n_keypoint,pcd_range,noise_range,ground_range,keypoint_range,total_pcd);
    insert_deployment_data(id,'PROA',f_name,i,NP,D,GMAX,p_best,p_history,time_stamp_history,time_p_best_history,x_best,x_history);
    id=id+1;

    % log
    status=sprintf('[%s] completed: %s,N%d',datestr(now,'yyyy/mm/dd HH:MM:SS.FFF'),f_name,i);
    disp(status);
end
end