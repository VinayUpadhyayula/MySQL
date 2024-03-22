select pid, name as pname from Products p where (p.qoh-5) >=
p.qoh_threshold and exists 
(
    select * from Prod_Discnt where discnt_category = p.discnt_category and discnt_rate between 0.1 and 0.2 and exists
    (
        select * from Purchases where pid = p.pid
    )
);