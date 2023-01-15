col sid for 9999
col seq# for 99999
col event for a33
col p1text for a14
col p1 for 99999999999999
col p2text for a12
col p3text for a9
select inst_id, sid, seq#, sql_id, event, p1text, p1, p2text, p2, p3text, p3 from gv$session  where wait_class != 'Idle' and event not in ('SQL*Net message to client')
/
