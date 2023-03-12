alter table users set (autovacuum_enabled = false);

truncate table users;

select fill_users_table();

select pg_size_pretty(pg_table_size('users'));


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

vacuum full verbose users;

select pg_size_pretty(pg_table_size('users'));

