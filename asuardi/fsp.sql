col a for 999,999,999,999,999
select tablespace_name, sum(bytes) a from dba_free_space
 group by tablespace_name
 order by tablespace_name
/
