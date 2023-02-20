truncate table t;
drop index if exists name_idx;

-----------------------------------------------------------------------------------------------------------------------

insert into t
values (1, (select random_string(1500)));

select *
from t_v;

update t
set name = (select random_string(1500))
where id = 1;

select *
from t_v;

update t
set name = (select random_string(1500))
where id = 1;

select *
from t_v;

update t
set name = (select random_string(1500))
where id = 1;

select *
from t_v;

update t
set name = (select random_string(1500))
where id = 1;

select *
from t_v;

update t
set name = (select random_string(1500))
where id = 1;

select *
from t_v;

update t
set name = (select random_string(1500))
where id = 1;

select *
from t_v;
