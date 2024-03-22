select pid, name as pname from Products p where exists
(
    select * from Purchases pr where pid = p.pid and pr.unit_price < 100.0 and to_char(pr.pur_time,'YYYY') = '2022'
    and to_char(pr.pur_time,'Month') in ('August','September')
);
