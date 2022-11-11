function statistics_result=statistics_p_best(D)

addpath("algorithms\");
addpath("CEC\");

CEC_functions={F1, F2, F3, F4, F5, F6, F7, F8, F9, F10,...
    F11, F12, F13, F14, F15, F16, F17, F18, F19, F20,...
    F21, F22, F23, F24, F25, F26, F27, F28, F29, F30,...
    F31, F32, F33, F34, F35, F36, F37, F38, F39, F40,...
    F41, F42, F43, F44, F45};
CEC_functions_high={F15, F16, F17,...
    F22, F23, F24, F25, F26,...
    F41, F42, F43, F44};
if ~isnan(D)
    CEC_functions=CEC_functions_high;
end

algorithms={'AEFA','WSO','STOA','SSA','ROA','PROA'};
n_cec=length(CEC_functions);
n_alg=length(algorithms);
statistics_result=cell(n_cec+1,n_alg+1);
conn=sqlite("db_operator\202209201650.db","connect");

for i=1:n_alg
    statistics_result{1,i+1}=algorithms{i};
end
for i=1:n_cec
    row_name=metaclass(CEC_functions{i}).Name;
    statistics_result{i+1,1}=row_name;
end

for i=1:n_cec
    f=CEC_functions{i};
    f_name=metaclass(f).Name;
    for j=1:n_alg
        alg_name=algorithms{j};
        if isnan(D)
            sql_D=f.D;
        else
            sql_D=D;
        end
        sql=sprintf('select p_best from base_info where name="%s" and F="%s" and D=%d',alg_name,f_name,sql_D);
        p_bests=fetch(conn,sql);
        p_bests=cell2mat(p_bests);
        statistics_result{i+1,j+1}=p_bests;
    end
end
statistics_result=statistics_result';
end