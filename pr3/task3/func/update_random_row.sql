create or replace procedure repeat_update_random_rows(percent float = 0.05, count int = 20) as
$$
begin
    for i in 0..count
        loop
            perform pg_sleep(2);
            raise notice 'sleep %', 2;

            update users
            set username = random_string(100)
            where random() < percent;

            commit;

            raise notice 'iter=%, update_random_rows(percent=%)', i, percent;
        end loop;
end;
$$ language plpgsql;

