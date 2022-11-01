
 set feedback on;
 Column sql_handle format a20
 Column plan_name format a30

 SELECT sql_handle, plan_name, enabled, accepted ,reproduced
 FROM dba_sql_plan_baselines
 where sql_text like '%&&Part_of_my_query%';



 SET LINESIZE 150
 SET PAGESIZE 2000

 SELECT t.*
 FROM (SELECT DISTINCT sql_handle
 FROM dba_sql_plan_baselines
 WHERE sql_text like '%&Part_of_my_query%') pb,
 TABLE(DBMS_XPLAN.DISPLAY_SQL_PLAN_BASELINE(pb.sql_handle, NULL , 'TYPICAL'
 )) t;
