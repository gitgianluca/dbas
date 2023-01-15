-- execute dbms_sqltune.execute_tuning_task('Tune_cp8z3r75sgt9d');

SELECT dbms_sqltune.report_tuning_task('Tune_cp8z3r75sgt9d', 'TEXT', 'ALL') FROM dual;
