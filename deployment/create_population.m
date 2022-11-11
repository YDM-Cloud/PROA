function x=create_population(NP,lb,ub)
D=length(lb);
x=zeros(NP,D);
for i=1:D
    a=lb(1,i);
    b=ub(1,i);
    x(:,i)=a+(b-a)*rand(NP,1);
end
end