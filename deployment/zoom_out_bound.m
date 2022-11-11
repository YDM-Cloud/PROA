function bound=zoom_out_bound(aabb)
% x+-/y+/z+- zoom in
zoom_factor=0.2;
minx=aabb(1,1);
miny=aabb(1,2);
minz=aabb(1,3);
maxx=aabb(1,4);
maxy=aabb(1,5);
maxz=aabb(1,6);
miny=miny+20;
maxy=maxy+20;
center=[(maxx+minx)/2,(maxy+miny)/2,(maxz+minz)/2];
maxx=(maxx-center(1,1))*(1+zoom_factor)+center(1,1);
maxy=(maxy-center(1,2))*(1+zoom_factor)+center(1,2);
maxz=(maxz-center(1,3))*(1+zoom_factor)+center(1,3);
minx=(minx-center(1,1))*(1+zoom_factor)+center(1,1);
minz=(minz-center(1,3))*(1+zoom_factor)+center(1,3);
bound=[minx,miny,minz,maxx,maxy,maxz];
end