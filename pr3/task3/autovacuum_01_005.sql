drop table if exists users;
create table users
(
    id       serial primary key,
    username varchar(255),
    email    varchar(255),
    category char(3)
);

alter table users
    set (autovacuum_enabled = true);
alter system reset maintenance_work_mem;
alter system set autovacuum_naptime = '1s';
alter system set autovacuum_vacuum_threshold = 0;
alter system set autovacuum_vacuum_scale_factor = 0.1;

select pg_reload_conf();

call fill_users_table();

select pg_size_pretty(pg_table_size('users'));

call repeat_update_random_rows(percent := 0.1, count := 20);

select pg_size_pretty(pg_table_size('users'));

select autovacuum_count
from pg_stat_all_tables
where relname = 'users';


