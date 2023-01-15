col username for a14

select /*+ ordered */ s.username, s.sid, s.sql_id, s.status, s.event, o.object_name, o.object_type, o.object_id, l.locked_mode
 from
   v$locked_object l,
   dba_objects o,
   v$session s
where
   s.sid = l.session_id and
   l.object_id = o.object_id
/

