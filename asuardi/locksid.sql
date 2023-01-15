col program for a25
col machine for a20
col module for a15
col sid for 999
col obj for 999999
col username for a12
select lo.object_id obj, s.username, s.sid, s.status, s.machine, s.program, s.module, s.last_call_et, s.sql_hash_value from v$locked_object lo, v$session s
 where lo.object_id = 3700
   and s.sid = lo.session_id
/
