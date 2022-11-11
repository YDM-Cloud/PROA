function clear_data()
conn=sqlite("db_operator\202209201650.db","connect");
exec(conn,'delete from base_info');
exec(conn,'delete from iter_history');
exec(conn,'delete from time_history');
end