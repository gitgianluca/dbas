SET SERVEROUTPUT ON
DECLARE
  l_plans_unpacked  PLS_INTEGER;
BEGIN
  l_plans_unpacked := DBMS_SPM.unpack_stgtab_baseline(
    table_name      => 'STGTAB_CP8_2',
    table_owner     => 'SYSMAN');

  DBMS_OUTPUT.put_line('Plans Unpacked: ' || l_plans_unpacked);
END;
/
