col oracle_username for a15
col action for a32
select session_id, serial#, module, action, oracle_username, object_id, locked_mode
from v$locked_object l, v$session s
 where object_id=41513
   and l.session_id = s.sid
/
