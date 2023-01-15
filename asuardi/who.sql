col sid for 9999
col serial# for 999999
col program for a30
col module for a30
col machine for a30
select
  se.sid, se.serial#, se.program, se.module, se.action, se.machine, se.status, se.sql_hash_value, se.sql_id,
  sq.sql_text, sq.buffer_gets, sq.disk_reads, sq.executions, sq.rows_processed, se.logon_time, sq.first_load_time
from
  v$session se, v$sql sq
where
  sid=&sessionid and
  se.sql_hash_value = sq.hash_value
/
