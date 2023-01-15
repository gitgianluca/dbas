DECLARE
  stmt_task VARCHAR2(64);
BEGIN
  stmt_task:=dbms_sqltune.create_tuning_task(sql_id => '2twba3ta0tpuq', plan_hash_value => '3314628291', time_limit => 3600, task_name => 'Tune_2twba3ta0tpuq', description => '2twba3ta0tpuq sql tuning');
END;

