set transaction isolation level read committed;

begin;

select *
from accounts
where name = 'alice';

commit;