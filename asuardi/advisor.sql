@nlsdate
col schema for a10
col object_name for a32
col partition_name for a20
--
SELECT
f.task_name,
t.execution_start,
t.execution_end,
o.type AS object_type,
o.attr1 AS schema,
o.attr2 AS object_name,
o.attr3 AS partition_name,
f.message,
r.reclaimable_space
FROM
  dba_advisor_findings f,
  dba_advisor_objects o,
  dba_advisor_tasks t,
  TABLE(dbms_space.asa_recommendations('FALSE', 'FALSE', 'FALSE')) r
WHERE
      f.object_id = o.object_id
  AND f.task_name = o.task_name
  AND f.task_id = t.task_id
  AND f.task_id = r.task_id
  AND o.attr2 = r.segment_name
  AND t.advisor_name = 'Segment Advisor'
  AND t.execution_start > sysdate - 7
  AND (
          (o.type = 'INDEX SUBPARTITION' AND r.reclaimable_space >= 200*1024*1024) -- 200M for index subpartitions
       OR (o.type = 'INDEX PARTITION' AND r.reclaimable_space >= 500*1024*1024) -- 500M for index partitions
       OR (o.type = 'INDEX' AND r.reclaimable_space >= 1024*1024*1024) -- 1G for indexes
       OR (o.type = 'TABLE SUBPARTITION' AND r.reclaimable_space >= 200*1024*1024) -- 500M for table subpartitions
       OR (o.type = 'TABLE PARTITION' AND r.reclaimable_space >= 2*1024*1024*1024) -- 2G for table partitions
       OR (o.type = 'TABLE' AND r.reclaimable_space >= 10*1024*1024*1024) -- 10G for tables
--       OR (o.type = 'TABLE' AND r.reclaimable_space >= 10*1024*1024) -- 10M for tables -- fudged, uncomment to test SQL
  )
ORDER BY
 t.execution_start,
 o.type
/
