set transaction isolation level read committed;

begin;

update accounts
set balance = balance - 200
where name = 'alice';

select *
from accounts
where name = 'alice';

commit;