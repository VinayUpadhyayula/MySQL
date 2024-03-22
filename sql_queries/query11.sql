select pid, name as product_name from products p where p.orig_price > 180 and exists
(
 select * from employees e where (e.name like 'A%' or e.name like 'D%') and exists
 (
    select * from purchases pr where pid = p.pid and eid = e.eid
 )
);