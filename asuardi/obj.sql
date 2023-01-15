select owner, segment_name, segment_type, partition_name
 from dba_extents
where file_id = &file_id
  and &blockno between block_id and (block_id + blocks - 1)
/
