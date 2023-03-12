alter table users set (autovacuum_enabled = false);

truncate table users;

select fill_users_table();

update users
set category = 'BPP'
where category = 'FOO';

alter system set maintenance_work_mem = '1MB';

select pg_reload_conf();


vacuum verbose users;

alter system reset maintenance_work_mem;

select pg_reload_conf();