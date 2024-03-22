select concat(first_name,last_name) as customer_name from customers c where c.visits_made>1 and not exists
(
    select * from purchases pr where pr.cid = c.cid and floor((sysdate - pr.pur_time))<=100
);