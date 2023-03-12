create or replace function update_random_rows(percent float = 0.05) returns void as
$$
declare
    min_id  integer = (select min(id)
                       from users);
    max_id  integer = (select max(id)
                       from users);
    _offset integer = (max_id * percent)::integer;
    start   integer;
    stop    integer;
begin
    start = min_id + _offset * random_between(min_id, (percent * 100)::integer);
    stop = start + _offset;
    raise notice 'percent=%, start=%, stop=%, _offset=%', percent, start, stop, _offset;
    for i in start..stop
        loop
            update users
            set username = reverse(username)
            where id = i;
        end loop;
end;
$$ language plpgsql;


create or replace function repeat_update_random_rows(percent float = 0.05, count int = 20)
    returns void as
$$
begin
    for i in 1..count
        loop
            perform pg_sleep(1);
            perform update_random_rows(percent);
            raise notice 'iter=%, update_random_rows(percent=%)', i, percent;
        end loop;
end;
$$ language plpgsql;

