declare
myplan pls_integer;
begin
myplan:=DBMS_SPM.ALTER_SQL_PLAN_BASELINE (sql_handle =>'&sql_handle',plan_name=>'&plan_name',attribute_name =>'ENABLED',attribute_value =>'NO');
end;
/
