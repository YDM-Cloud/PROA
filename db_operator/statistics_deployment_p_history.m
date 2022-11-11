function statistics_result=statistics_deployment_p_history()
conn=sqlite("db_operator\202209201650.db","connect");

algorithms={'ROA','PROA'};
f_name='deployment6';
n_alg=length(algorithms);
statistics_result=cell(2,n_alg+1);
statistics_result{2,1}=f_name;

for i=1:n_alg
    statistics_result{1,i+1}=algorithms{i};
end

for j=1:n_alg
    alg_name=algorithms{j};
    sql=sprintf('select id from deployment_base_info where name="%s" and F="%s" order by idx',alg_name,f_name);
    ids=fetch(conn,sql);
    ids=cell2mat(ids);
    n_ids=length(ids);
    ids_str=mat2str(ids);
    ids_str=strrep(ids_str,';',',');
    ids_str(1)='(';
    ids_str(end)=')';
    sql=sprintf('select iter_best from deployment_iter_history where base_info_id in %s order by base_info_id,iter_idx',ids_str);
    histories=fetch(conn,sql);
    histories=cell2mat(histories);
    histories=reshape(histories,500,n_ids)';
    statistics_result{2,j+1}=mean(histories);
end
end