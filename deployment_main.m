clear;clc;

addpath("db_operator\");
addpath("deployment\");

leaf=20;
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
shelter=create_shelter();
shelter=voxel(shelter,leaf/2);

n_pcd=size(pcd,1);
n_noise=size(noise,1);
n_ground=size(ground,1);
n_keypoint=size(keypoints,1);
pcd_range=[1,n_pcd];
noise_range=pcd_range(1,2)+[1,n_noise];
ground_range=noise_range(1,2)+[1,n_ground];
keypoint_range=ground_range(1,2)+[1,n_keypoint];

tracker_count=6;
tracker_aabb=aabb(total_pcd);
zoom_tracker_aabb=zoom_out_bound(tracker_aabb);
[ub,lb]=get_bound(tracker_count,zoom_tracker_aabb);

NP=20;
D=numel(lb);
GMAX=500;
N=20;

generate_deployment_data(NP,D,lb,ub,GMAX,N,pcd,noise,ground,keypoints,shelter,n_pcd,n_noise,n_ground,n_keypoint,pcd_range,noise_range,ground_range,keypoint_range,total_pcd);


