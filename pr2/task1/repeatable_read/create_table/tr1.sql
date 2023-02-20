set transaction isolation level repeatable read;

begin;

select 1;

select *
from pg_tables
where schemaname = 'public';
select *
from public.user;

commit;