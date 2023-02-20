set transaction isolation level repeatable read;

begin;

select pg_export_snapshot();
select 1;
select pg_export_snapshot();

select *
from accounts
where name = 'alice';

commit;