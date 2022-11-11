function result=select_data(F_class,name,idx,D,NP,g_max,history_type)
if isnan(name)
    name='';
end
if isnan(idx)
    idx=-1;
end
if isnan(D)
    D=F_class.D;
end
if isnan(NP)
    NP=50;
end
if isnan(g_max)
    g_max=10000;
end
F=metaclass(F_class).Name;

conn=sqlite("db_operator\202209201650.db","connect");
figure_name=sprintf('[%s] NP%d,D%d,GMAX%d',F,NP,D,g_max);
figure("Name",figure_name);
sql=sprintf('select * from base_info where (name="%d" or ""="%d") and (idx=%d or -1=%d) and F="%s" and NP=%d and D=%d and g_max=%d order by name,idx',name,name,idx,idx,F,NP,D,g_max);
data_list=fetch(conn,sql);
species=unique(data_list(:,2));
markers = ['o', 'v', 's', 'p', '*', '+', 'x', 'd','>','h'];
hold off;

if history_type=='t'
    % time stamp
    subplot(1,2,1);
    for i=1:size(data_list,1)
        data_id=data_list{i,1};
        sql=sprintf('select time_stamp,time_best from time_history where base_info_id=%d order by time_stamp',data_id);
        data_time_history=fetch(conn,sql);
        data_time_history=cell2mat(data_time_history);

        data_name=data_list{i,2};
        data_idx=data_list{i,4};
        species_idx=ismember(species,data_name);
        species_idx=find(species_idx==1);
        marker_idx=1:10:size(data_time_history,1);
        plot(data_time_history(:,1),data_time_history(:,2),"Marker",markers(species_idx),"DisplayName",sprintf('%s-%d',data_name,data_idx),"MarkerIndices",marker_idx);
        hold on;
    end
    legend();
    title('time stamp');
elseif history_type=='i'
    % iteration
    subplot(1,2,1);
    for i=1:size(data_list,1)
        data_id=data_list{i,1};
        sql=sprintf('select iter_idx,iter_best from iter_history where base_info_id=%d order by iter_idx',data_id);
        data_iter_history=fetch(conn,sql);

        data_name=data_list{i,2};
        data_idx=data_list{i,4};
        species_idx=ismember(species,data_name);
        species_idx=find(species_idx==1);
        marker_idx=1:10:size(data_iter_history,1);
        plot(cell2mat(data_iter_history(:,1)),cell2mat(data_iter_history(:,2)),"Marker",markers(species_idx),"DisplayName",sprintf('%s-%d',data_name,data_idx),"MarkerIndices",marker_idx);
        hold on;
    end
    legend();
    title('iteration');
end

% p_best
subplot(1,2,2);
for i=1:length(species)
    data_name=species{i};
    species_data=[];
    for j=1:size(data_list,1)
        if strcmp(data_list{j,2},data_name)
            species_data=[species_data,data_list{j,end}];
        end
    end
    plot(1:length(species_data),species_data,"Marker",markers(i),"DisplayName",data_name);
    hold on;
end
legend();
title('p best');

result=data_list;
end
