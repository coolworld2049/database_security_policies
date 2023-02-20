set transaction isolation level serializable;

begin;

select *
from accounts
order by id;

select transfer_funds(1, 2, 500);

select *
from accounts
order by id;

commit;