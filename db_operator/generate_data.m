function generate_data(CEC_functions,NP,GMAX,N,D_custom)
addpath("..\CEC\");
addpath("..\algorithms\");

id=0;

for j=1:length(CEC_functions)
    f=CEC_functions{j};
    if isnan(D_custom)
        D=f.D;
    else
        D=D_custom;
    end
    lb=ones(1,D)*f.R(1);
    ub=ones(1,D)*f.R(2);
    f_name=metaclass(f).Name;

    for i=1:N
        X=zeros(NP,D);
        for d=1:D
            X(:,d)=unifrnd(lb(1,d),ub(1,d),NP,1);
        end

        % ROA
        [p_best,x_best,p_history,time_stamp_history,time_p_best_history]=ROA(X,GMAX,lb,ub,@f.F);
        insert_data(id,'ROA',f_name,i,NP,D,GMAX,p_best,p_history,time_stamp_history,time_p_best_history);
        id=id+1;

        % PROA
        [p_best,x_best,p_history,time_stamp_history,time_p_best_history]=PROA(X,GMAX,lb,ub,@f.F);
        insert_data(id,'PROA',f_name,i,NP,D,GMAX,p_best,p_history,time_stamp_history,time_p_best_history);
        id=id+1;

        % AEFA
        [p_best,x_best,p_history,time_stamp_history,time_p_best_history]=AEFA(X,GMAX,lb,ub,@f.F);
        insert_data(id,'AEFA',f_name,i,NP,D,GMAX,p_best,p_history,time_stamp_history,time_p_best_history);
        id=id+1;

        % WSO
        [p_best,x_best,p_history,time_stamp_history,time_p_best_history]=WSO(X,GMAX,lb,ub,@f.F);
        insert_data(id,'WSO',f_name,i,NP,D,GMAX,p_best,p_history,time_stamp_history,time_p_best_history);
        id=id+1;

        % STOA
        [p_best,x_best,p_history,time_stamp_history,time_p_best_history]=STOA(X,GMAX,lb,ub,@f.F);
        insert_data(id,'STOA',f_name,i,NP,D,GMAX,p_best,p_history,time_stamp_history,time_p_best_history);
        id=id+1;

        % SSA
        [p_best,x_best,p_history,time_stamp_history,time_p_best_history]=SSA(X,GMAX,lb,ub,@f.F);
        insert_data(id,'SSA',f_name,i,NP,D,GMAX,p_best,p_history,time_stamp_history,time_p_best_history);
        id=id+1;


        % log
        status=sprintf('[%s] completed: %s,N%d',datestr(now,'yyyy/mm/dd HH:MM:SS.FFF'),f_name,i);
        disp(status);
    end
end
end