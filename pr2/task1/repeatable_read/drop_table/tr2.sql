drop table if exists "user";
create table "user"
(
    id        bigserial primary key,
    full_name text
);

set transaction isolation level repeatable read;

begin;

drop table if exists "user";
select *
from pg_tables
where tablename = 'user';

rollback;
select *
from pg_tables
where tablename = 'user';

commit;
