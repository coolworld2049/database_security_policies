create extension if not exists pageinspect;

-- создать таблицу t с полями id(integer) и name (char(2)) с параметром filfactor = 75%.

drop table if exists t;
create table if not exists t
(
    id   integer,
    name char(2000)
) with (fillfactor = 80);

drop index if exists name_idx;
create index name_idx on t (name);


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



-- флаг heap hot updated показывает, что надо идти по цепочке ctid,
-- флаг heap only tuple показывает, что на данную версию строки нет ссылок из индексов.

drop view if exists t_v;
create view t_v as
select '(0,' || lp || ')'                               as ctid,
       case lp_flags
           when 0 then 'unused'
           when 1 then 'normal'
           when 2 then 'redirect to ' || lp_off
           when 3 then 'dead'
           end                                          as state,
       t_xmin || case
                     when (t_infomask & 256) > 0 then ' (c)'
                     when (t_infomask & 512) > 0 then ' (a)'
                     else ''
           end                                          as xmin,
       t_xmax || case
                     when (t_infomask & 1024) > 0 then ' (c)'
                     when (t_infomask & 2048) > 0 then ' (a)'
                     else ''
           end                                          as xmax,
       case when (t_infomask2 & 16384) > 0 then 't' end as hhu,
       case when (t_infomask2 & 32768) > 0 then 't' end as hot,
       t_ctid
from heap_page_items(get_raw_page('t', 0))
order by lp;

------------------------------------------------------------------------------------------------------------------------

select current_setting('block_size');

insert into t
values (1, (select random_string(10)));

select *
from t_v;

select lower, upper, pagesize
from page_header(get_raw_page('t', 0));



update t
set name = (select random_string(10))
where id = 1;

select *
from t_v;

select lower, upper, pagesize
from page_header(get_raw_page('t', 0));



update t
set name = (select random_string(10))
where id = 1;

select *
from t_v;

select lower, upper, pagesize
from page_header(get_raw_page('t', 0));



update t
set name = (select random_string(10))
where id = 1;

select *
from t_v;

select lower, upper, pagesize
from page_header(get_raw_page('t', 0));



update t
set name = (select random_string(10))
where id = 1;

select *
from t_v;

select lower, upper, pagesize
from page_header(get_raw_page('t', 0));



update t
set name = (select random_string(10))
where id = 1;

select *
from t_v;

select lower, upper, pagesize
from page_header(get_raw_page('t', 0));



update t
set name = (select random_string(10))
where id = 1;

select *
from t_v;

select lower, upper, pagesize
from page_header(get_raw_page('t', 0));