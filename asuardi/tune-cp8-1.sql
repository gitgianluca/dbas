DECLARE
  stmt_task VARCHAR2(64);
BEGIN
  stmt_task:=dbms_sqltune.create_tuning_task(sql_id => 'cp8z3r75sgt9d', plan_hash_value => '779095498', time_limit => 3600, task_name => 'Tune_cp8z3r75sgt9d', description => 'cp8z3r75sgt9d sql tuning');
END;
