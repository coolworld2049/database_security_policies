set transaction isolation level repeatable read;

begin;

select *
from pg_tables
where tablename = 'user';

commit;