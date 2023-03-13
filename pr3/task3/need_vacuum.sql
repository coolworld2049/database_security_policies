create or replace function get_value(param text, reloptions text[], relkind "char")
    returns float
as
$$
select coalesce(
           -- если параметр хранения задан, то берем его
               (select option_value
                from pg_options_to_table(reloptions)
                where option_name = case
                                        -- для toast-таблиц имя параметра отличается
                                        when relkind = 't' then 'toast.'
                                        else ''
                                        end || param),
           -- иначе берем значение конфигурационного параметра
               current_setting(param)
           )::float;
$$ language sql;


drop view need_vacuum;
create view need_vacuum as
select st.schemaname || '.' || st.relname tablename,
       st.n_dead_tup                      dead_tup,
       get_value('autovacuum_vacuum_threshold', c.reloptions, c.relkind) +
       get_value('autovacuum_vacuum_scale_factor', c.reloptions, c.relkind) * c.reltuples
                                          max_dead_tup,
       st.last_autovacuum
from pg_stat_all_tables st,
     pg_class c
where c.oid = st.relid
  and c.relkind in ('r', 'm', 't');
