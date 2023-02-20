set transaction isolation level read committed;

begin;

select *
from accounts
where name = 'alice';

select pg_sleep(10);

select *
from accounts
where name = 'alice';

commit;