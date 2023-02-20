-- ctid является ссылкой на следующую, более новую, версию той же строки. У самой новой, актуальной, версии строки ctid ссылается на саму эту версию
-- xmin и xmax определяют видимость данной версии строки в терминах начального и конечного номеров транзакций.
-- xmin_c, xmin_a, xmax_c, xmax_a содержит ряд битов, определяющих свойства данной версии

select '(0,' || lp || ')'                             as ctid,
       t_xmin                                         as xmin,
       t_xmax                                         as xmax,
       case when (t_infomask & 256) > 0 then 't' end  as xmin_c,
       case when (t_infomask & 512) > 0 then 't' end  as xmin_a,
       case when (t_infomask & 1024) > 0 then 't' end as xmax_c,
       case when (t_infomask & 2048) > 0 then 't' end as xmax_a
from heap_page_items(get_raw_page('users', 0))
order by lp;
