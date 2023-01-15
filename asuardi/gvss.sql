col tablespace_name for a12
select
       tablespace_name, inst_id, current_users, used_blocks, free_blocks, added_extents,
       extent_hits, freed_extents, free_requests, max_blocks, max_used_blocks, max_sort_blocks
 from gv$sort_segment
 order by tablespace_name, inst_id
/
