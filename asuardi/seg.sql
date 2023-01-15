col segment_name for a32
col segment_type for a20
select owner, segment_name, segment_type, blocks, tablespace_name
 from dba_segments where
segment_name=upper('&seg')
/
