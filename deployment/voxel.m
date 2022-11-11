function voxel_pts=voxel(pts,leaf)
voxel_pts=[];
n_pts=size(pts,1);
min_xyz=min(pts);
max_xyz=max(pts);
d_xyz=ceil((max_xyz-min_xyz)/leaf);
h_xyz=floor((pts-min_xyz)/leaf);
h=h_xyz(:,1)+h_xyz(:,2)*d_xyz(1,1)+h_xyz(:,3)*d_xyz(1,1)*d_xyz(1,2);
[h_sorted,h_indices]=sort(h');
begin=1;
for i=1:n_pts-1
    if h_sorted(1,i)~=h_sorted(1,i+1)
        idx=h_indices(1,begin:i);
        voxel_pts=[voxel_pts;mean(pts(idx,:),1)];
        begin=i+1;
    end
end

% bound=aabb(points);
% max_bound=bound(1,4:6);
% min_bound=bound(1,1:3);
% leaf_xyz=ceil((max_bound-min_bound)/leaf+1);
% leaf_x=leaf_xyz(1,1);
% leaf_y=leaf_xyz(1,2);
% [n_points,~]=size(points);
% indices=zeros(n_points,2);
% for i=1:n_points
%     xyz_i=ceil((points(i,:)-min_bound)/leaf);
%     xi=xyz_i(1,1);
%     yi=xyz_i(1,2);
%     zi=xyz_i(1,3);
%     indices(i,:)=[xi+yi*leaf_x+zi*leaf_x*leaf_y,i];
% end
% indices=sortrows(indices,1);
% n_voxel_points=length(unique(indices(:,1)));
% voxel_points=zeros(n_voxel_points,3);
% temp_sum=zeros(1,3);
% temp_count=0;
% temp_index=1;
% for i=1:n_points
%     if i==1 || indices(i,1)==indices(i-1,1)
%         temp_sum=temp_sum+points(indices(i,2),:);
%         temp_count=temp_count+1;
%     else
%         voxel_points(temp_index,:)=temp_sum/temp_count;
%         temp_index=temp_index+1;
%         temp_sum=zeros(1,3);
%         temp_count=0;
%     end
% end
end