select c.cid, c.first_name, (select sum(payment) from purchases pr where pr.cid = c.cid) as "total amount spent" from customers c where c.cid in 
(
    select cid from purchases where cid = c.cid
)order  by "total amount spent" desc
fetch first 4 rows only;