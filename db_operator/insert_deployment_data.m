function insert_deployment_data(id,name,F,index,NP,D,g_max,p_best,iter_history,time_stamp_history,time_p_best_history,x_best,x_history)
conn=sqlite("db_operator\202209201650.db","connect");
% base_info
sql=sprintf('insert into base_info(id,name,F,idx,NP,D,g_max,p_best) values(%d,"%s","%s",%d,%d,%d,%d,%f)',id,name,F,index,NP,D,g_max,p_best);
exec(conn,sql);
% iter_history
g=length(iter_history);
sql_data=[ones(1,g)*id;1:g;iter_history]';
step=1000;
n=ceil(g/step);
for i=1:n
    if i~=n
        insert(conn,'iter_history',{'base_info_id','iter_idx','iter_best'},sql_data(step*(i-1)+1:step*i,:));
    else
        insert(conn,'iter_history',{'base_info_id','iter_idx','iter_best'},sql_data(step*(i-1)+1:end,:));
    end
end
% x_best
x_best=[id,x_best];
insert(conn,'deployment_x_best',{'base_info_id','x1','x2','x3','x4','x5','x6','x7','x8','x9','x10','x11','x12','x13','x14','x15','x16','x17','x18'},x_best);
% x_history
x_history=[ones(g,1)*id,x_history];
insert(conn,'deployment_x_history',{'base_info_id','x1','x2','x3','x4','x5','x6','x7','x8','x9','x10','x11','x12','x13','x14','x15','x16','x17','x18'},x_history);
% time_history
g=length(time_stamp_history);
sql_data=[ones(g,1)*id,time_stamp_history,time_p_best_history];
n=ceil(g/step);
for i=1:n
    if i~=n
        insert(conn,'time_history',{'base_info_id','time_stamp','time_best'},sql_data(step*(i-1)+1:step*i,:));
    else
        insert(conn,'time_history',{'base_info_id','time_stamp','time_best'},sql_data(step*(i-1)+1:end,:));
    end
end
end
