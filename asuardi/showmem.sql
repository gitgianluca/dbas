col name for a32
col value for a32
select name, value from v$parameter
 where name in (
   'memory_target',
   'memory_max_target',
   'sga_target',
   'sga_max_size',
   'pga_aggregate_target',
   'shared_pool_size',
   'db_cache_size',
   'db_2k_cache_size',
   'db_4k_cache_size',
   'db_8k_cache_size',
   'db_16k_cache_size',
   'db_32k_cache_size',
   'large_pool_size',
   'java_pool_size',
   'streams_pool_size'
)
 and value != '0'
/

