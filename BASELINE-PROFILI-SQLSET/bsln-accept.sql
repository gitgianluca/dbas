SET SERVEROUTPUT ON
SET LONG 10000
DECLARE
    report clob;
BEGIN
report := dbms_spm.evolve_sql_plan_baseline
(sql_handle => '&sql_handle',
 plan_name =>  '&plan_name',
 VERIFY=>'NO' ,
 COMMIT=>'YES');
DBMS_OUTPUT.PUT_LINE(report);
END;
/
