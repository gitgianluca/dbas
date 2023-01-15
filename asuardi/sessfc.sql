select * from v$session_fix_control where session_id=(select distinct sid from v$mystat) order by bugno
/
