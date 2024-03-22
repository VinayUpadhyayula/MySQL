select first_name, phone# from customers c where exists
 (select * from Purchases pr where 
    cid = c.cid and (pr.unit_price *pr.quantity)>=100 and 
    to_char(pr.pur_time,'Month') like 'October%' and to_char(pr.pur_time,'YYYY') = '2022'
 );