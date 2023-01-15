col segment_name for a18
col extent_management for a10
col extents for 9999
select
 owner,
 segment_name,
 partition_name,
 segment_type,
 dt.tablespace_name,
 extent_management extmgmt,
 bytes,
 extents,
 bytes/extents extsize
from
 dba_segments ds,
 dba_tablespaces dt
where
 extents > 100 and
 segment_type != 'TEMPORARY' and
 extent_management != 'LOCAL' and
 ds.tablespace_name=dt.tablespace_name
order by
 extsize
desc
/
