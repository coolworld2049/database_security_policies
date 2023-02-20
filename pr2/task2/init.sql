create extension if not exists pageinspect;

-- Создать базу данных с именем versions_db. Создать таблицу users со следующими полями:
-- id: уникальный идентификатор пользователя (integer, primary key, auto-increment).
-- username: имя пользователя (varchar(255)).
-- email: электронный адрес пользователя (varchar(255)).
-- version: версия строки (integer).

drop table if exists users;
create table if not exists users
(
    id       serial primary key,
    username varchar(255),
    email    varchar(255),
    version  integer default 0
);

create or replace function increment_user_version() returns trigger as
$$
begin
    new.version := new.version + 1;
    return new;
end;
$$ language plpgsql;


drop trigger if exists tg_increment_user_version on users;
create or replace trigger tg_increment_user_version
    before insert or update
    on users
    for each row

execute function increment_user_version();


insert into users(username, email)
values ('zxc', 'zxc@gmail.com')
returning *, ctid, xmin, xmax;


truncate table users;


set transaction isolation level read committed;

begin;

insert into users(username, email)
values ('zxc', 'zxc@gmail.com')
returning *, ctid, xmin, xmax;

savepoint zxc;

insert into users(username, email)
values ('zxc', 'zxc@gmail.com')
returning *, ctid, xmin, xmax;

rollback to zxc;

insert into users(username, email)
values ('zxc', 'zxc@gmail.com')
returning *, ctid, xmin, xmax;


commit;