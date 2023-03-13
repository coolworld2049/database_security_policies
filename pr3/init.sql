create database vacuum_db;

drop table if exists users;

create table users
(
    id       serial primary key,
    username varchar(255),
    email    varchar(255),
    category char(3)
);



create or replace procedure fill_users_table(count integer = 1000000, _category text = 'FOO') as
$$
begin
    insert into users(username, email, category)
    select random_string(12), random_string(12), _category
    from generate_series(1, count);
    commit;
end;
$$ language plpgsql;



create or replace function random_between(low bigint, high bigint)
    returns int as
$$
begin
    return floor(random() * (high - low + 1) + low);
end;
$$ language 'plpgsql' strict;



Create or replace function random_string(length integer) returns text as
$$
declare
    chars  text[] := '{0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z}';
    result text   := '';
begin
    if length < 0 then
        raise exception 'Given length cannot be less than 0';
    end if;
    for i in 1..length
        loop
            result := result || chars[1 + random() * (array_length(chars, 1) - 1)];
        end loop;
    return result;
end;
$$ language plpgsql;