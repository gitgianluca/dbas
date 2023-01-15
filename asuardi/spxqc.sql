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
col service_name for a15
col qcevent for a32
col idle for 999999
col PX for 999
set lines 170
set trims on
select spxall.*, s.status qcstatus, s.event qcevent from gv$session s,
(
  select count(*) PX, max(idle) idle, spx.qci inst, spx.qcsid sid, spx.sql_id, spx.osuser, spx.service_name, spx.machine, spx.module from (
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
    se.service_name,
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
-- order by px.qcinst_id, px.qcsid, ps.server_name
  ) spx
  where spx.idle > 1200
  group by spx.qci, spx.qcsid, spx.sql_id, spx.osuser, spx.service_name, spx.machine, spx.module
) spxall
where
  spxall.inst = s.inst_id and
  spxall.sid = s.sid
order by idle desc
/
