declare 
cursor baseline is
  select sql_handle ,plan_name from dba_sql_plan_baselines  
  where last_executed <= '31-MAY-18' ;  
begin                                                                                   
for  c_baseline in baseline;                                                                               
loop                                                                                    
DBMS_SPM.ALTER_SQLPLAN_BASELINE(sql_handle=>c_baseline.sql_handle,plan_name=>c_baseline.plan_name,attribute_name=>'ENABLED',attribute_value=>'NO');
commit;                                                                                 
end loop;                                                                               
end;                                                                                    
/   
