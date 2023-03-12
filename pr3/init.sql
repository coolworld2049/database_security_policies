create database vacuum_db;

drop table if exists users;

create table users
(
    id       serial primary key,
    username varchar(255),
    email    varchar(255),
    category char(3)
);

create or replace function fill_users_table(count integer = 1000000, _category text = 'FOO') returns void as
$$
begin
    alter sequence users_id_seq restart with 1;
    insert into users(username, email, category) select 'AxAAA', 'AxAAA', _category from generate_series(1, count);
end;
$$ language plpgsql;
