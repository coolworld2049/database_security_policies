set transaction isolation level repeatable read;

begin;

delete
from accounts
where name = 'alice';


select *
from accounts
where name = 'alice';

commit;