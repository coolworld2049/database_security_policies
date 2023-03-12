alter table users set (autovacuum_enabled = false);

truncate table users;

select fill_users_table();

explain
select *
from users
where category = 'FOO';

explain analyze
select *
from users
where category = 'FOO';
