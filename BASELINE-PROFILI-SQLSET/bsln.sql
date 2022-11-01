col sql_handle for a20
col sqltxt for a60
col created for a15
col last_executed for a15
col cpu_time for 999999999999
select
  sql_handle,
  plan_name,
  substr(sql_text, 1, 60) sqltxt,
  to_char(created, 'dd-mon-yy hh24:mi:ss'),
  to_char(last_executed, 'dd-mon-yy hh24:mi:ss'),
  enabled,
  accepted,
  fixed,
  cpu_time,
  executions,
  buffer_gets /*,
  disk_reads,
  rows_processed
*/
from dba_sql_plan_baselines
order by created
/
