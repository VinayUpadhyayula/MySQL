select pid, name
from
(
    select products.pid as pid, products.name as name, max(purchases.pur_time) as pur_time
    from purchases inner join products on purchases.pid = products.pid
    group by products.pid, products.name
)
order by pur_time
fetch first 1 rows only;