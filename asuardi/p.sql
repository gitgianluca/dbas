set serveroutput on
DECLARE
  plans NUMBER;
  description VARCHAR2(500);
  sys_sql_handle VARCHAR2(30);
  sys_plan_name VARCHAR2(30);
BEGIN
  -- create sql_plan_baseline for original sql using plan from modified sql
  plans :=
  DBMS_SPM.LOAD_PLANS_FROM_CURSOR_CACHE (
    sql_id          => TRIM('66vwnj8575mu5'),
    plan_hash_value => TO_NUMBER(TRIM('2802000062'))
  );
  DBMS_OUTPUT.PUT_LINE('Plans Loaded: '||plans);
END;
/
