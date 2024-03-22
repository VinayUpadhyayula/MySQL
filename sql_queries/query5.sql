select pur# from Purchases pr where exists 
(
    select * from customers c  where c.cid = pr.cid and c.first_name like 'K%' and exists
    (
        select * from Products p where pid = pr.pid and cid = c.cid and p.orig_price < 15 and exists
        (
         select * from employees e where eid = pr.eid and e.telephone# like '888%'
        )
    )
);