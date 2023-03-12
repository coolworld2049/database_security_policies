alter table users
    set (
        autovacuum_enabled = true,
        autovacuum_vacuum_threshold = 0,
        autovacuum_vacuum_scale_factor = 0.1
        );

alter system set autovacuum_naptime = '1s';

show autovacuum_naptime;

truncate table users;

select fill_users_table();

select pg_size_pretty(pg_table_size('users'));

select repeat_update_random_rows(percent := 0.05, count := 20);

select pg_size_pretty(pg_table_size('users'));

select autovacuum_count
from pg_stat_all_tables
where relname = 'users';

alter system set autovacuum_naptime = '1min';
