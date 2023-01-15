-- break on sql_id
col inst for 99
col qci for 99
col qcsid for 9999
col sid for 9999
col seq# for 999999
col serial# for 999999
col spid for a6
col module for a30
col machine for a15
col username for a10
col osuser for a11
col event for a32
col idle for 999999
set lines 170
set trims on
-- note: first_logon_time from PX slaves follows the QC rather than the PX process itself
select
  px.qcinst_id qci,
  px.qcsid,
  se.inst_id inst,
  se.sid,
  se.serial#,
--  se.seq#,
  ps.server_name,
  substr(se.module,1,25) module,
  substr(se.machine,1,15) machine,
--  se.username,
  se.osuser,
  se.status,
  ps.status,
  se.event,
  se.sql_id,
--  se.logon_time,
  se.last_call_et idle
from
  gv$session se, 
  gv$px_session px,
  gv$px_process ps
where
  se.inst_id = px.inst_id and se.sid = px.sid and
  se.inst_id = ps.inst_id and se.sid = ps.sid and
  ps.server_name not like 'PZ%' and
  qcinst_id is not null
-- order by se.sql_id, Px.qcinst_id, Px.sid
order by px.qcinst_id, px.qcsid, ps.server_name
/
