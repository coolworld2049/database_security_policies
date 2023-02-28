drop table if exists accounts;
create table if not exists accounts
(
    id      serial primary key,
    name    text                                          not null,
    balance numeric
        constraint balance_gt_zero check ( balance >= 0 ) not null
);


create extension if not exists pageinspect;



create or replace function random_between(low int, high int)
    returns int as
$$
begin
    return floor(random() * (high - low + 1) + low);
end;
$$ language 'plpgsql' strict;


create or replace function random_string(length integer) returns text as
$$
declare
    chars  text[]  := '{0,1,2,3,4,5,6,7,8,9,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z}';
    result text    := '';
    i      integer := 0;
begin
    if length < 0 then
        raise exception 'given length cannot be less than 0';
    end if;
    for i in 1..length
        loop
            result := result || chars[1 + random() * (array_length(chars, 1) - 1)];
        end loop;
    return result;
end;
$$ language plpgsql;


drop function if exists transfer_funds(_from integer, _to integer, amount numeric);
create or replace function transfer_funds(_from integer, _to integer, amount numeric) returns boolean as
$$
begin
    update accounts set balance = balance - amount where id = _from;
    update accounts set balance = balance + amount where id = _to;
    return true;
exception
    when others then
        return false;
end;
$$ language plpgsql;


create or replace function fill_accounts_table(insert_into_accounts_op_count integer) returns void as
$$
begin
    for i in 1..insert_into_accounts_op_count
        loop
            insert into accounts(name, balance) values (random_string(10), random_between(10000000, 100000000));
        end loop;
end;
$$ language plpgsql;


drop function if exists test_transfer_funds(transfer_funds_op_count integer, transfer_funds_amount integer);
create or replace function test_transfer_funds(transfer_funds_op_count integer, transfer_funds_amount integer) returns void as
$$
declare
    op_result boolean;
    rand_from integer;
begin
    for i in 1..transfer_funds_op_count
        loop
            rand_from := random_between(i, transfer_funds_op_count);
            if rand_from != i then
                select transfer_funds(rand_from, i, transfer_funds_amount)
                into op_result;
            end if;
            --raise notice 'transfer_funds(_from: %, _to: %) --> success=%', rand_from, i, op_result::text;
        end loop;
end;
$$ language plpgsql;



drop function if exists test_analyze_update();
create or replace function test_analyze_update() returns setof text as
$$
begin
    truncate table accounts;
    perform fill_accounts_table(100);
    for i in 1..50
        loop
            return query explain (analyze) select test_transfer_funds(100000, 7899);
        end loop;
end;
$$ language plpgsql;


drop function if exists test_analyze_insert();
create or replace function test_analyze_insert() returns setof text as
$$
begin
    for i in 1..50
        loop
            return query explain (analyze) select fill_accounts_table(10000);
        end loop;
end;
$$ language plpgsql;


alter table accounts
    set (fillfactor = 100);
--test_analyze_update.fill-factor=100
select test_analyze_update();

--test_analyze_insert.fill-factor=100
--select test_analyze_insert();


alter table accounts
    set (fillfactor = 50);
--test_analyze_update.fill-factor=50
select test_analyze_update();

--test_analyze_insert.fill-factor=50
select test_analyze_insert();
--select test_analyze_update()