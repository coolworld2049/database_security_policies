alter table users
    set (autovacuum_enabled = false);

truncate table users;

select fill_users_table(5000000);

select pg_size_pretty(pg_table_size('users'));

create or replace function random_between(low bigint, high bigint)
    returns int as
$$
begin
    return floor(random() * (high - low + 1) + low);
end;
$$ language 'plpgsql' strict;

do
$$
    declare
        sm integer = 2;
    begin
        for i in 1..(select count(*) from users)
            loop
                if sm / 2 != 0 then
                    delete from users where id = i;
                end if;
                sm = random_between(1, 10);
            end loop;
    end;
$$ language plpgsql;

vacuum verbose users;

select pg_size_pretty(pg_table_size('users'));

