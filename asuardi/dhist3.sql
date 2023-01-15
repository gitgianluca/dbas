-- usare x invalidations

col begin_snap for a20
col object_type for a20
col segment_type for a20
col object_name for a32
col segment_name for a32
col table_name for a32
col index_name for a32
col avgbufs for 999999999
col avgela for 999999
col avgrows for 9999999
col inst for 99
col username for a6
select
  s.instance_number inst,
  s.snap_id,
  to_char(t.BEGIN_INTERVAL_TIME, 'YYYY-MON-DD HH24:MI:SS'),
  s.parsing_schema_name username,
/*
  s.buffer_gets_delta, s.disk_reads_delta, s.executions_delta, s.rows_processed_delta,
*/
  s.executions_delta, s.rows_processed_delta,
  s.cpu_time_delta, s.elapsed_time_delta,
  s.parse_calls_delta, s.invalidations_delta, s.loads_delta,
  s.plan_hash_value,
  cast ((s.elapsed_time_delta/s.executions_delta)/1000 as number (9,0)) avgela_ms,
  cast ((s.disk_reads_delta/s.executions_delta) as number (10,0)) avgphys,
  cast ((s.buffer_gets_delta/s.executions_delta) as number (12,0)) avgbufs,
  cast ((s.rows_processed_delta/s.executions_delta) as number (8,0)) avgrows
from
  dba_hist_sqlstat s, dba_hist_snapshot t
where
  s.sql_id = '&1'
  and s.executions_delta > 0
  and s.snap_id = t.snap_id
  and s.dbid = t.dbid
order by snap_id, cast ((s.elapsed_time_delta/s.executions_delta)/1000 as number (9,0)) desc
/

