function visiblePtInds = HPR(p,C)
% description: direct visiblity of point sets
% p: points
% C: camera position
% param: diameter factor
% return: visible point indices
param=2;
dim=size(p,2);
numPts=size(p,1);
% move the points s.t. C is the origin
p=p-repmat(C,[numPts 1]);
% calculate ||p||
normp=sqrt(dot(p,p,2));
% sphere radius
R=repmat(max(normp)*(10^param),[numPts 1]);
% spherical flipping
P=p+2*repmat(R-normp,[1 dim]).*p./repmat(normp,[1 dim]);
% convex hull
visiblePtInds=unique(convhulln([P;zeros(1,dim)]));
visiblePtInds(visiblePtInds==numPts+1)=[];
visiblePtInds=visiblePtInds';
end
