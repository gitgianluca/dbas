select module, substr(sql_text,1,40), count(*) from v$sql group by module, substr(sql_text,1,40) having count(*) > 50 order by count(*)
/
