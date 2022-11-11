function [ub,lb]=get_bound(tracker_count,aabb)
%% init bound
ub=zeros(1,tracker_count*3);
lb=zeros(1,tracker_count*3);
%% partition
n=ceil(tracker_count/4);
m=floor(tracker_count/4);
%% get bound value
min_x=aabb(1,1);
min_y=aabb(1,2);
min_z=aabb(1,3);
max_x=aabb(1,4);
max_y=aabb(1,5);
max_z=aabb(1,6);
%% init front
areas=linspace(max_x,min_x,m+1);
for i=1:m
    ub(1,3*i-2)=areas(1,i);
    lb(1,3*i-2)=areas(1,i+1);
    ub(1,3*i-1)=max_y;
    lb(1,3*i-1)=min_y;
    ub(1,3*i)=max_z;
    lb(1,3*i)=max_z;
end
%% init right
areas=linspace(max_z,min_z,n+1);
for i=1:n
    ub(1,3*(i+m)-2)=min_x;
    lb(1,3*(i+m)-2)=min_x;
    ub(1,3*(i+m)-1)=max_y;
    lb(1,3*(i+m)-1)=min_y;
    ub(1,3*(i+m))=areas(1,i);
    lb(1,3*(i+m))=areas(1,i+1);
end
%% init back
areas=linspace(min_x,max_x,m+1);
for i=1:m
    ub(1,3*(i+m+n)-2)=areas(1,i+1);
    lb(1,3*(i+m+n)-2)=areas(1,i);
    ub(1,3*(i+m+n)-1)=max_y;
    lb(1,3*(i+m+n)-1)=min_y;
    ub(1,3*(i+m+n))=min_z;
    lb(1,3*(i+m+n))=min_z;
end
%% init left
areas=linspace(min_z,max_z,n+1);
for i=1:n
    ub(1,3*(i+m+n+m)-2)=max_x;
    lb(1,3*(i+m+n+m)-2)=max_x;
    ub(1,3*(i+m+n+m)-1)=max_y;
    lb(1,3*(i+m+n+m)-1)=min_y;
    ub(1,3*(i+m+n+m))=areas(1,i+1);
    lb(1,3*(i+m+n+m))=areas(1,i);
end
end