alter session set "_fix_control"='12341619:off','8560951:on';

var res number ;
exec :res := dbms_spm.load_plans_from_cursor_cache(sql_id => '2twba3ta0tpuq', plan_hash_value => '3314628291' );

