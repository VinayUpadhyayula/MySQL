select cid from customers c where cid in  
(
    select pr.cid from products p inner join purchases pr on p.pid =pr.pid where (p.orig_price>=15 and p.orig_price<=20) and 
       to_char(pr.pur_time,'MM/YYYY') = '08/2022'
);