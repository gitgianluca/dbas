col execs for 9999999
col rowcnt for 999999999
col child for 99
col first_load_time for a25
select
 s.sid,
 s.seq#,
 s.status,
 s.sql_id,
 sq.child_number child,
 s.event,
 pxs.mxdeg,
 pxs.actual,
 sq.buffer_gets,
 sq.disk_reads,
 sq.executions execs,
 sq.rows_processed rowcnt,
 sq.first_load_time
 from
   (select qcsid, max(degree) mxdeg, max(req_degree) mxreq, count(*) actual from v$px_Session
    group by qcsid) pxs,
   v$session s,
   v$sql sq
where
   s.sid = pxs.qcsid and
   s.sql_id = sq.sql_id
order by s.sid
/

