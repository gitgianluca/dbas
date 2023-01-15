col object_type for a20
col segment_type for a20
col object_name for a32
col segment_name for a32
col table_name for a32
col index_name for a32
col avgbufs for 9999999
col avgela for 999999
col avgrows for 9999999
col inst for 99
select
  s.plan_hash_value,
  s.optimizer_cost,
  s.optimizer_env_hash_value,
  sum(s.buffer_gets_delta) bufgets,
  sum(s.disk_reads_delta) phyrds,
  sum(s.executions_delta) execs,
  sum(s.rows_processed_delta) rows_proc,
  sum(s.cpu_time_delta) cputime,
  sum(s.elapsed_time_delta) elapsed,
  cast ((sum(s.elapsed_time_delta)/sum(s.executions_delta))/1000 as number (9,0)) avgela_ms,
  cast ((sum(s.disk_reads_delta)/sum(s.executions_delta)) as number (10,0)) avgphys,
  cast ((sum(s.buffer_gets_delta)/sum(s.executions_delta)) as number (12,0)) avgbufs,
  cast ((sum(s.rows_processed_delta)/sum(s.executions_delta)) as number (8,0)) avgrows
from
  dba_hist_sqlstat s
where
  s.sql_id = '&1'
  and s.executions_delta > 0
group by
  s.plan_hash_value,
  s.optimizer_cost,
  s.optimizer_env_hash_value
order by cast ((sum(s.elapsed_time_delta)/sum(s.executions_delta))/1000 as number (9,0)) desc
/
