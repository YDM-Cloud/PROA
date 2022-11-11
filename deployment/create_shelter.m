function shelter=create_shelter()
n_points=10000;
a=rand(1,n_points)*2*pi;
r=rand(1,n_points);
x=sqrt(r).*cos(a);
z=sqrt(r).*sin(a);
y=zeros(1,n_points);
shelter=[x;y;z]';
end